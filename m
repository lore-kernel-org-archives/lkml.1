Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645Ab0A3Idm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0A3Idm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 03:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319Ab0A3Idl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 03:33:41 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51668 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0A3Idl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 03:33:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ICR+HxUbTPniM2uhhAQNeiZGdiobP865PnFhUVrR7I+1RvS1jbzBp8Uchgv3tA7Hsq
         k/BusjB/kiA8XLAvQh5QPQ4MqyZpk0NSDzMLPD9NABd524BpMZQE4h27wFIdCs+V3trC
         M6G0Xkvw/YiA4OKq+379kQ/440uQQqqyxmXqQ=
Subject: Re: debug: nt_conntrack and KVM crash
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>
In-Reply-To: <1264836971.7499.4.camel@tonnant>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant>  <1264816777.2793.510.camel@tonnant>
	 <1264834704.2919.3.camel@edumazet-laptop> <1264836971.7499.4.camel@tonnant>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jan 2010 09:33:35 +0100
Message-ID: <1264840415.2919.19.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 30 janvier 2010 à 02:36 -0500, Jon Masters a écrit :

> I'll play later. Right now, I'm looking over every iptables/ip call
> libvirt makes - it explicitly plays with the netns for the loopback,
> which looks interesting. Supposing it does cause the hashtables to get
> unintentionally zereod or the sizing to get wiped out, we should also
> nonetheless catch the case that the hash function generates a whacko
> number or that the hash size is set to zero when we want to use it.
> 

I asked you if you had multiple namespaces, because I was not sure
conntracking hash was global (shared by all namespaces), or local.

If it is local, then we have a bug, because nf_conntrack_cachep 
is still shared.

Because of SLAB_DESTROY_BY_RCU constraint, we must use a distinct
cachep, or an object can be freed from a namespace and immediatly reused
into another namespace, without lookups being able to notice.




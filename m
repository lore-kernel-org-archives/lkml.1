Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060Ab0A3G6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab0A3G6a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 01:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719Ab0A3G63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 01:58:29 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47764 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab0A3G62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 01:58:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aSvWxhjObvyEGCrOW4v7yc0I0DQVmeciGeFOrl4tcsTU68H7301OkxG88XLaSgYg0w
         tHweI0URp0iK/RMblRSv3c4BDq1PSQ4V3OiK3xWTA8CA3+7ID3XMcBpRH0hzIMjr0SHY
         x9L6hkAPuSnyt/cr3B6lfPhGW19tgi2QNV4lo=
Subject: Re: debug: nt_conntrack and KVM crash
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>
In-Reply-To: <1264816777.2793.510.camel@tonnant>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant>  <1264816777.2793.510.camel@tonnant>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jan 2010 07:58:24 +0100
Message-ID: <1264834704.2919.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 janvier 2010 à 20:59 -0500, Jon Masters a écrit :
> On Fri, 2010-01-29 at 20:57 -0500, Jon Masters wrote:
> 
> > Ah so I should have realized before but I wasn't looking at valid values
> > for the range of the hashtable yet, nf_conntrack_htable_size is getting
> > wildly out of whack. It goes from:
> > 
> > (gdb) print nf_conntrack_hash_rnd
> > $1 = 2688505299
> > (gdb) print nf_conntrack_htable_size
> > $2 = 16384
> > 
> > nf_conntrack_events: 1
> > nf_conntrack_max: 65536
> > 
> > Shortly after booting, before being NULLed shortly after starting some
> > virtual machines (the hash isn't reset, whereas it is recomputed if the
> > hashtable is re-initialized after an intentional resizing operation):
> 
> I mean the *seed* isn't changed, so I don't think it was resized
> intentionally. I wonder where else htable_size is fiddled with.
> 
> Jon.
> 
> 

This rings a bell here, since another crash analysis on another problem
suggested to me a potential problem with read_mostly and modules, but I
had no time to confirm the thing yet.

Could you try changing


net/netfilter/nf_conntrack_core.c:57:unsigned int nf_conntrack_htable_size __read_mostly;
to
net/netfilter/nf_conntrack_core.c:57:unsigned int nf_conntrack_htable_size ;




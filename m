Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753Ab0A2JKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab0A2JKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870Ab0A2JKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:10:38 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:41039 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab0A2JKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:10:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tt6KIL6w0IDUy1RdRR6D4pOvlNbDktlD7rT4ZuKsQYPVGl8debr1THaJSAv/fwYFfH
         S9TtDXf9OEy7l2PmNJVCClMvE6aFzviSATIhPRHYagUjwpu+AlnH7VNCh3d9SjyClimb
         Xu3zkxJvDIM+YXu+u1DWc4jW3C20W9cSKQ7kk=
Subject: Re: PROBLEM: reproducible crash KVM+nf_conntrack all recent 2.6
 kernels
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Patrick McHardy <kaber@trash.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
In-Reply-To: <1264754565.2793.405.camel@tonnant>
References: <1264657559.2793.103.camel@tonnant>
	 <1264658364.2793.105.camel@tonnant>  <4B6180D1.6050609@trash.net>
	 <1264720891.2793.205.camel@tonnant>  <1264727492.2793.207.camel@tonnant>
	 <1264754565.2793.405.camel@tonnant>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 10:10:32 +0100
Message-ID: <1264756232.3184.10.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 janvier 2010 à 03:42 -0500, Jon Masters a écrit :
> Hi,
> 
> So I did some poking (still trying to figure out netfilter a little
> internally) and looked over the handling of connection tracking. The
> oops reports I have been getting generally lie in __nf_conntrack_find,
> specifically within a hlist iterator that looks up the information for
> the current connection in a per-net namespace hashtable (under RCU, it's
> been locked already by the time we get in here). Here's the piece:
> 
>         hlist_nulls_for_each_entry_rcu(h, n, &net->ct.hash[hash],
> hnnode) {
>                 if (nf_ct_tuple_equal(tuple, &h->tuple)) {
>                         NF_CT_STAT_INC(net, found);
>                         local_bh_enable();
>                         return h;
>                 }
>                 NF_CT_STAT_INC(net, searched);
>         }
> 
> Instrumenting the kernel at the moment and then setting up more of a
> debugging environment to poke at what goes wrong here. Perhaps there's
> some broken RCU assumption - I just spent the last few hours reading
> over netfilter source and Paul's RCU docs again to brush up.
> 
> Perhaps you netdev folks can let me know if there's a handy netfilter
> debugging guide somewhere.
> 
> Jon.
> 
> 

Jon, do you have multiple network namespace active on your machine, when
crash occurs ?




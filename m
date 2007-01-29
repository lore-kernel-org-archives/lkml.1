Return-Path: <linux-kernel-owner+w=401wt.eu-S933139AbXA2F3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139AbXA2F3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 00:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933141AbXA2F3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 00:29:36 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3652 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933139AbXA2F3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 00:29:35 -0500
Date: Mon, 29 Jan 2007 16:29:29 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm1
Message-ID: <20070129052929.GA29456@gondor.apana.org.au>
References: <45BD2424.7020604@googlemail.com> <E1HBOtk-0007dS-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HBOtk-0007dS-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 04:17:44PM +1100, Herbert Xu wrote:
> Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
> > Jan 28 22:58:29 euridica kernel: BUG: using smp_processor_id() in preemptible [00000001] code: yum-updatesd/2846
> > Jan 28 22:58:29 euridica kernel: caller is nf_conntrack_in+0x363/0x47f [nf_conntrack]
> > Jan 28 22:58:29 euridica kernel:  [<c01053c6>] show_trace_log_lvl+0x1a/0x2f
> > Jan 28 22:58:29 euridica kernel:  [<c0105ad6>] show_trace+0x12/0x14
> > Jan 28 22:58:29 euridica kernel:  [<c0105b98>] dump_stack+0x16/0x18
> > Jan 28 22:58:29 euridica kernel:  [<c0207803>] debug_smp_processor_id+0xb3/0xc8
> > Jan 28 22:58:29 euridica kernel:  [<fdbf8ad0>] nf_conntrack_in+0x363/0x47f [nf_conntrack]
> > Jan 28 22:58:29 euridica kernel:  [<fd9c32c4>] ipv4_conntrack_local+0x53/0x5b [nf_conntrack_ipv4]
> > Jan 28 22:58:29 euridica kernel:  [<c02f2286>] nf_iterate+0x36/0x67
> > Jan 28 22:58:29 euridica kernel:  [<c02f241b>] nf_hook_slow+0x52/0xbe
> 
> This shouldn't have happened.  nf_hook_slow calls nf_iterate and
> therefore everything under it with preemption disabled.  So something
> must've reenabled it before hitting nf_conntrack_in.

Does mm now have the preemptible RCU stuff? If so that would certainly
explain this.

IIRC Ingo had made fixes for the networking stack in his rt tree since
the networking code assumes in lots of places that rcu_read_lock
disables preemption.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

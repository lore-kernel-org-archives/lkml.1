Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbXD0WUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbXD0WUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757497AbXD0WUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:20:48 -0400
Received: from gw.goop.org ([64.81.55.164]:54707 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489AbXD0WTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:19:52 -0400
Message-ID: <46327706.80508@goop.org>
Date: Fri, 27 Apr 2007 15:19:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [PATCH 22/25] xen: xen-netfront: use skb.cb for storing private
 data
References: <20070423215638.563901986@goop.org> <20070423215713.550883195@goop.org> <20070424014528.GA27789@gondor.apana.org.au> <462D88EF.9030007@goop.org> <20070424055731.GA30018@gondor.apana.org.au>
In-Reply-To: <20070424055731.GA30018@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Sure thing.  I'll look over it soon.
>
> Actually there is one thing I'd like to see changed first up: I noticed
> that you've stripped out the checksum hack which is in the main Xen tree.
> We actually have the code in net-2.6.22 (which is also in mm) that lets
> you use CHECKSUM_PARTIAL on received packets without having to do that
> hack.
>
> Here's the patch that I've been testing so far.  It's against the Xen
> source, but should be easy to adapt to your version as well.
>
> I just thought about this again, and in fact we need this change for
> correctness as well as performance.  Because not setting ip_summed
> to CHECKSUM_PARTIAL in netfront is not going to stop netback from
> sending CHECKSUM_PARTIAL packets to us.  If these packets are then
> routed/bridged back to netback, they'll have the wrong checksum.
>   

OK, I've been sitting on this in the hope that I'll suddenly see the
light and work out what you're talking about - but apparently that's not
going to happen.  So, some questions:

   1. Does this patch change the dom0 <-> domU interface?  or does it
      fix something that's currently broken?
   2. Can just apply the netfront part to the pv_ops kernel, or does it
      require the corresponding dom0 patch to be applied as well?

Thanks,
    J

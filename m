Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbXJGThG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbXJGThG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 15:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbXJGTgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 15:36:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:15322 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbXJGTgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 15:36:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fbakBPqXtGUCf0VWj7GjUa+5jUW073G8xrZFnGLxLkA/R2rS+WzLZSY5FTWoYYnNSIEV61MiaQ+FRMSqV6Pp6x7P91z2vOC0sRc/JOfcnTuRjhNYFkfaGIa3dvuJpCB6+sgTL03znFrt+VOViM4tSheozphAU2BC6BDowsZE/r8=
Message-ID: <86802c440710071236h137a5331i78f795d7a04c69e@mail.gmail.com>
Date: Sun, 7 Oct 2007 12:36:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH 2/5] forcedeth: interrupt handling cleanup
Cc: netdev@vger.kernel.org, "Ayaz Abdulla" <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4708C5BD.8090402@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071006151250.GA17020@havoc.gtf.org>
	 <20071006151400.GB17488@havoc.gtf.org>
	 <86802c440710062143x3bb801c3obb91292208073588@mail.gmail.com>
	 <4708C5BD.8090402@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/7/07, Jeff Garzik <jeff@garzik.org> wrote:
> Yinghai Lu wrote:
> > On 10/6/07, Jeff Garzik <jeff@garzik.org> wrote:
> >> commit a606d2a111cdf948da5d69eb1de5526c5c2dafef
> >> Author: Jeff Garzik <jeff@garzik.org>
> >> Date:   Fri Oct 5 22:56:05 2007 -0400
> >>
> >>     [netdrvr] forcedeth: interrupt handling cleanup
> >>
> >>     * nv_nic_irq_optimized() and nv_nic_irq_other() were complete duplicates
> >>       of nv_nic_irq(), with the exception of one function call.  Consolidate
> >>       all three into a single interrupt handler, deleting a lot of redundant
> >>       code.
> >>
> >>     * greatly simplify irq handler locking.
> >>
> >>       Prior to this change, the irq handler(s) would acquire and release
> >>       np->lock for each action (RX, TX, other events).
> >>
> >>       For the common case -- RX or TX work -- the lock is always acquired,
> >>       making all successive acquire/release combinations largely redundant.
> >>
> >>       Acquire the lock at the beginning of the irq handler, and release it at
> >>       the end of the irq handler.  This is simple, easy, and obvious.
> >>
> >>     * remove irq handler work loop.
> >>
> >>       All interesting events emanating from the irq handler either have
> >>       their own work loops, or they poke a timer into action.
> >>
> >>       Therefore, delete the pointless master interrupt handler work loop.
> >>
> >>     Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> >>
> Do you have ideas/suggestions for a different method?

in the e1000 driver, it has seperate handler for msi and ioapic.

but in forcedeth, the nv_nic_irq_optimized keep check msi_flags...,
with num of msi interrupt number, that could cause cpu loading get a
little bit high..., even the network performance is ok.

YH

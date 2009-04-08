Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbZDHGVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbZDHGVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758758AbZDHGU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:20:59 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47799 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758594AbZDHGU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:20:58 -0400
Date: Wed, 8 Apr 2009 08:20:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jos Houtman <jos@hyves.nl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads
Message-ID: <20090408062056.GP5178@kernel.dk>
References: <C60129DA.EB0F%jos@hyves.nl> <20090408004410.GA18679@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408004410.GA18679@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08 2009, Wu Fengguang wrote:
> [CC Jens]
> 
> On Tue, Apr 07, 2009 at 10:03:38PM +0800, Jos Houtman wrote:
> > 
> > I tried the write-back branch from the 2.6-block tree.
> > 
> > And I can atleast confirm that it works, atleast in relation to the
> > writeback not keeping up when the device was congested before it wrote a
> > 1024 pages. 
> > 
> > See: http://lkml.org/lkml/2009/3/22/83  for a bit more information.
> 
> Hi Jos, you said that this simple patch solved the problem, however you
> mentioned somehow suboptimal performance. Can you elaborate that?  So
> that I can push or improve it.
> 
> Thanks,
> Fengguang
> ---
>  fs/fs-writeback.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- mm.orig/fs/fs-writeback.c
> +++ mm/fs/fs-writeback.c
> @@ -325,7 +325,8 @@ __sync_single_inode(struct inode *inode,
>  				 * soon as the queue becomes uncongested.
>  				 */
>  				inode->i_state |= I_DIRTY_PAGES;
> -				if (wbc->nr_to_write <= 0) {
> +				if (wbc->nr_to_write <= 0 ||
> +				    wbc->encountered_congestion) {
>  					/*
>  					 * slice used up: queue for next turn
>  					 */
> 
> > But the second problem seen in that thread, a write-starve-read problem does
> > not seem to solved. In this problem the writes of the writeback algorithm
> > starve the ongoing reads, no matter what io-scheduler is picked.

What kind of SSD drive are you using? Does it support queuing or not?

-- 
Jens Axboe


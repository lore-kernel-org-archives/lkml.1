Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbZKKUjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbZKKUjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbZKKUjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:39:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37485 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898AbZKKUjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:39:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jens Axboe <jens.axboe@oracle.com>, Romit Dasgupta <romit@ti.com>
Subject: Re: [PATCH 1/1]: Thaws refrigerated bdi flusher threads before invoking kthread_stop on them
Date: Wed, 11 Nov 2009 21:41:12 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc6-tst; KDE/4.3.1; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <1257928216.15415.57.camel@boson> <200911111230.58479.rjw@sisk.pl> <20091111193719.GR8742@kernel.dk>
In-Reply-To: <20091111193719.GR8742@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911112141.12437.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 November 2009, Jens Axboe wrote:
> On Wed, Nov 11 2009, Rafael J. Wysocki wrote:
> > On Wednesday 11 November 2009, Pavel Machek wrote:
> > > On Wed 2009-11-11 14:00:16, Romit Dasgupta wrote:
> > > > Kicks out frozen bdi flusher task out of the refrigerator when the flusher task
> > > > needs to exit.
> > > 
> > > 
> > > > Signed-off-by: Romit Dasgupta <romit@ti.com>
> > > 
> > > Ok, its slightly "interesting", but better than modifying common
> > > code. Looks ok to me.
> > > 
> > > ACK.
> > 
> > Agreed.
> > 
> > Jens, any objections?
> 
> Nope, looks fine to me. Though I'd probably prefer just doing an
> unconditional PF_FROZEN clear.
> 
> /*
>  * Force unfreeze of the bdi threads before stopping it, since otherwise
>  * it would never exit if it is stuck in the refrigerator.
>  */
> list_for_each_entry(wb, &bdi->wb_list, list) {
> 	wb->task->flags &= ~PF_FROZEN;
> 	kthread_stop(wb->task);
> }
> 
> And the comment too, it's not enough to stuff this into the commit.

The last version had the changelog fixed.

Romit, please rework as suggested by Jens and resubmit.

Thanks,
Rafael

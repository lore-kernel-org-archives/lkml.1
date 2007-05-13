Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbXEMSNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbXEMSNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbXEMSNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:13:30 -0400
Received: from brick.kernel.dk ([80.160.20.94]:8488 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbXEMSN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:13:29 -0400
Date: Sun, 13 May 2007 20:12:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: "Yin,Fengwei" <yfw.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Is this a preempt issue in drivers/input/evdev.c
Message-ID: <20070513181225.GV4629@kernel.dk>
References: <1178939925.14713.16.camel@localhost.localdomain> <200705120105.40699.dtor@insightbb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705120105.40699.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12 2007, Dmitry Torokhov wrote:
> Hi,
> 
> On Friday 11 May 2007 23:18, Yin,Fengwei wrote:
> > 
> > So if the evdev_release() is preempted at the point marked by another
> > process which will open the evdev, which will make operation sequence
> > like:
> > 
> >    --evdev->open in evdev_release()
> >          -----> preempted
> > 	                            evdev->open++ and input_open_devie()
> > 	 <----- reschedule 
> > 	input_close_device()
> > 
> > Should we introduce a mutex here? Or do I miss something? Thanks.
> > 
> 
> Locking is completely absent in evdev. There was a patch introducing
> locking in recent -mm's but it got dropped. I need to refresh it.

How did stuff like that ever get merged, btw? I still have a completely
trivially oopsable rmmod psmouse problem, I hope it'll get fixed for
2.6.22.

-- 
Jens Axboe


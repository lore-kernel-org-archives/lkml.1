Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbZJ1OH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbZJ1OH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 10:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZJ1OH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 10:07:28 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40832 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbZJ1OH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 10:07:27 -0400
Date: Wed, 28 Oct 2009 15:07:31 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32-rc5: surprise removal of USB mass storage, and whole
	system goes to hell
Message-ID: <20091028140731.GP10727@kernel.dk>
References: <20091027211951.GA21967@elf.ucw.cz> <alpine.LRH.2.00.0910280212510.25075@twin.jikos.cz> <20091028095537.GD10727@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028095537.GD10727@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28 2009, Jens Axboe wrote:
> On Wed, Oct 28 2009, Jiri Kosina wrote:
> > On Tue, 27 Oct 2009, Pavel Machek wrote:
> > 
> > > I did remove one harddrive w/o unmounting, and now the whole system
> > > becomes unusable :-(: (whole dmesg attached).
> > > 
> > > Stuff like "sync" hangs, and I'll probably have to reboot soon.
> > 
> > From the traces it seems that it might be related to the new per-bdi 
> > writeback stuff ... adding Jens to CC.
> 
> It looks like the IO isn't being errored on the device side, or perhaps
> it just got stuck. Pavel, if you can reproduce, please try with this
> tracing patch. Apply it, and then do something ala:
> 
> # cd /sys/kernel/debug/tracing
> # echo 0 events/enable
> # echo 1 events/writeback/enable
> # echo 0 > trace
> 
> then start the act of reproducing, and finally
> 
> # cat trace > /tmp/foo
> 
> and send the output of foo here. Thanks!

I can reproduce this. The writeback work gets queued, we notice the task
isn't there and wake up the default task. And then nothing happens, I
wonder if the bdi is gone.

I'll fiddle around with this.

-- 
Jens Axboe


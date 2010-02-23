Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab0BWQmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 11:42:46 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36093 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753098Ab0BWQmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 11:42:44 -0500
Date: Tue, 23 Feb 2010 11:42:44 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Testing for dirty buffers on a block device
In-Reply-To: <20100223155803.GN1025@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.1002231137520.1308-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, Jens Axboe wrote:

> > P.S.: Jens, given a pointer to a struct gendisk or to a struct
> > request_queue, is there a good way to tell whether there any dirty
> > buffers for that device waiting to be written out?  This is for
> > purposes of runtime power management -- in the initial implementation,
> > I want to avoid powering-down a block device if it is open or has any
> > dirty buffers.  In other words, only completely idle devices should be
> > powered down (a good example would be a card reader with no memory card 
> > inserted).
> 
> There's no fool proof way. For most file systems I think you could get
> away with checking the q->bdi dirty lists to see if there's anything
> pending. But that wont work always, if the fs uses a different backing
> dev info than then queue itself.

That's not what I meant.  Dirty buffers on a filesystem make no 
difference because they always get written out when the filesystem is 
unmounted.  The device file remains open as long as the filesystem 
is mounted, which would prevent the device from being powered down.

I was asking about dirty buffers on a block device that isn't holding a 
filesystem -- where the raw device is being used directly for I/O.

Alan Stern


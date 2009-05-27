Return-Path: <linux-kernel-owner+w=401wt.eu-S1762434AbZE0WTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762434AbZE0WTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759039AbZE0WSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:18:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46510 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751182AbZE0WSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:18:54 -0400
Date: Wed, 27 May 2009 18:18:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Kay Sievers <kay.sievers@vrfy.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
In-Reply-To: <m1ljoi6w1a.fsf@fess.ebiederm.org>
Message-ID: <Pine.LNX.4.44L0.0905271816200.2669-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Eric W. Biederman wrote:

> >> I think I have the fix to that...
> >
> > The fix is to delete the target when its children are deleted, and not
> > wait until the children are released.
> 
> I think I can do both.
> 
> I am currently working on a patchset which at the VFS layer disconnects a
> fd from an underlying device.  It does the necessary use count tracking
> and when the disconnect is done it returns.  As part of the disconnect it
> calls the release method.
> 
> We already do this in at least sysfs, proc, sysctl, and sound.  So I
> figure it is time to move this into some generic code so we don't need
> to duplicate the bugs and the insanities.
> 
> Once merged it would take just a few lines of code to use this functionality.

That's good, but it isn't enough to solve this problem.  Even though
user programs might not be able to pin the device by holding the file
open any more, other mechanisms (internal to the kernel) could have the
same effect.  Only a short delay is needed.

The underlying cause should be fixed properly.

Alan Stern


Return-Path: <linux-kernel-owner+w=401wt.eu-S933138AbXCMUKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138AbXCMUKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933145AbXCMUKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:10:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49312 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933138AbXCMUKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:10:01 -0400
Date: Tue, 13 Mar 2007 16:09:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Hugh Dickins <hugh@veritas.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       <gregkh@suse.de>, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
In-Reply-To: <Pine.LNX.4.64.0703131854130.6506@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.44L0.0703131604160.7744-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007, Hugh Dickins wrote:

> On Tue, 13 Mar 2007, Alan Stern wrote:
> > 
> > The consensus is that we would be better off keeping Oliver's original 
> > patch without your silly change, and instead fixing the particular method 
> > call that deadlocked.  Can you please try out the patch below with 
> > everything else as it was before?  It should solve your problem.
> 
> Yep, it works fine with your patch in and my silly reverted, thanks.
> But (I was about to say, even before seeing Cornelia's reply, honest!)
> I think you do need to check (audit the source? or is some runtime
> check possible?) for other such "suicidal" sysfs files, which
> seemed to (sysfs-ignorant) me to pose the real problem.

A runtime check wouldn't detect anything until someone tried to use the 
file -- at which point the process would deadlock anyway.

On the other hand, a quick survey of the kernel source shows that
DEVICE_ATTR is used over 1500 times.  Auditing all of them is not a job
for the faint-of-heart!

Alan Stern


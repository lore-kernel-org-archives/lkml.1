Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbXCMVUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbXCMVUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 17:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933372AbXCMVUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 17:20:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35467 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933368AbXCMVUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 17:20:45 -0400
Date: Tue, 13 Mar 2007 17:20:43 -0400 (EDT)
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
In-Reply-To: <Pine.LNX.4.64.0703132052560.24739@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.44L0.0703131708090.2509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007, Hugh Dickins wrote:

> On Tue, 13 Mar 2007, Alan Stern wrote:
> > 
> > On the other hand, a quick survey of the kernel source shows that
> > DEVICE_ATTR is used over 1500 times.  Auditing all of them is not a job
> > for the faint-of-heart!
> 
> Indeed, and faint-hearted Hugh wasn't intending to do so: but
> stout-hearted Alan will need to, won't he, before his patch can go in?

Allow me to point out that the original patch is Oliver's (although I
helped), and it doesn't need to go in -- it needs not to be removed.

Furthermore, I have better things to do with the next month of my time 
than auditing hundreds of routines I don't understand for behavior I 
probably won't be able to recognize.  (Although at 50 a day... hmmm, 
maybe.)

This sounds more like a job for kernel-janitors!


On Tue, 13 Mar 2007, Dmitry Torokhov wrote:

> I think we could rely on subsystems maintainers to let us know if
> there are potential problems. For example I can tell that neither
> input, serio nor gameport subsystems use sysfs to destroy their  
> devices (action on sysfs may cause some other device to be destroyed
> but that should be ok, only self-destruction is not allowed, right?)

Very good points.  USB doesn't do anything like that either.  And right, 
it's okay for a method to destroy other devices; it just can't do anything 
that would lead to its own unregistration.

Alan Stern


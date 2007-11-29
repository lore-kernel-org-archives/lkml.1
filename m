Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbXK2QIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbXK2QIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbXK2QIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:08:07 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37532 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756234AbXK2QIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:08:04 -0500
Date: Thu, 29 Nov 2007 11:08:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Raymano Garibaldi <raymano@faunos.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       <kirk@faunos.com>
Subject: Re: [linux-usb-devel] [BUG] USB_PERSIST
In-Reply-To: <1618816c0711290353h3c0e4192we5909725d1aff3e9@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0711291102290.4516-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Raymano Garibaldi wrote:

> The feature does work as long as the device remains plugged in and
> that is what I have said in my previous postings too. What I'm saying
> that should work and worked under 2.6.21 and is not working currently
> is the ability to unplug and plug back in the device while the
> computer is suspended before resuming without losing the mount.

Okay, guess I misunderstood what you wrote before.

The patch below for 2.6.23 should do what you want (and more besides).  
It forces the USB Persist feature to apply to all persist-enabled 
devices, whether they were unplugged or not.

There's no chance of this getting accepted into the official kernel in 
such a simple form, but at least it will allow you to do what you want.

Alan Stern


--- 2.6.23/drivers/usb/core/driver.c1	2007-11-29 10:57:36.000000000 -0500
+++ 2.6.23/drivers/usb/core/driver.c	2007-11-29 11:01:44.000000000 -0500
@@ -1550,6 +1550,9 @@
 		if (!(udev->reset_resume && udev->do_remote_wakeup))
 			return -EPERM;
 	}
+
+	/* Force all system resumes to be reset-resumes */
+	udev->reset_resume = 1;
 	return usb_external_resume_device(udev);
 }
 


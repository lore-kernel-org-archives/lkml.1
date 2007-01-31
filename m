Return-Path: <linux-kernel-owner+w=401wt.eu-S1030221AbXAaQMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030221AbXAaQMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030225AbXAaQMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:12:55 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:20110 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030221AbXAaQMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:12:54 -0500
Date: Wed, 31 Jan 2007 17:12:51 +0100 (MET)
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] question on resume()
User-Agent: KMail/1.9.1
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.osdl.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0701311048560.3803-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0701311048560.3803-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311713.04104.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GP
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 31. Januar 2007 16:54 schrieb Alan Stern:
> On Wed, 31 Jan 2007, Pavel Machek wrote:

> > "cease IO"? No, I believe it is enough not to start new I/O. Userspace
> > is frozen at that point, it can't ask you to do I/O.
> 
> There may be I/O requests sitting in a queue, already submitted by
> userspace.  The suspend method should wait for existing I/O to complete
> and stop processing new entries from the queue.

As far as I understand it now, a frozen process will be in the refrigerator.
Thus it cannot be blocking somewhere else in kernel space. Yet we cannot
be sure there's no queued IO, as theres aio.


> > > On resume():
> > > 
> > > 1. Don't worry about TASK_UNINTERRUPTIBLE
> > > 2. Do not restart IO that may call wake_up_interruptible()
> > > 
> > > When do we restart such IO?
> > 
> > We reuse signal handling code to do that for us. It is same situation
> > as when someone signals task doing I/O.
> 
> Again you misunderstood the question.  The driver must start queued I/O
> when its resume() method is called.  It should then be okay for the driver
> to call wake_up_interruptible(), even before tasks are unfrozen.

Isn't there some code in usbfs that'll do homegrown aio and deliver a
signal to a process if io is completed?

	Regards
		Oliver

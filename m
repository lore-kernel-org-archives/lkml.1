Return-Path: <linux-kernel-owner+w=401wt.eu-S932371AbXAaJEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbXAaJEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 04:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932422AbXAaJEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 04:04:21 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:46817 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371AbXAaJET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 04:04:19 -0500
Date: Wed, 31 Jan 2007 10:04:08 +0100 (MET)
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: question on resume()
User-Agent: KMail/1.9.1
Cc: Oliver Neukum <oliver@neukum.name>, linux-kernel@vger.kernel.org,
       nigel@nigel.suspend2.net, pm list <linux-pm@lists.osdl.org>
References: <200701291206.39637.oneukum@suse.de>
 <200701310940.26040.oliver@neukum.name> <200701310949.04110.rjw@sisk.pl>
In-Reply-To: <200701310949.04110.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311004.19477.oneukum@suse.de>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GP
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 31. Januar 2007 09:49 schrieb Rafael J. Wysocki:
> On Wednesday, 31 January 2007 09:40, Oliver Neukum wrote:
> > Am Mittwoch, 31. Januar 2007 09:33 schrieb Rafael J. Wysocki:
> > > On Tuesday, 30 January 2007 23:32, Rafael J. Wysocki wrote:
> > 
> > > > Generally, you are safe if your driver only calls wake_up() from a process
> > > > context, but not from .resume() or .suspend() routines (or from an
> > > > unfreezeable kernel thread).
> > > 
> > > Ah, sorry, I've just realized I was wrong.  Processes in TASK_UNINTERRUPTIBLE
> > > cannot be frozen!  So, the above only applies to wake_up_interruptible().
> > 
> > So the kernel will wait for tasks in TASK_UNINTERRUPTIBLE to finish IO
> > before it calls suspend()? I am confused.
> 
> Yes, it will.  The process freezer can only return success if there are no more
> TASK_UNINTERRUPTIBLE tasks.  Otherwise it fails (after a timeout).

So, this means, on suspend():

1. Don't worry about TASK_UNINTERRUPTIBLE
2. Do worry about TASK_INTERRUPTIBLE
We have to cease IO and must not call wake_up_interruptible()

Isn't that a race until suspend() is called?

On resume():

1. Don't worry about TASK_UNINTERRUPTIBLE
2. Do not restart IO that may call wake_up_interruptible()

When do we restart such IO?

	Regards
		Oliver

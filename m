Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbYBWBb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbYBWBb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 20:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYBWBbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 20:31:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45648 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbYBWBbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 20:31:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Date: Sat, 23 Feb 2008 02:30:03 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802211803290.6236-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802211803290.6236-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802230230.04466.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of February 2008, Alan Stern wrote:
> On Thu, 21 Feb 2008, Rafael J. Wysocki wrote:
> 
> > BTW, below is a simplified version of the patch, without the mutex protecting
> > suspending_task.  I'd like to push it upstream if it looks good.
> 
> It does look good.  Go ahead and push.
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> > Please also have a look at http://bugzilla.kernel.org/show_bug.cgi?id=10030.
> > There seems to be another issue related to us holding devices' semaphores.
> > Namely, it looks like, when the user removes the card, a concurrent thread
> > (from a workqueue) calls device_del() and blocks on the dev->sem held by
> > us and then something else deadlocks with this thread.  I'll be looking into
> > this tomorrow.
> 
> I've been too busy with other things to look at the activity on that 
> bug report.  Tonight or tomorrow...

Unfortunately, I missed your Bugzilla comment at
http://bugzilla.kernel.org/show_bug.cgi?id=10030#c28

Well, in the face of it, I'm considering to remove the code that
acquires device semaphores from the suspend core for now.  Evidently, this
change turns out to be painfully premature.

Also, we have apparent problems with pm_sleep_lock()
being take in device_add() (see
http://bugzilla.kernel.org/show_bug.cgi?id=9874).

Thanks,
Rafael

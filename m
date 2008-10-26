Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbYJZReS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbYJZReS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 13:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYJZReE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 13:34:04 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3481 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752791AbYJZReC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 13:34:02 -0400
Date: Sun, 26 Oct 2008 13:34:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Mikko C." <mikko.cal@gmail.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Bug in workqueues [was: Usb devices randomly aren't detected with
 2.6.28-rc1-git1]
In-Reply-To: <4904A77C.7090805@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0810261327170.25044-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is no longer a USB issue, so I'm asking for help from the general 
kernel community.  Background can be found in Bugzilla #11853.

On Sun, 26 Oct 2008, Mikko C. wrote:

> Mikko C. ha scritto:
> > Alan Stern ha scritto:
> >>
> >> I don't see anything in there that looks particularly suspicious.  
> >> The nature of your errors suggests that the default workqueue has 
> >> crashed or hung, but it shows up okay in the dump.  Are you sure this 
> >> dump was made when the devices failed to appear?
> >>
> >>  
> >
> > Yes, I'm 100% sure.
> >
> >> What happens when you try to rmmod the ALSA modules?  Does rmmod 
> >> crash with an error or does it hang?  If it hangs, can you get 
> >> another task dump showing the hanging process?
> >>   
> >
> > Whenever I try rmmoding something, it hangs (no crash) and I'm not 
> > able to do anything, beside moving the mouse.
> > I posted here: http://marc.info/?l=linux-kernel&m=122502213503239&w=4
> > but that's probably not enough, so I will try getting a full dump.
> >
> Here it is: http://bugzilla.kernel.org/attachment.cgi?id=18452&action=view

The task dump shows rmmod waiting for flush_workqueue().  But the 
events/0 task doesn't appear to be hung, and the task dump taken before 
running rmmod shows events/0 doing something different.

So apparently flush_workqueue() isn't working.

Alan Stern


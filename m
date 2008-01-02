Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbYABQDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbYABQDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbYABQCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:02:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53794 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbYABQCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:02:44 -0500
Date: Wed, 2 Jan 2008 17:02:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: freeze vs freezer
Message-ID: <20080102160234.GA17070@ucw.cz>
References: <4744FD87.7010301@goop.org> <200711262253.35420.rjw@sisk.pl> <20071127053846.GA28884@srcf.ucam.org> <200711271840.24825.rjw@sisk.pl> <8B00F353-983F-40E7-931B-EA73CCD32F0A@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8B00F353-983F-40E7-931B-EA73CCD32F0A@mac.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>>>So how do you handle threads that are blocked on I/O or a lock  
> >>>>during the system freeze process, then?
> >>>
> >>>We wait until they can continue.
> >>
> >>So if I have a process blocked on an unavilable NFS mount, I can't
> >>suspend?
> >
> >That's correct, you can't.
> >
> >[And I know what you're going to say. ;-)]
> 
> Why exactly does suspend/hibernation depend on "TASK_INTERRUPTIBLE"  
> instead of a zero preempt_count()?  Really what we should do is just  
> iterate over all of the actual physical devices and tell each one  
> "Block new IO requests preemptably, finish pending DMA, put the  
> hardware in low-power mode, and prepare for suspend/hibernate".  As  
> long as each driver knows how to do those simple things we can have  
> an entirely consistent kernel image for both suspend and for  
> hibernation.

"each driver" means this is a lot of work. But yes, that is probably
way to go, and patch would be welcome.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

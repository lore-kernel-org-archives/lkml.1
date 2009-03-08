Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbZCHRVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbZCHRVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 13:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbZCHRVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 13:21:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbZCHRVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 13:21:12 -0400
Date: Sun, 8 Mar 2009 10:20:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       =?ISO-8859-15?Q?Arve__Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [linux-pm] [RFC][PATCH][1/8] PM: Rework handling of interrupts
 during suspend-resume (rev. 5)
In-Reply-To: <Pine.LNX.4.44L0.0903072248030.8870-100000@netrider.rowland.org>
Message-ID: <alpine.LFD.2.00.0903081014430.19207@localhost.localdomain>
References: <Pine.LNX.4.44L0.0903072248030.8870-100000@netrider.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 7 Mar 2009, Alan Stern wrote:
> 
> You didn't answer my question.  Why bother to distinguish between 
> "wake-up" interrupts and non-"wake-up" interrupts?
> 
> In other words, why not simply abort the suspend if IRQ_PENDING is set
> for _any_ interrupt during sysdev_suspend()?

.. because some drivers might not actually shut down the hardware until 
they get to "suspend_late"? If even then, for that matter - a driver may 
simply not care, knowing that the hardware will be powered off, and will 
be re-initialized at resume.

The thinking that you have to shut your hardware down at "->suspend()" 
time is a _disease_. There are literally classes of hardware out there 
where that would be an outright _bug_, like for a PCI bridge device. For 
many devices, "suspend()" has to be the phase where you shut down the 
_external_ stuff (eg for a disk controller, it's when you'd flush and stop 
your disks), but the controller itself may well be alive until later.

			Linus

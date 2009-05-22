Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbZEVQmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbZEVQmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 12:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbZEVQm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 12:42:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755654AbZEVQm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 12:42:26 -0400
Date: Fri, 22 May 2009 09:40:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
Message-ID: <alpine.LFD.2.01.0905220926150.3555@localhost.localdomain>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 May 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13329
> Subject		: cifs_close: NULL pointer dereference
> Submitter	: Luca Tettamanti <kronos.it@gmail.com>
> Date		: 2009-05-16 16:28 (1 days old)
> References	: http://marc.info/?l=linux-kernel&m=124249133701702&w=4

Fixed by 703a3b8e5c01cf6fb33c6d8dc99905f889a4e992.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13298
> Subject		: modprobe ipmi_si hangs under 2.6.30-rc5
> Submitter	: Ferenc Wagner <wferi@niif.hu>
> Date		: 2009-05-12 21:28 (5 days old)
> References	: http://marc.info/?l=linux-kernel&m=124216379407177&w=4

Fixed by 9a2845c453d170e4e9b1437fa671dbf39b0e7bd8.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13297
> Subject		: kernel panic -  not syncing : fatel exception in interupt
> Submitter	: rob <rob1@housetosell.net>
> Date		: 2009-05-12 19:34 (5 days old)
> References	: http://marc.info/?l=linux-kernel&m=124216126903309&w=4

This should be fixed by e3b29f05124b07303088795396ff858811d2acb8.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13177
> Subject		: 2.6.30-rc2-git7 build problem
> Submitter	: Martin Knoblauch <spamtrap@knobisoft.de>
> Date		: 2009-04-21 13:39 (26 days old)
> References	: http://marc.info/?l=linux-kernel&m=124032163602132&w=4
> 		  http://lkml.org/lkml/2009/4/27/56

This one really looks like a compiler bug (the undefined symbol is an 
internal gcc one: ".L192"). And the driver that gets it (kl5kusb105) has 
not actually had any changes since 2.6.29 - although header files that it 
includes obviously do have some, so it's entirely possible that some 
infrastructure change causes it to trigger.

Martin hit another bug with his compiler (an ICE in gcc, fixed by commit 
26a9a418237c0b06528941bca693c49c8d97edbe), which is why I'm so willing to 
blame that.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13107
> Subject		: LTP 20080131 causes defunct processes w/2.6.30-rc1
> Submitter	: Kumar Gala <galak@kernel.crashing.org>
> Date		: 2009-04-09 15:43 (38 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b3bfa0cba867f23365b81658b47efd906830879b
> References	: http://marc.info/?l=linux-kernel&m=123929187208953&w=4
> 		  http://lkml.org/lkml/2009/4/10/193
> Handled-By	: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

This one seems to have become "not-a-bug". Yes, LTP used to check that you 
cannot send SIGSTP to init, but people do want to send signals to init 
(especially when they are inside pid-namespace containers), and as long as 
it's only a LTP test that already got modified (and not some actual 
real-life usage), I'm considering this a "test failed because it was 
testing for behavior that we want to change" at least for now.

				Linus

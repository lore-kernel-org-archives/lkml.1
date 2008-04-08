Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbYDHVsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbYDHVsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYDHVsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:48:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37092 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752590AbYDHVs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:48:29 -0400
Message-ID: <47FBE828.3000303@sgi.com>
Date: Tue, 08 Apr 2008 14:48:24 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader
 decompressor
References: <20080405013014.478571000@polaris-admin.engr.sgi.com> <20080405013014.693571000@polaris-admin.engr.sgi.com> <20080405134626.GA15894@mailshack.com> <47FA6478.1070301@sgi.com> <20080407214434.GA5296@mailshack.com> <20080408122007.GA11832@mailshack.com> <20080408134112.GA4277@elte.hu> <47FB8AD2.2040201@sgi.com> <20080408153942.GA26932@elte.hu>
In-Reply-To: <20080408153942.GA26932@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> i've got a bugreport for you though: MAXSMP does not suspend+resume 
> correctly ;-) It gets this far:
> 
> [  146.348790] PM: Syncing filesystems ... done.
> [  146.353488] PM: Preparing system for mem sleep
> [  146.360204] Freezing user space processes ... (elapsed 0.00 seconds) done.
> [  146.367172] Freezing remaining freezable tasks ... (elapsed 0.93 seconds) done.
> [  147.309618] PM: Entering mem sleep
> [  147.313032] Suspending console(s)
> 
> then reboots spontaneously instead of resuming. (I use the 
> suspend+resume self-test feature below to conduct automated 
> suspend/resume tests.)

Here are my test results.  It worked fine on the Intel box, but
hung hard on the AMD box.  I'll do some further testing to narrow
it down.

Thanks,
Mike

------------------------------------------------------------
Intel box:

PM: test RTC wakeup from 'mem' suspend
PM: test RTC wakeup from 'standby' suspend
PM: Syncing filesystems ... done.
PM: Preparing system for standby sleep
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering standby sleep
Suspending console(s)
        .
<whole lot of suspend messages deleted>
        .
processor ACPI0007:07: suspend
        .
        .
processor ACPI0007:00: suspend
        .
PM: suspend devices took 1.072 seconds
ACPI: Preparing to enter system sleep state S1
Disabling non-boot CPUs ...
CPU0 attaching NULL sched-domain.
        .
        .
CPU7 attaching NULL sched-domain.
CPU 1 is now offline
        .
        .
CPU 7 is now offline
SMP alternatives: switching to UP code
CPU0 attaching sched-domain:
 domain 0: span 0
  groups: 0
CPU7 is down
        .
        .
pci 0000:00:00.0: LATE suspend
Back to C!
pci 0000:00:00.0: EARLY resume
        .
        .
Enabling non-boot CPUs ...
CPU0 attaching NULL sched-domain.
SMP alternatives: switching to SMP code
Booting processor 1/4 ip 6000
Initializing CPU#1
        .
        .
CPU1 is up
        .
        .
CPU7 is up
        .
        .
processor ACPI0007:00: resuming
        .
        .
processor ACPI0007:07: resuming
        .
        .
PM: resume devices took 7.256 seconds
PM: Finishing wakeup.
Restarting tasks ... done.


------------------------------------------------------------
AMD box:

PM: test RTC wakeup from 'mem' suspend
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... <7>PM: Adding info for No Bus:mouse0
PM: Adding info for No Bus:event3
PM: Adding info for ieee1394:00e0810000270e1d
PM: Adding info for No Bus:00e0810000270e1d
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00e0810000270e1d]
(elapsed 0.20 seconds) done.
PM: Entering mem sleep
Suspending console(s)

(and the system is hung hard, doesn't even accept sysreq input.)
------------------------------------------------------------

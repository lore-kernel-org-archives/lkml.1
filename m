Return-Path: <linux-kernel-owner+w=401wt.eu-S1761689AbYCFX0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761689AbYCFX0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 18:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbYCFXZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 18:25:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048AbYCFXZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 18:25:53 -0500
Date: Thu, 6 Mar 2008 15:24:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, g.liakhovetski@gmx.de, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       bunk@kernel.org, gregkh@suse.de
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Message-Id: <20080306152415.2e5070e4.akpm@linux-foundation.org>
In-Reply-To: <20080306231331.GJ28006@linux-os.sc.intel.com>
References: <200803030316.07165.rjw@sisk.pl>
	<20080306072704.GA28518@elte.hu>
	<Pine.LNX.4.64.0803062054110.8669@axis700.grange>
	<20080306121127.42ac0682.akpm@linux-foundation.org>
	<20080306125153.d95db2b9.akpm@linux-foundation.org>
	<20080306205951.GA23989@elte.hu>
	<20080306133632.34d77bbc.akpm@linux-foundation.org>
	<20080306145739.817dea8e.akpm@linux-foundation.org>
	<20080306231331.GJ28006@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008 15:13:31 -0800
Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> > sd 1:0:0:0: [sdb] Stopping disk
> > sd 0:0:0:0: [sda] Synchronizing SCSI cache
> > sd 0:0:0:0: [sda] Stopping disk
> > ACPI: PCI interrupt for device 0000:05:00.1 disabled
> > ACPI: PCI interrupt for device 0000:05:00.0 disabled
> > ACPI: Preparing to enter system sleep state S5
> > Disabling non-boot CPUs ...
> > CPU 1 is now offline
> > SysRq : Show State
> >   task                        PC stack   pid father
> 
> I have been looking into a similar issue, which stops my system going into
> standy.

OK.

> > 
> > So CPU 1 is offline.  But the comatose watchdog thread is pinned to CPU 1. 
> > Could this be related to the problem?  By what means is a task which is
> > pinned to a going-away CPU handled?  How is this guy supposed to ever run
> > again?
> 
> move_task_off_dead_cpu() should move that thread to another online cpu. But
> for some reason it isn't running.

hm.  What guarantees that kernel/sched.c:migration_call(CPU_DEAD) is called
before kernel/softlockup.c:cpu_callback(CPU_DEAD)?  Just the ordering in
do_pre_smp_initcalls(), and notifier-chain behaviour, I guess.

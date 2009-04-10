Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbZDJXM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbZDJXM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 19:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZDJXMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 19:12:47 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58403 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbZDJXMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 19:12:46 -0400
Date: Fri, 10 Apr 2009 16:12:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, hugh@veritas.com,
       jmorris@namei.org, akpm@linux-foundation.org
Subject: Re: [2.6.30-rc1] RCU detected CPU 1 stall
Message-ID: <20090410231245.GF6719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200904080057.n380vZAH051872@www262.sakura.ne.jp> <20090410142203.GA6719@linux.vnet.ibm.com> <20090410150353.GL26366@ZenIV.linux.org.uk> <20090410153229.GB6719@linux.vnet.ibm.com> <200904110608.IED21123.FQOVMtSOOHFFLJ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904110608.IED21123.FQOVMtSOOHFFLJ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 06:08:54AM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Paul E. McKenney wrote:
> > Tetsuo, how many tasks did you have on this machine?
> I didn't count how many tasks were running on this machine.
> But the number of tasks should be very low, for this happened during
> the boot stage of Debian Sarge.
> 
> 30 seconds ago from the first stalled message
> 
> [   41.415158] INFO: RCU detected CPU 1 stall (t=4294902646/2500 jiffies)
> [   41.417332] Pid: 3487, comm: khelper Tainted: G        W  2.6.30-rc1 #1
> [   41.417332] Call Trace:
> 
> the system was doing
> 
> [   10.555521] kjournald starting.  Commit interval 5 seconds
> [   10.556727] EXT3 FS on sdb1, internal journal
> [   10.556727] EXT3-fs: recovery complete.
> [   10.557585] EXT3-fs: mounted filesystem with writeback data mode.
> /dev/sdb1 on /usr/src/all type ext3 (rw,noatime,nodiratime)
> Detecting hardware: agpgart pcnet32 piix BusLogic ide_scsi
> Skipping unavailable/built-in agpgart module.
> pcnet32 disabled in configuration.
> Skipping unavailable/built-in piix module.
> Skipping unavailable/built-in BusLogic module.
> Skipping unavailable/built-in ide_scsi module.
> Running 0dns-down to make sure resolv.conf is ok...done.
> Setting up networking...done.
> Starting hotplug subsystem:
>    pci     
>      ignoring pci display device 00:0f.0
> [   16.727603] ------------[ cut here ]------------
> [   16.729910] WARNING: at security/security.c:217 security_vm_enough_memory+0xa0/0xb0()
> 
> > Though I too find it hard to believe that there were enough to chew up
> > two minutes.  Maybe the list got corrupted so that it has a loop?
> 
> I powered off the machine after two minutes, for I thought the loop
> was infinite.

Is this reproducible?  If so, any chance you could try bisecting?

							Thanx, Paul

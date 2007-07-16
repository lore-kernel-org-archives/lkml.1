Return-Path: <linux-kernel-owner+w=401wt.eu-S1763672AbXGPOnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763672AbXGPOnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759812AbXGPOn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:43:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:59199 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759782AbXGPOn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:43:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,542,1175497200"; 
   d="scan'208";a="266816050"
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: david@lang.hm, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <200707161417.50166.rjw@sisk.pl>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	 <200707160059.08277.rjw@sisk.pl>
	 <Pine.LNX.4.64.0707151549200.25614@asgard.lang.hm>
	 <200707161417.50166.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 16 Jul 2007 22:42:30 +0800
Message-Id: <1184596950.24143.28.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 16 Jul 2007 14:43:21.0245 (UTC) FILETIME=[A7DB2CD0:01C7C7B7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-16 at 14:17 +0200, Rafael J. Wysocki wrote:
> > is this  a matter of running some test to find out, or is this a question 
> > for the kexec implemantors?
> 
> Actually, I'd like someone to tell me. ;-)
> 
> I've browsed the kexec code, but haven't found anything related to the devices
> in it.  Perhaps I didn't know where to look ...

There are two stages for kexec. For "normal" kexec, first the
sys_kexe_load is called to load the kernel image, then
sys_reboot(LINUX_REBOOT_CMD_KEXEC) is called to boot the new kernel. The
call chain is as follow:

sys_reboot(LINUX_REBOOT_CMD_KEXEC)
    kernel_kexec
        kernel_restart_prepare
            device_shutdown
        machine_shutdown
        machine_kexec

In device_shutdown, the dev->bus->shutdown or dev->driver->shutdown of
every device is called to put device in quiescent state. In
machine_kexec, the new kernel is booted.

So, for normal kexec, there is no code path for device state saving and
restoring. State of device can be restore after shutdown? I don't think
so.

> I think that the right approach is to separate devices' suspend from the
> devices' hibernation-related operations FIRST.  Then, many different approaches
> to hibernation will be much easier to implement than they are now.
> 
> I've been saying this for weeks now, but no one seems to listen frankly I'm
> tired of repeating it:

I agree with you on this. :)

> If we want to improve things, let's do that IN AN ORDERED WAY.  If everyone
> will come up with a new idea every two days, we won't be able to get anything
> actually _done_.

Yes, and I am very glad to collaborate with everybody who is interested
in this subject. But I think we should try to verify our idea with code
as early as possible. Now, I am trying to implement a prototype of
kexec/kdump based image writing/reading mechanism to verify the
feasibility. (I suppose you are working on separating device suspend and
device hibernate).

What do you think about the pattern of collaboration?

At last, thank you very much for your valuable reminding in the mail of
"hibernation considerations".

Best Regards,
Huang Ying

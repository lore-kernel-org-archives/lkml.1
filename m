Return-Path: <linux-kernel-owner+w=401wt.eu-S2993166AbXCJDAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993166AbXCJDAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 22:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993169AbXCJDAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 22:00:32 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57992 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993166AbXCJDAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 22:00:31 -0500
Date: Fri, 9 Mar 2007 19:00:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.21-rc3-mm2: BUG: at drivers/pci/pci.c:679 pci_restore_state
 during suspend testing
Message-Id: <20070309190009.20b912a6.akpm@linux-foundation.org>
In-Reply-To: <200703090113.14627.rjw@sisk.pl>
References: <200703090113.14627.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 9 Mar 2007 01:13:14 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> I get the following traces from 2.6.21-rc3-mm2 during the "resume" phase
> of testing with 'echo test > /sys/power/disk && echo disk > /sys/power/state':
> 
> acpi thermal:00: resuming
> pci 0000:00:00.0: resuming
> pcieport-driver 0000:00:01.0: resuming
> BUG: at drivers/pci/pci.c:679 pci_restore_state()
> 
> Call Trace:
>  [<ffffffff803ab3e9>] pci_restore_state+0x229/0x270
>  [<ffffffff803b10f9>] pcie_portdrv_restore_config+0x19/0x40
>  [<ffffffff803b1171>] pcie_portdrv_resume+0x11/0x20
>  [<ffffffff803ad92c>] pci_device_resume+0x2c/0x70
>  [<ffffffff80411d41>] resume_device+0xe1/0x160
>  [<ffffffff80411e69>] dpm_resume+0xa9/0x110
>  [<ffffffff80411f18>] device_resume+0x48/0x60
>  [<ffffffff802bb355>] pm_suspend_disk+0x235/0x250
>  [<ffffffff802b99c5>] enter_state+0x65/0x250
>  [<ffffffff802b9c2a>] state_store+0x7a/0xa0
>  [<ffffffff80316734>] subsys_attr_store+0x24/0x30
>  [<ffffffff803168a0>] sysfs_write_file+0x100/0x140
>  [<ffffffff802181cf>] vfs_write+0xdf/0x180
>  [<ffffffff80218d10>] sys_write+0x50/0x90
>  [<ffffffff8026529e>] system_call+0x7e/0x83

Yes, a number of people (including myself) have been hitting these
new warnings.  I don't think we know why yet, but Eric is offline
for a bit and I'm travelling.  We'll sort it out over the next few
weeks I guess.

Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbXCFGfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbXCFGfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 01:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932672AbXCFGfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 01:35:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:22576 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222AbXCFGfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 01:35:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,253,1170662400"; 
   d="scan'208"; a="207115810:sNHT66957898"
Message-ID: <45ED0BBF.1050000@intel.com>
Date: Mon, 05 Mar 2007 22:35:43 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
References: <20070225175559.GC12392@stusta.de> <20070227100202.GV3822@kernel.dk> <20070227102109.GG6745@elf.ucw.cz> <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu> <20070302100704.GB2293@elf.ucw.cz> <20070305084257.GA4464@mellanox.co.il> <20070305101120.GA23032@elte.hu> <45ECFC5F.7000102@garzik.org>
In-Reply-To: <45ECFC5F.7000102@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Ingo Molnar wrote:
>> i'm also getting this WARN_ON() from e1000:
>>
>> BUG: at drivers/pci/msi.c:611 pci_enable_msi()
>>  [<c01061bd>] show_trace_log_lvl+0x19/0x2e
>>  [<c01062b6>] show_trace+0x12/0x14
>>  [<c01062cc>] dump_stack+0x14/0x16
>>  [<c024fcc4>] pci_enable_msi+0x6d/0x203
>>  [<c02b709e>] e1000_request_irq+0x2e/0xe2
>>  [<c02bb742>] e1000_resume+0x7f/0xef
>>  [<c0249a68>] pci_device_resume+0x1a/0x44
>>  [<c02b39ec>] resume_device+0xf7/0x16f
>>  [<c02b3adb>] dpm_resume+0x77/0xcb
>>  [<c02b3b69>] device_resume+0x3a/0x51
>>  [<c014e669>] enter_state+0x193/0x1bb
>>  [<c014e712>] state_store+0x81/0x97
>>  [<c01b68bc>] subsys_attr_store+0x20/0x25
>>  [<c01b6feb>] sysfs_write_file+0xce/0xf6
>>  [<c017e16b>] vfs_write+0xb1/0x13a
>>  [<c017e899>] sys_write+0x3d/0x61
>>  [<c0105220>] syscall_call+0x7/0xb
>>
>> seems harmless because it seems to work fine.
> 
> I would poke Eric Biederman(sp?) about this one.  Maybe its even solved 
> by the MSI-enable-related patch he posted in the past 24-48 hours.


Eric, Linus,

I tried the 3-patch series "[PATCH 0/3] Basic msi bug fixes.." and they fix this 
problem for me. Were you expecting the OOPS in the first place? In any case, it 
survived several suspend/resume cycles on both enabled (irq alloc'd and enabled) 
and disabled devices (only initialized).

Jens Axboe was seeing the same problem, perhaps he can confirm the fix as well.

In any case, the patches have my blessing :)

Please add my:

   Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>


Cheers,

Auke

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbYAKEDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbYAKEDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 23:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYAKEDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 23:03:11 -0500
Received: from pat.uio.no ([129.240.10.15]:60975 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbYAKEDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 23:03:10 -0500
Subject: Re: Serverworks Oops with the very latest git kernel...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4786D35F.6030604@garzik.org>
References: <1200017238.20100.16.camel@heimdal.trondhjem.org>
	 <4786D35F.6030604@garzik.org>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 23:03:01 -0500
Message-Id: <1200024181.20100.20.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 58BB33DA8642B664AEE735E777E0C95B5FEEAF07
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 12 total 6176825 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 21:24 -0500, Jeff Garzik wrote:
> Trond Myklebust wrote:
> > Hi,
> > 
> > I'm getting the following Oops on boot with kernel 2.6.24-rc7-g88fb61e4.
> > 
> > Starting udev: BUG: unable to handle kernel paging request at virtual address 2d6d3a65
> > printing eip: c04e1af1 *pde = 00000000 
> > Oops: 0000 [#1] PREEMPT SMP 
> > Modules linked in: evdev evbug rtc_cmos pcspkr floppy rtc_core rtc_lib shpchp pci_hotplug serverworks tg3 generic i2c_piix4 i2c_core
> > 
> > Pid: 1820, comm: modprobe Not tainted (2.6.24-rc7-g88fb61e4 #2)
> > EIP: 0060:[<c04e1af1>] EFLAGS: 00210286 CPU: 0
> > EIP is at strstr+0x11/0x34
> > EAX: 00000000 EBX: 2d6d3a65 ECX: ffffffff EDX: 2d6d3a65
> > ESI: c0513f75 EDI: 2d6d3a65 EBP: f65bccec ESP: f65bcce0
> >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > Process modprobe (pid: 1820, ti=f65bc000 task=f795a2f0 task.ti=f65bc000)
> > Stack: f8921a44 00000001 00000000 f65bcd00 c054a0b9 f892e394 f892e080 f892e5f8 
> >        f65bcd20 f892133b c04d7c9d f892da80 f891d339 f892e394 f892e080 f892e5f8 
> >        f65bcd64 f891d11f f891d339 f891bc38 f892e080 00000000 00000001 00000000 
> > Call Trace:
> >  [<c0405170>] show_trace_log_lvl+0x1a/0x2f
> >  [<c0405222>] show_stack_log_lvl+0x9d/0xa5
> >  [<c04052cd>] show_registers+0xa3/0x1df
> >  [<c040552a>] die+0x121/0x204
> >  [<c05b40dd>] do_page_fault+0x557/0x63e
> >  [<c05b278a>] error_code+0x72/0x78
> >  [<c054a0b9>] dmi_check_system+0x2f/0x58
> >  [<f892133b>] ide_acpi_init+0x28/0x195 [ide_core]
> >  [<f891d11f>] hwif_init+0x324/0x37c [ide_core]
> >  [<f891d29a>] ide_device_add+0x3b/0xa6 [ide_core]
> >  [<f891ee9a>] ide_setup_pci_device+0x36/0x40 [ide_core]
> >  [<f885f11c>] svwks_init_one+0x5b/0x62 [serverworks]
> >  [<c04eada1>] pci_device_probe+0x39/0x5b
> >  [<c05369a8>] driver_probe_device+0xe9/0x16a
> >  [<c0536b43>] __driver_attach+0x6c/0xa5
> >  [<c0535e92>] bus_for_each_dev+0x36/0x5b
> >  [<c05367f3>] driver_attach+0x19/0x1b
> >  [<c05361b1>] bus_add_driver+0x73/0x1aa
> >  [<c0536d29>] driver_register+0x67/0x6c
> >  [<c04eaef9>] __pci_register_driver+0x56/0x83
> >  [<f890f017>] svwks_ide_init+0x17/0x19 [serverworks]
> >  [<c0447f1e>] sys_init_module+0x15da/0x1715
> >  [<c04040b2>] sysenter_past_esp+0x5f/0xa5
> >  =======================
> > Code: e5 89 c1 89 c8 eb 06 80 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 5d c3 90 90 90 55 89 e5 57 56 53 89 c6 89 d3 31 c0 83 c9 ff 89 
> > EIP: [<c04e1af1>] strstr+0x11/0x34 SS:ESP 0068:f65bcce0
> > ---[ end trace f0316f13333e9ff3 ]---
> > udevd-event[1819]: run_program: '/sbin/modprobe' abnormal exit
> > 
> > 
> > Any ideas? As far as I can see, 2.6.24-rc7 itself is good, so I suspect
> > the recent merge by Bart.
> > 
> > I've set up a bugzilla entry for the regression on
> >         http://bugzilla.kernel.org/show_bug.cgi?id=9728
> 
> Does this patch fix it?
> 
> Looks like an unterminated DMI table...

Yup. That seems to have solved it. Thanks Jeff!

  Trond


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbZBGETB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbZBGETB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 23:19:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbZBGESu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 23:18:50 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:58881 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbZBGESt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 23:18:49 -0500
Date: Fri, 06 Feb 2009 23:18:36 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew McMillan <andrew@morphoss.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Early crash with 2.6.29-rc3
In-reply-to: <20090204201638.GI22608@elte.hu>
Message-id: <alpine.LFD.2.00.0902062315180.26256@localhost.localdomain>
References: <1233777795.14831.35.camel@happy.mcmillan.net.nz>
 <20090204201638.GI22608@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Ingo Molnar wrote:

> 
> (Cc:s added. Boot crash during mmconf ACPI discovery.)
> 
> * Andrew McMillan <andrew@morphoss.com> wrote:
> 
> > Hi,
> > 
> > I see the following crash fairly early in the boot with a 2.6.29-rc3
> > kernel built with essentially the same options as my working 2.6.28

Thanks for transcribing that big stack trace.
Note that you can also just send the .JPG,
or attach it to an entry in bugzilla.kernel.org and send a pointer to it.

Is there any chance you can bisect this a bit?
In particular, I'm interested to know if this started
breaking when we merged the ACPICA update into Linux-2.6.29 at
a3a798c88a14b35e5d4ca30716dbc9eb9a1ddfe2
Merge branch 'release' of 
git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6

thanks,
Len Brown, Intel Open Source Technology Center

> > kernel on my Asus F3Ke laptop:
> > 
> > Pid: 1, comm: swapper Not tainted (2.6.29-rc3-happy #1) F3Ke
> > EIP: 0060:[<c02b6486>] EFLAGS: 00010217 CPU: 1
> > EIP is at acpi_ns_delete_node+0x16/0x5e
> > EAX: 00000000 EBX: f736a018 ECX: f7012858 EDX: 00000000
> > ESI: f736a018 EDI: f7012858 EBP: f704dcf8 ESP: f704dcf4
> >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > Process swapper (pid: 1, ti=f704c000 task=f7050000 task.ti=f704c000)
> > Stack:
> >  00000000 f704dd14 c02b6524 6b000000 00000004 f70133c0 f735a800 f735a800
> >  f704dd24 c02aa9d3 f735a800 00000000 f704dd40 c02b8a49 f7363f30 00000000
> >  f735a800 00000000 f7002f80 f704dd58 c02b9c33 f7363fc0 f7002f90 f7002f80
> > Call Trace:
> >  [<c02b6524>] ? acpi_ns_delete_namespace_by_owner+0x56/0xc3
> >  [<c02aa9d3>] ? acpi_ds_terminate_control_method+0x60/0xac
> >  [<c02b8a49>] ? acpi_ps_parse_aml+0x166/0x281
> >  [<c02b9c33>] ? acpi_ps_execute_method+0x19a/0x253
> >  [<c02b6693>] ? acpi_ns_evaluate+0xcb/0x17c
> >  [<c02bc741>] ? acpi_ut_evaluate_object+0x39/0x140
> >  [<c02bae8e>] ? acpi_rs_get_method_data+0x18/0x3c
> >  [<c02ba82b>] ? acpi_walk_resources+0x39/0x91
> >  [<c0666423>] ? check_mcfg_resource+0x0/0xaf
> >  [<c0666410>] ? find_mboard_resource+0x1b/0x2e
> >  [<c02b617f>] ? acpi_ns_get_device_callback+0xfe/0x112
> >  [<c02b7806>] ? acpi_ns_walk_namespace+0x9a/0x110
> >  [<c066639b>] ? is_acpi_reserved+0x0/0x5a
> >  [<c02b6005>] ? acpi_get_devices+0x47/0x5d
> >  [<c02b6081>] ? acpi_ns_get_device_callback+0x0/0x112
> >  [<c06663f5>] ? find_mboard_resource++0x0/0x2e
> >  [<c06663ec>] ? is_acpi_reserved+0x51/0x5a
> >  [<c0665b9c>] ? is_mmconf_reserved+0x5c/0x128
> >  [<c064f842>] ? acpi_parse_mcfg+0x8e/0x12c
> >  [<c066635e>] ? __pci_mmcfg_init+0x30c/0x32e
> >  [<c01d2783>] ? proc_mkdir_mode+0x33/0x50
> >  [<c065ef04>] ? acpi_init+0x0/0x237
> >  [<c066638a>] ? pci_mmcfg_late_init+0xa/0xc
> >  [<c065f083>] ? acpi_init+0x17f/0x237
> >  [<c010111a>] ? do_one_initcall+0x2a/0x150
> >  [<c01d26b4>] ? create_proc_entry+0x54/0xa0
> >  [<c016367c>] ? register_irq_proc+0x9c/0xb0
> >  [<c01636f5>] ? init_irq_proc+0x65/0x80
> >  [<c0643355>] ? kernel_init+0x127/0x180
> >  [<c064322e>] ? kernel_init+0x0/0x180
> >  [<c0103cdb>] ? kernel_thread_helper+0x7/0x1c
> > Code: ff ff ff 89 f0 e8 ed 05 00 00 89 c6 85 ff 75 bd 5b 5e 5f c9 55 89 e5 53
> >  89 c3 e8 d7 05 00 00 31 d2 89 c1 8b 40 0c eb 05 89 c2 <8b> 40 10 39 d8 75 f7
> >  d2 74 12 f6 43 06 01 8b 43 10 89 42 10
> > EIP: [<c02b6486>] acpi_ns_delete_node+016/0x5e SS:ESP 0068:f704dcf4
> > ---[ end trace 4eaa2a86a8e2da22 ]---
> > 
> > 
> > I hope this is useful.  The above was transcribed from a photo and,
> > though I checked it, there is of course still the possibility of an
> > error somewhere.  Please CC: me (or e-mail privately) if you have any
> > further questions about configuration or such, since I am not subscribed
> > to LKML.
> > 
> > Thanks,
> > 					Andrew McMillan.
> > 
> > ------------------------------------------------------------------------
> > andrew (AT) morphoss (DOT) com                            +64(272)DEBIAN
> >             Beware of a tall blond man with one black shoe.
> > ------------------------------------------------------------------------
> > 
> 
> 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbXLLNmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbXLLNmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 08:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXLLNml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 08:42:41 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:53701 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751817AbXLLNmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 08:42:40 -0500
Date: Wed, 12 Dec 2007 19:11:58 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, kay.sievers@vrfy.org,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071212134158.GA5547@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071211164319.GA14783@linux.vnet.ibm.com> <20071211170400.GA4861@suse.de> <20071211172338.GA17896@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201EF@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211182015.GA22339@linux.vnet.ibm.com> <20071211182528.GA5597@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211210653.GA6902@elte.hu> <20071212070816.GA31455@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F6@ecqcmtlmail3.quebec.int.ec.gc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0015201F6@ecqcmtlmail3.quebec.int.ec.gc.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 07:57:33AM -0500, Fortier,Vincent [Montreal] wrote:
> > -----Message d'origine-----
> > De : Dhaval Giani [mailto:dhaval@linux.vnet.ibm.com] 
> > 
> > On Tue, Dec 11, 2007 at 10:06:53PM +0100, Ingo Molnar wrote:
> > > 
> > > * Fortier,Vincent [Montreal] <Vincent.Fortier1@EC.GC.CA> wrote:
> > > 
> > > > > That has changed from /sys/kernel/uids/<uid>/cpu_share
> > > > 
> > > > Here is my config.
> > > > 
> > > > Maybie I should give it a shot without CFS at all and see what 
> > > > happends ?
> 
> It got triggerred also using a 2.6.22.14:
> [57560.396000] BUG: unable to handle kernel paging request at virtual
> address 80000000
> [57560.396000]  printing eip:
> [57560.396000] c01d6c56
> [57560.396000] *pdpt = 0000000008d02001
> [57560.396000] *pde = 0000000000000000
> [57560.396000] Oops: 0000 [#34]
> [57560.396000] SMP
> [57560.396000] last sysfs file: /devices/platform/floppy.0/uevent
> [57560.396000] Modules linked in: xfs drbd cn nfs nfsd exportfs lockd
> nfs_acl sunrpc ppdev parport_pc lp parport button ac battery ipv6 fuse
> ide_cd ide_generic usbkbd usbmouse tsdev iTCO_wdt iTCO_vendor_support
> psmouse e752x_edac edac_mc serio_raw evdev pcspkr sg floppy shpchp
> pci_hotplug sr_mod cdrom ext3 jbd mbcache dm_mirror dm_snapshot dm_mod
> generic piix ide_core tg3 ata_piix ehci_hcd uhci_hcd usbcore thermal
> processor fan mptscsih mptbase megaraid_sas megaraid_mbox megaraid_mm
> cciss aacraid
> [57560.396000] CPU:    2
> [57560.396000] EIP:    0060:[<c01d6c56>]    Not tainted VLI
> [57560.396000] EFLAGS: 00010297   (2.6.22.14-etch-686-envcan #1)
> [57560.396000] EIP is at vsnprintf+0x2af/0x48c
> [57560.396000] eax: 80000000   ebx: ffffffff   ecx: 80000000   edx:
> fffffffe
> [57560.396000] esi: edf37017   edi: edf09eac   ebp: ffffffff   esp:
> edf09e4c
> [57560.396000] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> [57560.396000] Process clBackup (pid: 31421, ti=edf08000 task=f7d36530
> task.ti=edf08000)
> [57560.396000] Stack: c852b000 00001000 c0338c78 f895b56c c0233bf5
> c852b000 120c8fe8 edf37017
> [57560.396000]        00c3bd08 00000000 ffffffff ffffffff 00000000
> c03354eb 00000003 00000017
> [57560.396000]        c0376dc0 c852b000 c01d6eb4 edf09eac edf09eac
> c0233170 edf37017 c03354ea
> [57560.396000] Call Trace:
> [57560.396000]  [<c0233bf5>] dev_uevent+0x189/0x1e0
> [57560.396000]  [<c01d6eb4>] sprintf+0x20/0x23
> [57560.396000]  [<c0233170>] show_uevent+0xad/0xd5
> [57560.396000]  [<c0154f48>] get_page_from_freelist+0x296/0x32d
> [57560.396000]  [<c012e6f0>] group_send_sig_info+0x12/0x56
> [57560.396000]  [<c0155031>] __alloc_pages+0x52/0x294
> [57560.396000]  [<c02330c3>] show_uevent+0x0/0xd5
> [57560.396000]  [<c0232c82>] dev_attr_show+0x15/0x18
> [57560.396000]  [<c01a6979>] sysfs_read_file+0x87/0xd8
> [57560.396000]  [<c0185f04>] sys_getxattr+0x46/0x4e
> [57560.396000]  [<c01a68f2>] sysfs_read_file+0x0/0xd8
> [57560.396000]  [<c016fe03>] vfs_read+0xa6/0x128
> [57560.396000]  [<c01701ff>] sys_read+0x41/0x67
> [57560.396000]  [<c0103d8a>] syscall_call+0x7/0xb
> [57560.396000]  =======================
> [57560.396000] Code: 74 24 28 73 03 c6 06 20 4d 46 85 ed 7f f1 e9 b9 00
> 00 00 8b 0f b8 79 e0 32 c0 8b 54 24 2c 81 f9 ff 0f 00 00 0f 46 c8 89 c8
> eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 f6 44 24 30 10 89 c3
> [57560.396000] EIP: [<c01d6c56>] vsnprintf+0x2af/0x48c SS:ESP
> 0068:edf09e4c
> 
> > > 
> > > and also with CFS but without CONFIG_FAIR_GROUP_SCHED.
> > > 
> 
> Is it still required since it now does not seems to be CFS related?
> 

No, not any more. Would it be possible for you to do a git-bisect? I am not
too well versed with sysfs, so it is not apparent to me what is causing
this oops. It seems to be easily reproducible. I don't still have a
reliable method to reproduce it without the CFS patch. Could sysfs
experts please help debugging?

Thanks,
-- 
regards,
Dhaval

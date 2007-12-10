Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbXLJOEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbXLJOEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 09:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbXLJODz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 09:03:55 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:1354 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751960AbXLJODy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 09:03:54 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.22.14 oops msg with commvault galaxy ?
Date: Mon, 10 Dec 2007 09:03:17 -0500
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0015201B1@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0015201AF@ecqcmtlmail3.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.22.14 oops msg with commvault galaxy ?
Thread-Index: Acg5N/wX3ZMbwBQdSvmkaHSQ+29ndQB9wO4gAAGVWBA=
References: <20071207151113.e9841341.akpm@linux-foundation.org> <20071207171455.b2eecb60.randy.dunlap@oracle.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201AF@ecqcmtlmail3.quebec.int.ec.gc.ca>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Dec 2007 14:03:17.0489 (UTC) FILETIME=[69D45E10:01C83B35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de 
> Fortier,Vincent [Montreal]
> Envoyé : 10 décembre 2007 08:21
> À : Randy Dunlap; Andrew Morton
> Cc : linux-kernel@vger.kernel.org
> Objet : RE: 2.6.22.14 oops msg with commvault galaxy ?
> 
> > -----Message d'origine-----
> > De : Randy Dunlap [mailto:randy.dunlap@oracle.com] Envoyé : 
> 7 décembre 
> > 2007 20:15
> > 
> > On Fri, 7 Dec 2007 15:11:13 -0800 Andrew Morton wrote:
> > 
> > > On Fri, 7 Dec 2007 14:15:36 -0800
> > > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > 
> > > > > Help would really be appreciated.
> > > > 
> > > > Let's try the last_sysfs_file (name) patch.
> > > > I've attempted to update it for 2.6.22.14.
> > > > Andrew, does this change in fs/sysfs/file.c look OK?
> > > 
> > > umm, yup.
> > > 
> > > 
> > 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-r
> > > 
> > 
> c6/2.6.21-rc6-mm1/broken-out/gregkh-driver-sysfs-crash-debugging.patch
> > > 
> > > should work.
> > 
> > Thanks.  
> > I produced a cleanly applying version of it for 2.6.22.14.
> > 
> > Vincent, please apply this patch so we can know which file in sysfs 
> > these oopses are happening with.
> > 
> 
> It did not applied cleanly on a 2.6.22.14... copy/paste might 
> be the issue here... Anyhow, I corrected the patch failure to 
> apply and here is my version of it... Hoping I got this 
> (attached patch).
> 
> Compiling at the moment... will try this out with commvault 
> 5.9 probably in the morning and get back with the results.
> 
> Let me know I got the patch wrong.

Here is the resulting trace... hoping this helps...:

[  942.107304] BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
[  942.107339]  printing eip:
[  942.107354] c01a924c
[  942.107368] *pdpt = 000000002d6b4001
[  942.107383] *pde = 0000000000000000
[  942.107401] Oops: 0000 [#1]
[  942.107414] SMP
[  942.107431] last sysfs file: /kernel/uids/104/cpu_share
[  942.107449] Modules linked in: xfs drbd cn nfs nfsd exportfs lockd nfs_acl sunrpc ppdev parport_pc lp parport button ac battery ipv6 fuse ide_cd ide_generic usbkbd usbmouse tsdev sg iTCO_wdt iTCO_vendor_support e752x_edac edac_mc psmouse floppy shpchp pci_hotplug serio_raw sr_mod pcspkr evdev cdrom ext3 jbd mbcache dm_mirror dm_snapshot dm_mod generic piix ide_core ehci_hcd uhci_hcd usbcore ata_piix tg3 thermal processor fan mptscsih mptbase megaraid_sas megaraid_mbox megaraid_mm cciss aacraid
[  942.107675] CPU:    0
[  942.107676] EIP:    0060:[<c01a924c>]    Not tainted VLI
[  942.107678] EFLAGS: 00010202   (2.6.22.14-cfs-etch-686-envcan #1)
[  942.107730] EIP is at sysfs_open_file+0xae/0x21e
[  942.107749] eax: 00000000   ebx: f77783b8   ecx: dfb0b280   edx: 000000c8
[  942.107769] esi: f7e0ce8c   edi: c03fd5c0   ebp: c01a919e   esp: f1257ed8
[  942.107789] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[  942.107810] Process clBackup (pid: 5191, ti=f1256000 task=f71b3290 task.ti=f1256000)
[  942.107831] Stack: 00001000 f295d240 ed4f4ac0 f7e0ce48 f295d240 ed4f4ac0 f1257f30 c01a919e
[  942.107878]        c0170464 dfe76100 ed4f3880 f295d240 00008000 f1257f30 00000010 c0170595
[  942.107921]        f295d240 00000000 00000000 c01705d6 00000000 f1257f30 ed4f3880 dfe76100
[  942.107968] Call Trace:
[  942.107998]  [<c01a919e>] sysfs_open_file+0x0/0x21e
[  942.108017]  [<c0170464>] __dentry_open+0xc1/0x178
[  942.108039]  [<c0170595>] nameidata_to_filp+0x24/0x33
[  942.108063]  [<c01705d6>] do_filp_open+0x32/0x39
[  942.108088]  [<c0170343>] get_unused_fd+0x4a/0xaa
[  942.108112]  [<c017061f>] do_sys_open+0x42/0xc3
[  942.108134]  [<c01706d9>] sys_open+0x1c/0x1e
[  942.108155]  [<c0103d8a>] syscall_call+0x7/0xb
[  942.108179]  =======================
[  942.108194] Code: b8 c0 c5 3f c0 41 e8 e8 06 03 00 83 7c 24 0c 00 0f 84 72 01 00 00 85 f6 0f 84 6a 01 00 00 8b 56 04 85 d2 74 19 64 a1 08 50 3d c0 <83> 3a 02 0f 84 44 01 00 00 c1 e0 05 ff 84 10 20 01 00 00 8b 54
[  942.108364] EIP: [<c01a924c>] sysfs_open_file+0xae/0x21e SS:ESP 0068:f1257ed8

- vin

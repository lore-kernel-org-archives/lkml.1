Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbXLKSVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbXLKSVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 13:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbXLKSVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 13:21:31 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:43273 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbXLKSV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 13:21:29 -0500
Date: Tue, 11 Dec 2007 23:50:15 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Cc: Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       kay.sievers@vrfy.org
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071211182015.GA22339@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071207151113.e9841341.akpm@linux-foundation.org> <20071207171455.b2eecb60.randy.dunlap@oracle.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201AF@ecqcmtlmail3.quebec.int.ec.gc.ca> <F1D642E5A91BC94D9504EC83AE19E6B0015201B1@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071210091501.deed38fa.randy.dunlap@oracle.com> <20071211145437.GA15617@linux.vnet.ibm.com> <20071211164319.GA14783@linux.vnet.ibm.com> <20071211170400.GA4861@suse.de> <20071211172338.GA17896@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201EF@ecqcmtlmail3.quebec.int.ec.gc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0015201EF@ecqcmtlmail3.quebec.int.ec.gc.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 12:47:29PM -0500, Fortier,Vincent [Montreal] wrote:
> > -----Message d'origine-----
> > De : linux-kernel-owner@vger.kernel.org 
> > [mailto:linux-kernel-owner@vger.kernel.org] De la part de Dhaval Giani
> > 
> > On Tue, Dec 11, 2007 at 09:04:00AM -0800, Greg KH wrote:
> > > On Tue, Dec 11, 2007 at 10:13:19PM +0530, Dhaval Giani wrote:
> > > > On Tue, Dec 11, 2007 at 08:24:37PM +0530, Dhaval Giani wrote:
> > > > > On Mon, Dec 10, 2007 at 09:15:01AM -0800, Randy Dunlap wrote:
> > > > > > On Mon, 10 Dec 2007 09:03:17 -0500 Fortier,Vincent wrote:
> > > > > > 
> > > > > > Ingo, can you look at this, please?
> > > > > > Vincent is getting oopses on 2.6.22.14-cfs-etch.
> > > > > > 
> > > > > 
> > > > > Hi,
> > > > > 
> > > > > We are looking into this bug now. I believe that the patch at
> > > > > http://marc.info/?l=linux-kernel&m=119404922603293 should help.
> > > > > 
> > > > > I am working with Kay to get this ported.
> > > > > 
> > > > 
> > > > Hi Vincent,
> > > > 
> > > > Does the following patch help?
> > > > 
> > > > Kay/Greg, could you please review and add your Signed-off-by(s) as
> 
> > > > required?
> > > 
> > > Um, why?  What is this patch for?  Where is it to be sent, to Linus 
> > > for 2.6.24-final?  Or to the -stable tree?
> > > 
> > 
> > Hi Greg,
> > 
> > This is for 2.26.24-final, since Fair User scheduling is not 
> > yet there in stable.
> > 
> > > > This is basically a port of the patch at
> > > > http://marc.info/?l=linux-kernel&m=119404922603293
> > > 
> > > Yeah, but that patch needs some other core kobject changes, right?
> > > 
> > 
> > Yep, there are some other changes that patch needed. We have 
> > worked around them by using the existing functions in the 
> > current Linus tree.
> > 
> > > What exactly are you trying to fix here, the fact that this code
> never 
> > > even worked?
> > > 
> > 
> > The code was not using the kobject API. Its been cleaned up now (I
> > hope!)
> 
> It refused to apply cleanly on a 2.6.22.14 + CFS v24, only one failure
> occured.  So I resolved it manually and attached the resulting diff.
> 
> My tests with Galaxy 5.9 shows that it still does not work.  Although,
> the error seems to have changed a bit (see attached dmesg)
> 

Hmmm, makes me suspect the bug is somewhere else. What I am not able to
figure out is that I was able to recreate the trace you had on my
systems. So there is a bug somewhere there.

Could you send your config please?

> > > And, please, we need some documentation for Documenatation/ABI/ on 
> > > exactly what these sysfs files and tree is for.  Please add that now
> 
> > > for Linus's tree.
> > 
> > On to it, will send the patch asap.
> > 
> > > confused,
> > 
> > hope i helped (in clearing it :) )
> 
> Should this patch eventually be included in?
> 2.6.25                                                      ?
> 2.6.24                                                      ?
> (-stable 2.6.23 & 2.6.22) || backport CFS v24 -> v25        ?
> 

2.6.24 is what I believe, unless of course the bug lies elsewhere.

-- 
regards,
Dhaval

[  638.466375] BUG: unable to handle kernel paging request at virtual address 80000000
[  638.466479]  printing eip:
[  638.466527] c01d9182
[  638.466574] *pdpt = 000000002d022001
[  638.466622] *pde = 0000000000000000
[  638.466672] Oops: 0000 [#1]
[  638.466719] SMP 
[  638.466838] last sysfs file: /devices/platform/floppy.0/uevent
[  638.466890] Modules linked in: xfs drbd cn nfs nfsd exportfs lockd nfs_acl sunrpc ppdev parport_pc lp parport button ac battery ipv6 fuse ide_cd ide_generic usbkbd usbmouse tsdev iTCO_wdt iTCO_vendor_support sg psmouse e752x_edac shpchp sr_mod pci_hotplug serio_raw edac_mc evdev pcspkr cdrom floppy ext3 jbd mbcache dm_mirror dm_snapshot dm_mod generic piix ide_core ata_piix ehci_hcd uhci_hcd tg3 usbcore thermal processor fan mptscsih mptbase megaraid_sas megaraid_mbox megaraid_mm cciss aacraid
[  638.469273] CPU:    3
[  638.469274] EIP:    0060:[<c01d9182>]    Not tainted VLI
[  638.469275] EFLAGS: 00010297   (2.6.22.14-cfs-etch-686-envcan #1)
[  638.469444] EIP is at vsnprintf+0x2af/0x48c
[  638.469504] eax: 80000000   ebx: ffffffff   ecx: 80000000   edx: fffffffe
[  638.469567] esi: ebc29017   edi: ed019eac   ebp: ffffffff   esp: ed019e4c
[  638.469631] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[  638.469693] Process clBackup (pid: 4849, ti=ed018000 task=f6674c60 task.ti=ed018000)
[  638.469757] Stack: ec2a9000 00001000 c033b658 f899b56c c0236131 ec2a9000 143d6fe8 ebc29017 
[  638.470212]        00f9b608 00000000 ffffffff ffffffff 00000000 c0337ecb 00000003 00000017 
[  638.470665]        c037a3a0 ec2a9000 c01d93e0 ed019eac ed019eac c02356ac ebc29017 c0337eca 
[  638.471129] Call Trace:
[  638.471258]  [<c0236131>] dev_uevent+0x189/0x1e0
[  638.471377]  [<c01d93e0>] sprintf+0x20/0x23
[  638.471486]  [<c02356ac>] show_uevent+0xad/0xd5
[  638.471594]  [<c0157189>] get_page_from_freelist+0x273/0x30a
[  638.471713]  [<c01323b4>] group_send_sig_info+0x12/0x56
[  638.471822]  [<c0157272>] __alloc_pages+0x52/0x286
[  638.471930]  [<c02355ff>] show_uevent+0x0/0xd5
[  638.472034]  [<c02351be>] dev_attr_show+0x15/0x18
[  638.472138]  [<c01a8e91>] sysfs_read_file+0x87/0xd8
[  638.472240]  [<c018807c>] sys_getxattr+0x46/0x4e
[  638.472341]  [<c01a8e0a>] sysfs_read_file+0x0/0xd8
[  638.472445]  [<c0171f77>] vfs_read+0xa6/0x128
[  638.472551]  [<c0172373>] sys_read+0x41/0x67
[  638.472656]  [<c0103d8a>] syscall_call+0x7/0xb
[  638.472765]  =======================
[  638.472822] Code: 74 24 28 73 03 c6 06 20 4d 46 85 ed 7f f1 e9 b9 00 00 00 8b 0f b8 59 0a 33 c0 8b 54 24 2c 81 f9 ff 0f 00 00 0f 46 c8 89 c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 f6 44 24 30 10 89 c3 
[  638.475660] EIP: [<c01d9182>] vsnprintf+0x2af/0x48c SS:ESP 0068:ed019e4c



Return-Path: <linux-kernel-owner+w=401wt.eu-S935545AbXK3RNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935545AbXK3RNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935686AbXK3RNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:13:20 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:39103 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935680AbXK3RNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:13:19 -0500
Date: Fri, 30 Nov 2007 09:12:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: vincent.fortier1@ec.gc.ca
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-Id: <20071130091239.708173db.randy.dunlap@oracle.com>
In-Reply-To: <1196427774.10204.4.camel@kayak.wul.qc.ec.gc.ca>
References: <1196427774.10204.4.camel@kayak.wul.qc.ec.gc.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 13:02:54 +0000 Vincent Fortier wrote:

> Hi all,
> 
> I'm using a 2.6.22.14 + CFS v24 and I got theses errors when starting up
> my commvault galaxy client...  Do anybody know what this could mean?

Can you provide a few lines of syslog before the Oops: line,
which should contain some info about what happened, e.g.:

Unable to handle kernel paging request at virtual address e4a85017
printing eip:
c01d915a
*pde = 37d0d067
*pte = 00000000

> Message from syslogd@printemps at Fri Nov 30 12:54:57 2007 ...
> printemps kernel: [750078.538268] Oops: 0000 [#1]
> printemps kernel: [750078.538284] SMP
> printemps kernel: [750078.538528] CPU:    2
> printemps kernel: [750078.538529] EIP:    0060:[<c01d915a>]    Not
> tainted VLI
> printemps kernel: [750078.538530] EFLAGS: 00010297
> (2.6.22.14-cfs-etch-686-envcan #1)
> printemps kernel: [750078.538580] EIP is at vsnprintf+0x2af/0x48c
> printemps kernel: [750078.538597] eax: 80000000   ebx: ffffffff   ecx:
> 80000000   edx: fffffffe
> printemps kernel: [750078.538618] esi: e4a85017   edi: cf07feac   ebp:
> ffffffff   esp: cf07fe4c
> printemps kernel: [750078.538637] ds: 007b   es: 007b   fs: 00d8  gs:
> 0033  ss: 0068
> printemps kernel: [750078.538656] Process clBackup (pid: 29277,
> ti=cf07e000 task=f6d9f8c0 task.ti=cf07e000)
> printemps kernel: [750078.538676] Stack: e4834000 00001000 c033b638
> f89e056c c02360f1 e4834000 1b57afe8 e4a85017
> printemps kernel: [750078.538721]        00ef2608 00000000 ffffffff
> 00000000 ffffffff c0337eab 00000003 00000017
> printemps kernel: [750078.538767]        c037a340 e4834000 c01d93b8
> cf07feac cf07feac c023566c e4a85017 c0337eaa
> printemps kernel: [750078.538810] Call Trace:
> printemps kernel: [750078.538839]  [<c02360f1>] dev_uevent+0x189/0x1e0
> printemps kernel: [750078.538864]  [<c01d93b8>] sprintf+0x20/0x23
> printemps kernel: [750078.538885]  [<c023566c>] show_uevent+0xad/0xd5
> printemps kernel: [750078.538907]  [<c01571d1>] get_page_from_freelist
> +0x273/0x30a
> printemps kernel: [750078.538933]  [<c01323fc>] group_send_sig_info
> +0x12/0x56
> printemps kernel: [750078.538956]  [<c01572ba>] __alloc_pages+0x52/0x286
> printemps kernel: [750078.538984]  [<c02355bf>] show_uevent+0x0/0xd5
> printemps kernel: [750078.539006]  [<c023517e>] dev_attr_show+0x15/0x18
> printemps kernel: [750078.539027]  [<c01a8e9f>] sysfs_read_file
> +0x87/0xd8
> printemps kernel: [750078.539048]  [<c01880bc>] sys_getxattr+0x46/0x4e
> printemps kernel: [750078.539071]  [<c01a8e18>] sysfs_read_file+0x0/0xd8
> printemps kernel: [750078.539092]  [<c0171fb7>] vfs_read+0xa6/0x128
> printemps kernel: [750078.539115]  [<c01723b3>] sys_read+0x41/0x67
> printemps kernel: [750078.539137]  [<c0103d8a>] syscall_call+0x7/0xb
> printemps kernel: [750078.539162]  =======================
> printemps kernel: [750078.539177] Code: 74 24 28 73 03 c6 06 20 4d 46 85
> ed 7f f1 e9 b9 00 00 00 8b 0f b8 39 0a 33 c0 8b 54 24 30 81 f9 ff 0f 00
> 00 0f 46 c8 89 c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 f6
> 44 24 2c 10 89 c3
> printemps kernel: [750078.539346] EIP: [<c01d915a>] vsnprintf
> +0x2af/0x48c SS:ESP 0068:cf07fe4c
> 
> 
> thnx very much!

---
~Randy

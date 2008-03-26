Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbYCZQws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbYCZQws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757568AbYCZQwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:52:20 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36624 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203AbYCZQwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:52:13 -0400
Subject: Re: [kvm-devel] kvm causing memory corruption?  ~2.6.25-rc6
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
In-Reply-To: <47EA1C63.8010202@qumranet.com>
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>
	 <47EA1C63.8010202@qumranet.com>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 09:52:09 -0700
Message-Id: <1206550329.7883.5.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-26 at 11:50 +0200, Avi Kivity wrote:
> Dave Hansen wrote:
> > I was getting some kvm userspace crashes trying to run a Windows guest.
> > So, I decided to try a recent kernel (2.6.25-rc6-00333-ga4083c9)  with
> > the kvm kernel code that shipped with that kernel.
> >
> 
> This is fixed in 2.6.25-rc7.

I just updated to -rc7 and re-tested.  Same symptoms:

[  751.033545] BUG: unable to handle kernel paging request at 0096b848
[  751.040082] IP: [<c01a0636>] d_instantiate+0x26/0x50
[  751.048065] Oops: 0002 [#1] SMP
[  751.052057] Modules linked in: kvm_intel kvm nls_iso8859_1 vfat fat rfcomm l2cap tun ppdev acpi_cpufreq cpufreq_ondemand cpe
[  751.052057]
[  751.052057] Pid: 8743, comm: evolution Not tainted (2.6.25-rc7 #146)
[  751.052057] EIP: 0060:[<c01a0636>] EFLAGS: 00210286 CPU: 0
[  751.052057] EIP is at d_instantiate+0x26/0x50
[  751.052057] EAX: 0096b844 EBX: e65d7d48 ECX: 00000000 EDX: e65d7d60
[  751.052057] ESI: e67a7d00 EDI: e67a7cc0 EBP: e802ce48 ESP: e802ce3c
[  751.052057]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  751.052057] Process evolution (pid: 8743, ti=e802c000 task=f3c8ce00 task.ti=e802c000)
[  751.052057] Stack: e65d7d48 00000000 f4c191f8 e802ce60 c01e2fa4 e67a7cc0 f4c191f8 e65d7d48
[  751.052057]        e660c280 e802ce80 c01e30c3 00008180 e67a7cc0 00000000 c03b4a00 e660c280
[  751.052057]        00008180 e802cea0 c0197964 e802cf24 c03b4a00 e67a7cc0 e660c280 e802cf24
[  751.052057] Call Trace:
[  751.052057]  [<c01e2fa4>] ? ext3_add_nondir+0x34/0x60
[  751.052057]  [<c01e30c3>] ? ext3_create+0xf3/0x100
[  751.052057]  [<c0197964>] ? vfs_create+0x74/0x100
[  751.052057]  [<c0197c8f>] ? open_namei_create+0x4f/0xa0
[  751.052057]  [<c01981f3>] ? open_namei+0x513/0x560
[  751.052057]  [<c018db2c>] ? do_filp_open+0x2c/0x60
[  751.052057]  [<c018dd29>] ? get_unused_fd_flags+0x39/0xd0
[  751.052057]  [<c018dec4>] ? do_sys_open+0x54/0xe0
[  751.052057]  [<c018df6c>] ? sys_open+0x1c/0x20
[  751.052057]  [<c0104e2c>] ? sysenter_past_esp+0x6d/0xa5
[  751.052057]  [<c0390000>] ? quirk_vt8235_acpi+0x90/0xa0
[  751.052057]  =======================
[  751.052057] Code: 27 00 00 00 00 55 89 e5 57 89 c7 56 8d 70 40 53
89 d3 39 70 40 75 37 b8 40 15 4e c0 e8 14 d1 1f 00 85 db
[  751.052057] EIP: [<c01a0636>] d_instantiate+0x26/0x50 SS:ESP 0068:e802ce3c
[  751.052103] ---[ end trace 514c1de750400319 ]---


-- Dave


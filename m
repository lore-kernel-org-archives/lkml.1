Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbXGGPBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbXGGPBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 11:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbXGGPBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 11:01:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:56894 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXGGPBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 11:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=dqtjDTT921vcHOmElwje6pTrO4+a53og2JhYuYeTVpA6cPpc+3frdCmwi9vfYdYP4gwLFrI9Ars10fDtU/28SglLKk18HEMPjaj/H3PtG13V795/onoJa7KkTDeCRpibdHP0QkSkXQ+6TqBfqTrKWxMfT+UG3O8bEd8VOZlF18k=
Date: Sat, 7 Jul 2007 19:01:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: BUG on /proc listing
Message-ID: <20070707150130.GA7999@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi to all,

I've been playing with modules programing and got the
following

[21353.012000] BUG: unable to handle kernel paging request at virtual address
f0e56500
[21353.012000]  printing eip:
[21353.012000] c01aaf29
[21353.012000] *pde = 2852b067
[21353.012000] *pte = 00000000
[21353.012000] Oops: 0000 [#1]
[21353.012000] Modules linked in: fglrx(P) pcmcia rtc_cmos rtc_core rtc_lib
yenta_socket rsrc_nonstatic bcm43xx ieee80211softmac tifm_7xx1 tifm_core sdhci
snd_atiixp_modem snd_atiixp snd_ac97_codec ac97_bus k8temp pcspkr ati_agp
agpgart shpchp i2c_piix4 tsdev joydev
[21353.012000] CPU:    0
[21353.012000] EIP:    0060:[<c01aaf29>]    Tainted: P       VLI
[21353.012000] EFLAGS: 00010286   (2.6.21.3 #1)
[21353.012000] EIP is at proc_get_inode+0x29/0x160
[21353.012000] eax: f0e56500   ebx: d3b51a40   ecx: 00000000   edx: f0000268
[21353.012000] esi: f0000268   edi: efe81800   ebp: d3b51a40   esp: c6987da0
[21353.012000] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[21353.012000] Process ls (pid: 10054, ti=c6986000 task=ee064e90
task.ti=c6986000)
[21353.012000] Stack: 00100000 c6987db0 c170f6b8 c6987f04 f0000268 c20224e7
d3b51a97 c01aeea1 
[21353.012000]        c2022478 efe85e50 c6987f04 c2022478 efe85e50 c6987e38
c01ab219 c06e0920 
[21353.012000]        c2022478 c6987f04 c017b218 c6987e44 c1713dc0 efe85e50
efe85ec8 c6987e38 
[21353.012000] Call Trace:
[21353.012000]  [<c01aeea1>] proc_lookup+0x81/0xe0
[21353.012000]  [<c01ab219>] proc_root_lookup+0x19/0x50
[21353.012000]  [<c017b218>] do_lookup+0x148/0x190
[21353.012000]  [<c017d2d5>] __link_path_walk+0x835/0xe10
[21353.012000]  [<c017d8f3>] link_path_walk+0x43/0xc0
[21353.012000]  [<c018017f>] filldir64+0xbf/0xe0
[21353.012000]  [<c01ae272>] proc_readdir+0xc2/0x1a0
[21353.012000]  [<c017db66>] do_path_lookup+0x86/0x210
[21353.012000]  [<c017c8da>] getname+0x9a/0xf0
[21353.012000]  [<c017e57b>] __user_walk_fd+0x3b/0x60
[21353.012000]  [<c01773cf>] vfs_lstat_fd+0x1f/0x50
[21353.012000]  [<c018017f>] filldir64+0xbf/0xe0
[21353.012000]  [<c01ae272>] proc_readdir+0xc2/0x1a0
[21353.012000]  [<c017744f>] sys_lstat64+0xf/0x30
[21353.012000]  [<c01800c0>] filldir64+0x0/0xe0
[21353.012000]  [<c0180305>] vfs_readdir+0x85/0xb0
[21353.012000]  [<c01803e2>] sys_getdents64+0xb2/0xd0
[21353.012000]  [<c0103f08>] sysenter_past_esp+0x5d/0x81
[21353.012000]  =======================
[21353.012000] Code: 00 00 57 89 c7 56 89 d6 53 89 cb 83 ec 10 85 c9 74 28 ff 41
48 8b 49 4c 85 c9 0f 85 09 01 00 00 85 db 74 16 8b 43 2c 85 c0 74 0f <83> 38 02
0f 84 e3 00 00 00 ff 80 80 01 00 00 89 f2 89 f8 e8 3f 
[21353.012000] EIP: [<c01aaf29>] proc_get_inode+0x29/0x160 SS:ESP 0068:c6987da0

Actually my module has a bug - it don't remove a proc file has been
created on module init function. And right after I've my buggy module
unloaded (note the proc entry remained and owned by noone)
ls /proc caused that oops.

So the question is - is it normal behaviour of the kernel?

I've taken a look for kernel sources and found the following
in module.h

static inline int try_module_get(struct module *module)
{
	int ret = 1;
	^^^^^^^^^^^^

	if (module) {
		unsigned int cpu = get_cpu();
		if (likely(module_is_live(module)))
			local_inc(&module->ref[cpu].count);
		else
			ret = 0;
		put_cpu();
	}
	return ret;
}

and it seems ret shouldn't be set to 1 by defaults. I bet
proc_lookup

	[which has the following]
	if (de != NULL && !try_module_get(de->owner))
	
should return NULL for a such module. Am I wrong?

		Cyrill


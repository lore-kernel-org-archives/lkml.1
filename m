Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZDOPa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZDOPa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZDOPam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:30:42 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:35334 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064AbZDOPak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:30:40 -0400
X-Greylist: delayed 1950 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Apr 2009 11:30:40 EDT
Date: Wed, 15 Apr 2009 16:58:41 +0200
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: linux-kernel@vger.kernel.org
Cc: nikola.ciprich@linuxbox.cz
Subject: 2.6.29.1: BUG: sleeping function called from invalid context at
	mm/slub.c:1599
Message-ID: <20090415145841.GA5106@nik-comp.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Antivirus: on proxybox by Kaspersky antivirus, engine 5.5.10, data 1851352 records(15-04-2009)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I've recently installed 2.6.29.1 on one of my machines, and I'm observing following errors:

[ 5593.311942] BUG: sleeping function called from invalid context at mm/slub.c:1599
[ 5593.311948] in_atomic(): 1, irqs_disabled(): 0, pid: 5430, name: nfsd
[ 5593.311950] 4 locks held by nfsd/5430:
[ 5593.311952]  #0:  (hash_sem){....}, at: [<ffffffffa03cb360>] exp_readlock+0x10/0x20 [nfsd]
[ 5593.311971]  #1:  (&type->i_mutex_dir_key#6/1){....}, at: [<ffffffffa03c97e9>] nfsd_create_v3+0x309/0x490 [nfsd]
[ 5593.311987]  #2:  (&(&ip->i_lock)->mr_lock/1){....}, at: [<ffffffffa0492352>] xfs_ilock+0x82/0xa0 [xfs]
[ 5593.312022]  #3:  (&pag->pag_ici_lock){....}, at: [<ffffffffa04928e3>] xfs_iget+0x113/0x5f0 [xfs]
[ 5593.312046] Pid: 5430, comm: nfsd Not tainted 2.6.29lb.00_01_PRE13 #1
[ 5593.312048] Call Trace:
[ 5593.312056]  [<ffffffff80268a15>] ? __debug_show_held_locks+0x15/0x30
[ 5593.312061]  [<ffffffff80237611>] __might_sleep+0x101/0x130
[ 5593.312065]  [<ffffffff802c5ce1>] kmem_cache_alloc+0x91/0xd0
[ 5593.312071]  [<ffffffff803501b0>] selinux_inode_alloc_security+0x40/0xa0
[ 5593.312075]  [<ffffffff80347e7c>] security_inode_alloc+0x1c/0x20
[ 5593.312079]  [<ffffffff802e2cab>] inode_init_always+0xcb/0x250
[ 5593.312099]  [<ffffffffa0492997>] xfs_iget+0x1c7/0x5f0 [xfs]
[ 5593.312119]  [<ffffffffa04ab725>] xfs_trans_iget+0xd5/0x100 [xfs]
[ 5593.312138]  [<ffffffffa0497006>] xfs_ialloc+0xb6/0x680 [xfs]
[ 5593.312157]  [<ffffffffa04ac1ff>] xfs_dir_ialloc+0x7f/0x2e0 [xfs]
[ 5593.312163]  [<ffffffff804dc29b>] ? __down_write+0xb/0x10
[ 5593.312166]  [<ffffffff8025e240>] ? down_write_nested+0x50/0x60
[ 5593.312185]  [<ffffffffa04ae572>] xfs_create+0x2a2/0x470 [xfs]
[ 5593.312205]  [<ffffffffa04b9e5b>] xfs_vn_mknod+0x14b/0x250 [xfs]
[ 5593.312224]  [<ffffffffa04b9f7b>] xfs_vn_create+0xb/0x10 [xfs]
[ 5593.312228]  [<ffffffff802d761b>] vfs_create+0xeb/0x1a0
[ 5593.312239]  [<ffffffffa03c96b9>] nfsd_create_v3+0x1d9/0x490 [nfsd]
[ 5593.312252]  [<ffffffffa03d0888>] nfsd3_proc_create+0x118/0x1a0 [nfsd]
[ 5593.312264]  [<ffffffffa03c2265>] nfsd_dispatch+0xb5/0x230 [nfsd]
[ 5593.312285]  [<ffffffffa0308afe>] svc_process+0x45e/0x760 [sunrpc]
[ 5593.312296]  [<ffffffffa03c29cb>] nfsd+0x18b/0x2c0 [nfsd]
[ 5593.312307]  [<ffffffffa03c2840>] ? nfsd+0x0/0x2c0 [nfsd]
[ 5593.312311]  [<ffffffff80259fcd>] kthread+0x4d/0x80
[ 5593.312315]  [<ffffffff8020caba>] child_rip+0xa/0x20
[ 5593.312318]  [<ffffffff80259f80>] ? kthread+0x0/0x80
[ 5593.312321]  [<ffffffff8020cab0>] ? child_rip+0x0/0x20

[ 9054.612648] BUG: sleeping function called from invalid context at mm/slub.c:1599
[ 9054.612652] in_atomic(): 1, irqs_disabled(): 0, pid: 9411, name: smbd
[ 9054.612655] 3 locks held by smbd/9411:
[ 9054.612656]  #0:  (&type->i_mutex_dir_key#6){....}, at: [<ffffffff802da4c8>] do_filp_open+0x288/0x8c0
[ 9054.612668]  #1:  (&(&ip->i_lock)->mr_lock/1){....}, at: [<ffffffffa0492352>] xfs_ilock+0x82/0xa0 [xfs]
[ 9054.612697]  #2:  (&pag->pag_ici_lock){....}, at: [<ffffffffa04928e3>] xfs_iget+0x113/0x5f0 [xfs]
[ 9054.612721] Pid: 9411, comm: smbd Not tainted 2.6.29lb.00_01_PRE13 #1
[ 9054.612723] Call Trace:
[ 9054.612730]  [<ffffffff80268a15>] ? __debug_show_held_locks+0x15/0x30
[ 9054.612734]  [<ffffffff80237611>] __might_sleep+0x101/0x130
[ 9054.612738]  [<ffffffff802c5ce1>] kmem_cache_alloc+0x91/0xd0
[ 9054.612743]  [<ffffffff803501b0>] selinux_inode_alloc_security+0x40/0xa0
[ 9054.612748]  [<ffffffff80347e7c>] security_inode_alloc+0x1c/0x20
[ 9054.612752]  [<ffffffff802e2cab>] inode_init_always+0xcb/0x250
[ 9054.612771]  [<ffffffffa0492997>] xfs_iget+0x1c7/0x5f0 [xfs]
[ 9054.612791]  [<ffffffffa04ab725>] xfs_trans_iget+0xd5/0x100 [xfs]
[ 9054.612811]  [<ffffffffa0497006>] xfs_ialloc+0xb6/0x680 [xfs]
[ 9054.612830]  [<ffffffffa04ac1ff>] xfs_dir_ialloc+0x7f/0x2e0 [xfs]
[ 9054.612835]  [<ffffffff804dc29b>] ? __down_write+0xb/0x10
[ 9054.612839]  [<ffffffff8025e240>] ? down_write_nested+0x50/0x60
[ 9054.612858]  [<ffffffffa04ae572>] xfs_create+0x2a2/0x470 [xfs]
[ 9054.612884]  [<ffffffffa04b9e5b>] xfs_vn_mknod+0x14b/0x250 [xfs]
[ 9054.612902]  [<ffffffffa04b9f7b>] xfs_vn_create+0xb/0x10 [xfs]
[ 9054.612906]  [<ffffffff802d761b>] vfs_create+0xeb/0x1a0
[ 9054.612910]  [<ffffffff802daa31>] do_filp_open+0x7f1/0x8c0
[ 9054.612914]  [<ffffffff802e471a>] ? alloc_fd+0x10a/0x140
[ 9054.612918]  [<ffffffff802cb72e>] do_sys_open+0x5e/0xf0
[ 9054.612921]  [<ffffffff802cb7eb>] sys_open+0x1b/0x20
[ 9054.612925]  [<ffffffff8020b9db>] system_call_fastpath+0x16/0x1b

With command being either nfsd, or smbd. It doesn't seem to cause any harm.
According to git, this problem certainly hasn't been fixed yet.
Could somebody please have a look on this?
The system is dual-core core2 with 2GB RAM, running x86_64 centos 5.3
If more information or testing is needed, I'll gladly provide it.
with best regards
nik

-- 
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

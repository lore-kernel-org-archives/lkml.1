Return-Path: <linux-kernel-owner+w=401wt.eu-S965632AbXA3Rcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965632AbXA3Rcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 12:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965641AbXA3Rcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 12:32:35 -0500
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:45166 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965632AbXA3Rce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 12:32:34 -0500
Date: Tue, 30 Jan 2007 19:32:27 +0200
From: Sami Farin <safari-xfs@safari.iki.fi>
To: XFS Mailing List <xfs@oss.sgi.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: XFS internal error xfs_da_do_buf
Message-ID: <20070130173227.GA6017@m.safari.iki.fi>
Mail-Followup-To: XFS Mailing List <xfs@oss.sgi.com>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I setup namespace for /tmp and /var/tmp 
( pam_namespace.so into /etc/pam.d/{su,login} )
and something did not like something I did:

[322593.844838] 0x0: 00 00 00 00 2b 00 00 11 20 21 00 00 00 68 ff ff 
[322593.844854] Filesystem "sda8": XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller 0xc0230808
[322593.844997]  [<c0103cff>] dump_trace+0x215/0x21a
[322593.845024]  [<c0103da7>] show_trace_log_lvl+0x1a/0x30
[322593.845044]  [<c0103dcf>] show_trace+0x12/0x14
[322593.845062]  [<c0103ecc>] dump_stack+0x19/0x1b
[322593.845080]  [<c023a3a3>] xfs_error_report+0x55/0x5b
[322593.845430]  [<c023a4c6>] xfs_corruption_error+0x3f/0x59
[322593.845780]  [<c02306f9>] xfs_da_do_buf+0x716/0x7c1
[322593.846124]  [<c0230808>] xfs_da_read_buf+0x2f/0x35
[322593.846464]  [<c02162bc>] xfs_attr_leaf_get+0x3c/0xa3
[322593.846798]  [<c0214d08>] xfs_attr_fetch+0xb0/0xfe
[322593.847127]  [<c020e56a>] xfs_acl_iaccess+0x59/0xc2
[322593.847451]  [<c02457af>] xfs_iaccess+0x14b/0x189
[322593.847806]  [<c025fb3b>] xfs_access+0x34/0x53
[322593.848182]  [<c026ceea>] xfs_vn_permission+0x12/0x17
[322593.848564]  [<c0175438>] permission+0xe4/0xe6
[322593.848755]  [<c0175449>] vfs_permission+0xf/0x11
[322593.848942]  [<c016d0cf>] sys_faccessat+0xa6/0x144
[322593.849120]  [<c016d18d>] sys_access+0x20/0x22
[322593.849292]  [<c0102e77>] syscall_call+0x7/0xb
[322593.849310]  [<00f4f410>] 0xf4f410
[322593.849334]  =======================
[322593.849358] 0x0: 00 00 00 00 2b 00 00 11 20 21 00 00 00 68 ff ff 
[322593.849364] Filesystem "sda8": XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller 0xc0230808
[322593.849484]  [<c0103cff>] dump_trace+0x215/0x21a
[322593.849512]  [<c0103da7>] show_trace_log_lvl+0x1a/0x30
[322593.849530]  [<c0103dcf>] show_trace+0x12/0x14
[322593.849548]  [<c0103ecc>] dump_stack+0x19/0x1b
[322593.849573]  [<c023a3a3>] xfs_error_report+0x55/0x5b
[322593.849913]  [<c023a4c6>] xfs_corruption_error+0x3f/0x59
[322593.850258]  [<c02306f9>] xfs_da_do_buf+0x716/0x7c1
[322593.850598]  [<c0230808>] xfs_da_read_buf+0x2f/0x35
[322593.850936]  [<c02162bc>] xfs_attr_leaf_get+0x3c/0xa3
[322593.851266]  [<c0214d08>] xfs_attr_fetch+0xb0/0xfe
[322593.851593]  [<c020e56a>] xfs_acl_iaccess+0x59/0xc2
[322593.851917]  [<c02457af>] xfs_iaccess+0x14b/0x189
[322593.852268]  [<c025fb3b>] xfs_access+0x34/0x53
[322593.852638]  [<c026ceea>] xfs_vn_permission+0x12/0x17
[322593.853018]  [<c0175438>] permission+0xe4/0xe6
[322593.853204]  [<c0175449>] vfs_permission+0xf/0x11
[322593.853387]  [<c016d0cf>] sys_faccessat+0xa6/0x144
[322593.853562]  [<c016d18d>] sys_access+0x20/0x22
[322593.853734]  [<c0102e77>] syscall_call+0x7/0xb
[322593.853753]  [<00f4f410>] 0xf4f410
[322593.853759]  =======================

sda8 is /usr , I haven't played with mount --bind or namespaces
at /usr (AFAIK).

My sda hard disk is not broken and I have SMP kernel 2.6.19.2 + Pentium D.
I have got no other BUGs or xfs errors and I can access /usr and other
partitions OK.

-- 
Do what you love because life is too short for anything else.


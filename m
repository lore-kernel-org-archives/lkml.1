Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbYFTF1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbYFTF1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 01:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYFTF1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 01:27:25 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:42678 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751003AbYFTF1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 01:27:24 -0400
Date: Fri, 20 Jun 2008 07:27:17 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: Miquel van Smoorenburg <mikevs@xs4all.net>,
       Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       xfs-masters@oss.sgi.com
Subject: Re: XFS internal error xfs_trans_cancel at line 1163 of file
	fs/xfs/xfs_trans.c
Message-ID: <20080620052716.GA2022@anita>
Mail-Followup-To: Miquel van Smoorenburg <mikevs@xs4all.net>,
	Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	xfs-masters@oss.sgi.com
References: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de> <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com> <1213309629.29745.8.camel@localhost.localdomain> <20080613030841.GC3700@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613030841.GC3700@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2008-06-13 13:08 +1000 schrieb Dave Chinner:

> This commit in 2.6.26 will probably fix it.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=75de2a91c98a6f486f261c1367fe59f5583e15a3

If I am correct, this fix is included in 2.6.26-rc6:

Filesystem "sda6": XFS internal error xfs_trans_cancel at line 1163 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff802ffa42
Pid: 7393, comm: emerge Not tainted 2.6.26-rc6 #1

Call Trace:
 [<ffffffff802ffa42>]
 [<ffffffff802fa35a>]
 [<ffffffff802ffa42>]
 [<ffffffff80308a29>]
 [<ffffffff80262799>]
 [<ffffffff8026500a>]
 [<ffffffff8025a0fa>]
 [<ffffffff8020afab>]

xfs_force_shutdown(sda6,0x8) called from line 1164 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff802fa373
Filesystem "sda6": Corruption of in-memory data detected.  Shutting down filesystem: sda6
Please umount the filesystem, and rectify the problem(s)
Filesystem "sda6": xfs_log_force: error 5 returned.
Filesystem "sda6": xfs_log_force: error 5 returned.
zsh: Input/output error: /var/mail/root


root@zappa:~/ > ksymoops -m /usr/src/linux-2.6.26-rc6/System.map xfs-2.6.26.txt
ksymoops 2.4.11 on x86_64 2.6.26-rc6.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.26-rc6/ (default)
     -m /usr/src/linux-2.6.26-rc6/System.map (specified)

Error (regular_file): read_ksyms stat /proc/ksyms failed
ksymoops: No such file or directory
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Pid: 7393, comm: emerge Not tainted 2.6.26-rc6 #1
Call Trace:
 [<ffffffff802ffa42>]
 [<ffffffff802fa35a>]
 [<ffffffff802ffa42>]
 [<ffffffff80308a29>]
 [<ffffffff80262799>]
 [<ffffffff8026500a>]
 [<ffffffff8025a0fa>]
 [<ffffffff8020afab>]
Warning (Oops_read): Code line not seen, dumping what data is available


Trace; ffffffff802ffa42 <xfs_create+41d/462>
Trace; ffffffff802fa35a <xfs_trans_cancel+56/ee>
Trace; ffffffff802ffa42 <xfs_create+41d/462>
Trace; ffffffff80308a29 <xfs_vn_mknod+148/229>
Trace; ffffffff80262799 <vfs_create+75/ba>
Trace; ffffffff8026500a <do_filp_open+1dc/7c5>
Trace; ffffffff8025a0fa <do_sys_open+4a/f1>
Trace; ffffffff8020afab <system_call_after_swapgs+7b/80>


1 warning and 1 error issued.  Results may not be reliable.
zsh: Input/output error: /var/mail/root


-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF

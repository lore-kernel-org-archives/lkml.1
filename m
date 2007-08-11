Return-Path: <linux-kernel-owner+w=401wt.eu-S1765371AbXHKCk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765371AbXHKCk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 22:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759913AbXHKCkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 22:40:20 -0400
Received: from main.gmane.org ([80.91.229.2]:43008 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759837AbXHKCkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 22:40:19 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Russ Dill <Russ.Dill@gmail.com>
Subject: Process stuck in =?utf-8?b?bWRfd2FrZXVwX3RocmVhZA==?=
Date: Sat, 11 Aug 2007 02:34:34 +0000 (UTC)
Message-ID: <loom.20070811T042748-157@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 70.190.164.204 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.5) Gecko/20070712 (Debian-1.8.1.5-1) Galeon/2.0.2 (Debian package 2.0.2-4))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.22 from debian (stock), I have a process (dpkg) stuck with the following
calltrace:

SysRq : Show Blocked State

                         free                        sibling
  task             PC    stack   pid father child younger older
dpkg          D 00000003     0 26040  20765 (NOTLB)
       e57d5e30 00200082 00000000 00000003 dfc48ba8 00000000 dfc48ba8 00000000 
       00000007 e0af45c0 e8ce17aa 0002827f 00051ec2 e0af46cc c1809980 00000000 
       e8ce1324 0002827f 00200082 f881cd4c 00200286 f8ba2c85 c1809980 e57d5e60 
Call Trace:
 [<f881cd4c>] md_wakeup_thread+0x26/0x28 [md_mod]
 [<f8ba2c85>] raid5_unplug_device+0x4e/0x5a [raid456]
 [<c02a786e>] io_schedule+0x1d/0x27
 [<c014f3c5>] sync_page+0x0/0x3b
 [<c014f3fd>] sync_page+0x38/0x3b
 [<c02a7a6f>] __wait_on_bit_lock+0x2a/0x52
 [<c014f3b7>] __lock_page+0x58/0x5e
 [<c01333aa>] wake_bit_function+0x0/0x3c
 [<c0155daa>] truncate_inode_pages_range+0x201/0x256
 [<c0155e16>] truncate_inode_pages+0x17/0x1a
 [<f8c867eb>] reiserfs_delete_inode+0x36/0xdd [reiserfs]
 [<f8c867b5>] reiserfs_delete_inode+0x0/0xdd [reiserfs]
 [<c017acc5>] generic_delete_inode+0xa0/0x105
 [<c017a4ad>] iput+0x60/0x62
 [<c0172f41>] do_unlinkat+0xb6/0x126
 [<c0103d7e>] syscall_call+0x7/0xb
 =======================

My system is still up and running.



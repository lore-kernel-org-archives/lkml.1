Return-Path: <linux-kernel-owner+w=401wt.eu-S1751586AbZHANEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbZHANEj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 09:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZHANEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 09:04:38 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:56806 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZHANEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 09:04:38 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: linux-kernel@vger.kernel.org
Subject: Oops from tar, 2.6.31-rc5, 32 bit on quad core phenom.
Date: Sat, 01 Aug 2009 09:04:37 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5; KDE/4.2.4; i686; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200908010904.37722.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

2.6.31-rc5 rebooted to before amanda ran last night.  The amanda run looks ok, 
but I had also plugged in an empty 8GB usb key so I did a quick dmesg to see 
where it was, and found this at the end of the dmesg report:

[ 7423.221754] BUG: Bad page state in process tar  pfn:a1293
[ 7423.221760] page:c28fc260 flags:80004000 count:0 mapcount:0 mapping:(null) 
index:0
[ 7423.221764] Pid: 19211, comm: tar Not tainted 2.6.31-rc5 #1
[ 7423.221766] Call Trace:
[ 7423.221774]  [<c130b0e3>] ? printk+0x23/0x40
[ 7423.221780]  [<c1083d6f>] bad_page+0xcf/0x150
[ 7423.221784]  [<c1084e0d>] get_page_from_freelist+0x37d/0x480
[ 7423.221788]  [<c107ed54>] ? add_to_page_cache_lru+0x84/0x90
[ 7423.221791]  [<c10850ef>] __alloc_pages_nodemask+0xdf/0x520
[ 7423.221795]  [<c1087954>] __do_page_cache_readahead+0x104/0x220
[ 7423.221798]  [<c1087aa4>] ra_submit+0x34/0x50
[ 7423.221801]  [<c1087d00>] ondemand_readahead+0x120/0x240
[ 7423.221804]  [<c1087ebc>] page_cache_async_readahead+0x9c/0xb0
[ 7423.221807]  [<c10806ac>] generic_file_aio_read+0x33c/0x6a0
[ 7423.221830]  [<c10b09c9>] do_sync_read+0xe9/0x140
[ 7423.221835]  [<c104e400>] ? autoremove_wake_function+0x0/0x60
[ 7423.221839]  [<c115211e>] ? security_file_permission+0x1e/0x40
[ 7423.221842]  [<c10b0a80>] ? rw_verify_area+0x60/0xe0
[ 7423.221845]  [<c10b1827>] vfs_read+0xb7/0x180
[ 7423.221848]  [<c10b08e0>] ? do_sync_read+0x0/0x140
[ 7423.221850]  [<c10b19f8>] sys_read+0x58/0xa0
[ 7423.221854]  [<c10031b7>] sysenter_do_call+0x12/0x22
[ 7423.221856] Disabling lock debugging due to kernel taint

The machine seems 100% so far.  This kernel was built without that patch that 
would make an oom more verbose.  htop looks ok, as does slabtop.

Where should I take this?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

I haven't lost my mind -- it's backed up on tape somewhere.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760298AbYBOV4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298AbYBOV4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759640AbYBOV4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:56:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41743 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759547AbYBOV42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:56:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=Do1XxQ3MvfxsDy8PaGICDH/5bg0ptNAz8u4vdzEo90AQcQSYJPRydkCNdJR8V0WzaAYjSkkLgm9BQayfJKhQkZXl6bQdrpAWP6mESq7OmUGuXLLBSiMPtswyRnlTYhuw+TRDeGwt7D8QAQUh5JLgSP2qzydVx04fo0Nr1wvwy1s=
Message-ID: <47B60A87.8000605@gmail.com>
Date: Fri, 15 Feb 2008 23:56:23 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: LatencyTOP: sync_page description
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

LatencyTOP says that sync_page is 'Writing a page to disk', however
I see that even when no writes are involved, such as during a
readdir, lseek, etc.
Naming it a write is misleading, as no program is running that is
doing constant writes to the disk. The only program is writing to a
temp dir in /dev/shm.

What would be a better description for sync_page?

Here are some /proc/latency_stats containing sync_page:

125 6937678 210821 sync_page sync_page_killable sync_page_killable
__lock_page_killable wake_bit_function generic_file_aio_read
get_unused_fd_flags path_walk do_sync_read autoremove_wake_function
security_file_permission rw_verify_area
306 5677749 215746 sync_page sync_page_killable sync_page_killable
__lock_page_killable wake_bit_function generic_file_aio_read
do_sync_read autoremove_wake_function security_file_permission
rw_verify_area vfs_read vfs_llseek
21 435657 59966 sync_page sync_page __lock_page wake_bit_function
read_cache_page_async ntfs_readpage read_cache_page map_mft_record
ntfs_read_locked_inode ntfs_alloc_big_inode iget5_locked
ntfs_test_inode
195 2716409 133660 blk_unplug sync_page sync_page __lock_page
wake_bit_function read_cache_page_async ntfs_readpage
read_cache_page map_mft_record ntfs_read_locked_inode
ntfs_alloc_big_inode iget5_locked
28 1881278 181986 add_to_page_cache_lru sync_page sync_page_killable
sync_page_killable __lock_page_killable wake_bit_function
generic_file_aio_read get_unused_fd_flags path_walk do_sync_read
autoremove_wake_function security_file_permission
2 17132 9746 add_to_page_cache_lru sync_page sync_page_killable
sync_page_killable __lock_page_killable wake_bit_function
generic_file_aio_read do_sync_read autoremove_wake_function
security_file_permission rw_verify_area vfs_read
1 70 70 irq_exit sync_page sync_page_killable sync_page_killable
__lock_page_killable wake_bit_function generic_file_aio_read
do_sync_read autoremove_wake_function security_file_permission
rw_verify_area vfs_read
23 306682 114514 blk_unplug sync_page sync_page_killable
sync_page_killable __lock_page_killable wake_bit_function
generic_file_aio_read do_sync_read autoremove_wake_function
security_file_permission rw_verify_area vfs_read
1 153 153 hrtimer_interrupt smp_apic_timer_interrupt sync_page
sync_page_killable sync_page_killable __lock_page_killable
wake_bit_function generic_file_aio_read do_sync_read
autoremove_wake_function cfq_idle_slice_timer security_file_permission

Thanks,
--Edwin

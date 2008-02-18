Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbYBRDrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbYBRDrO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 22:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbYBRDq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 22:46:57 -0500
Received: from n27.bullet.mail.mud.yahoo.com ([68.142.200.142]:47846 "HELO
	n27.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755550AbYBRDq4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 22:46:56 -0500
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2008 22:46:56 EST
X-Yahoo-Newman-Id: 105563.93560.bm@omp401.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xJE6wqJ1hDAkG67vNM+hBTcc2I+tocabxxTiN4LA13tuvP6c8yWYZax0lhE2xqQNqgGI7iIkDqrDWLhs73XY+IULocnBJk9gKUGC5PMdEM7eMsepcIRy3jq5M17Glt7KZkO9nNh0h/42J+ugswQbmBYuci9uVZsZXLiBBl1pHWk=  ;
X-YMail-OSG: v3hlw0sVM1kxTOU2v.G1ryA_5GDyKB8loR3qxsWpOLIDzo.PoM9Cu6QpBPb6aPF2R1WKul2NmA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: =?iso-8859-1?q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
Subject: Re: LatencyTOP: sync_page description
Date: Mon, 18 Feb 2008 14:40:38 +1100
User-Agent: KMail/1.9.5
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <47B60A87.8000605@gmail.com>
In-Reply-To: <47B60A87.8000605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802181440.39159.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2008 08:56, Török Edwin wrote:
> Hi Arjan,
>
> LatencyTOP says that sync_page is 'Writing a page to disk', however
> I see that even when no writes are involved, such as during a
> readdir, lseek, etc.
> Naming it a write is misleading, as no program is running that is
> doing constant writes to the disk. The only program is writing to a
> temp dir in /dev/shm.
>
> What would be a better description for sync_page?

Waiting on a page state change (usually: waiting for IO, but can be
also waiting for the page lock which is taken by some other part of
the kernel eg in page reclaim, truncate, buffered writes, page
faults).

> Here are some /proc/latency_stats containing sync_page:
>
> 125 6937678 210821 sync_page sync_page_killable sync_page_killable
> __lock_page_killable wake_bit_function generic_file_aio_read
> get_unused_fd_flags path_walk do_sync_read autoremove_wake_function
> security_file_permission rw_verify_area
> 306 5677749 215746 sync_page sync_page_killable sync_page_killable
> __lock_page_killable wake_bit_function generic_file_aio_read
> do_sync_read autoremove_wake_function security_file_permission
> rw_verify_area vfs_read vfs_llseek
> 21 435657 59966 sync_page sync_page __lock_page wake_bit_function
> read_cache_page_async ntfs_readpage read_cache_page map_mft_record
> ntfs_read_locked_inode ntfs_alloc_big_inode iget5_locked
> ntfs_test_inode
> 195 2716409 133660 blk_unplug sync_page sync_page __lock_page
> wake_bit_function read_cache_page_async ntfs_readpage
> read_cache_page map_mft_record ntfs_read_locked_inode
> ntfs_alloc_big_inode iget5_locked
> 28 1881278 181986 add_to_page_cache_lru sync_page sync_page_killable
> sync_page_killable __lock_page_killable wake_bit_function
> generic_file_aio_read get_unused_fd_flags path_walk do_sync_read
> autoremove_wake_function security_file_permission
> 2 17132 9746 add_to_page_cache_lru sync_page sync_page_killable
> sync_page_killable __lock_page_killable wake_bit_function
> generic_file_aio_read do_sync_read autoremove_wake_function
> security_file_permission rw_verify_area vfs_read
> 1 70 70 irq_exit sync_page sync_page_killable sync_page_killable
> __lock_page_killable wake_bit_function generic_file_aio_read
> do_sync_read autoremove_wake_function security_file_permission
> rw_verify_area vfs_read
> 23 306682 114514 blk_unplug sync_page sync_page_killable
> sync_page_killable __lock_page_killable wake_bit_function
> generic_file_aio_read do_sync_read autoremove_wake_function
> security_file_permission rw_verify_area vfs_read
> 1 153 153 hrtimer_interrupt smp_apic_timer_interrupt sync_page
> sync_page_killable sync_page_killable __lock_page_killable
> wake_bit_function generic_file_aio_read do_sync_read
> autoremove_wake_function cfq_idle_slice_timer security_file_permission


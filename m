Return-Path: <linux-kernel-owner+w=401wt.eu-S933701AbXHFPJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701AbXHFPJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764359AbXHFPJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:09:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:59214 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764333AbXHFPJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:09:41 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1/YbDEUuarYYE31W1C8p9W6WFbhSFqL0nhQc3W1vL
	G0UVRDazysUwFI
Message-ID: <46B747C7.9040409@gmx.net>
Date: Mon, 06 Aug 2007 18:09:43 +0200
From: Dimitrios Apostolou <jimis@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070301 SeaMonkey/1.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
References: <200708031903.10063.jimis@gmx.net>	<200708051903.12414.jimis@gmx.net> <20070805182811.a8992126.akpm@linux-foundation.org>
In-Reply-To: <20070805182811.a8992126.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------030208090408010003070506"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030208090408010003070506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Sun, 5 Aug 2007 19:03:12 +0300 Dimitrios Apostolou <jimis@gmx.net> wrote:
> 
>> was my report so complicated?
> 
> We're bad.
> 
> Seems that your context switch rate when running two instances of
> badblocks against two different disks went batshit insane.  It doesn't
> happen here.

Hello again,

I run some more tests and figured out that the problem occurs only when 
the I/O is writing to disk. Indeed, when I run two badblocks without the 
-w switch, read-only that is, the oprofile output seems normal 
(two_discs_read.txt). So does the vmstat output:


procs -----------memory---------- ---swap-- -----io---- -system-- 
----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy 
id wa
  4  2      0  24136  87124  95660    0    0 28288     0  449  724 92  8 
  0  0
  4  2      0  24076  87136  95648    0    0 28160    12  446  749 91  9 
  0  0
  4  2      0  24016  87144  95664    0    0 28096    88  444  790 89 11 
  0  0
  4  2      0  24016  87144  95664    0    0 28288     0  444  705 88 12 
  0  0
  4  2      0  24016  87144  95660    0    0 28288     0  448  737 95  5 
  0  0

As you can see the context switching rate is greater now but the system 
CPU load much less, than that of two_discs_bad.txt.

However the cron jobs still seem to have a hard time finishing, even 
though they seem now to consume about 90% CPU time. Could someone please 
explain me some things that seem vital to understanding the situation?

Firstly, what is that "processor" line in the oprofile output without 
symbols? And why does *it* take all the CPU and not other important 
processes? Finally what do the kernel symbols "__switch_to" and 
"schedule" represent?


Thanks in advance,
Dimitris

--------------030208090408010003070506
Content-Type: text/plain;
 name="two_discs_read.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="two_discs_read.txt"

Mon Aug  6 17:32:15 EEST 2007
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Daemon started.
Profiler running.
Stopping profiling.
Killing daemon.



CPU: PIII, speed 798.031 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
     1893 43.9415 processor
     1409 32.7066 vmlinux
      346  8.0316 libc-2.6.so
      217  5.0371 bash
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	      216 99.5392 bash
	        1  0.4608 anon (tgid:29407 range:0xb7f90000-0xb7f91000)
      141  3.2730 ld-2.6.so
      105  2.4373 ide_core
       43  0.9981 ext3
       42  0.9749 ISO8859-1.so
       24  0.5571 jbd
       23  0.5339 oprofiled
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	       22 95.6522 oprofiled
	        1  4.3478 anon (tgid:29402 range:0xb7f1d000-0xb7f1e000)
       18  0.4178 oprofile
        9  0.2089 reiserfs
        6  0.1393 libcrypto.so.0.9.8
        5  0.1161 grep
        4  0.0929 locale-archive
        3  0.0696 gawk
        3  0.0696 badblocks
        3  0.0696 screen-4.0.3
        3  0.0696 imap-login
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        1 33.3333 imap-login
	        1 33.3333 anon (tgid:28108 range:0xb7eea000-0xb7eeb000)
	        1 33.3333 anon (tgid:3944 range:0xb7fc8000-0xb7fc9000)
        2  0.0464 libpthread-2.6.so
        1  0.0232 less
        1  0.0232 ls
        1  0.0232 rm
        1  0.0232 sleep
        1  0.0232 libext2fs.so.2.4
        1  0.0232 libncurses.so.5.6
        1  0.0232 init
        1  0.0232 sshd
        1  0.0232 syslog-ng



CPU: PIII, speed 798.031 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
162      11.4975  do_wp_page
147      10.4329  native_safe_halt
49        3.4776  __blockdev_direct_IO
45        3.1938  __handle_mm_fault
34        2.4131  put_page
33        2.3421  get_page_from_freelist
27        1.9163  page_fault
24        1.7033  unmap_vmas
22        1.5614  __bio_add_page
20        1.4194  acpi_pm_read
20        1.4194  follow_page
19        1.3485  copy_process
19        1.3485  find_get_page
18        1.2775  __link_path_walk
17        1.2065  irq_entries_start
16        1.1356  delay_tsc
15        1.0646  __d_lookup
15        1.0646  mask_and_ack_8259A
14        0.9936  copy_page_range
14        0.9936  kmem_cache_alloc
14        0.9936  page_address
13        0.9226  dio_send_cur_page
13        0.9226  find_vma
13        0.9226  strnlen_user
12        0.8517  do_page_fault
12        0.8517  radix_tree_lookup
12        0.8517  submit_page_section
11        0.7807  acpi_os_read_port
11        0.7807  schedule
10        0.7097  __copy_to_user_ll
10        0.7097  __find_get_block
10        0.7097  dio_get_page
10        0.7097  do_mmap_pgoff
10        0.7097  native_io_delay
9         0.6388  blk_recount_segments
9         0.6388  filemap_nopage
8         0.5678  bio_add_page
8         0.5678  dio_bio_add_page
8         0.5678  load_elf_binary
8         0.5678  memcpy
7         0.4968  pit_next_event
6         0.4258  acpi_os_write_port
6         0.4258  bio_alloc_bioset
6         0.4258  free_pgtables
5         0.3549  kmem_cache_free
5         0.3549  mark_page_accessed
5         0.3549  restore_nocheck
5         0.3549  strncpy_from_user
5         0.3549  sysenter_past_esp
4         0.2839  __copy_from_user_ll
4         0.2839  __inc_zone_state
4         0.2839  __mutex_lock_slowpath
4         0.2839  _spin_lock_irqsave
4         0.2839  blk_rq_map_sg
4         0.2839  current_fs_time
4         0.2839  end_that_request_last
4         0.2839  error_code
4         0.2839  generic_make_request
4         0.2839  generic_permission
4         0.2839  get_user_pages
4         0.2839  getnstimeofday
4         0.2839  hweight32
4         0.2839  max_block
4         0.2839  sched_clock
4         0.2839  try_to_wake_up
4         0.2839  vfs_read
4         0.2839  vma_merge
3         0.2129  __alloc_pages
3         0.2129  __find_get_block_slow
3         0.2129  __fput
3         0.2129  bio_init
3         0.2129  cache_alloc_refill
3         0.2129  cfq_insert_request
3         0.2129  cond_resched
3         0.2129  do_sys_open
3         0.2129  dput
3         0.2129  flush_tlb_mm
3         0.2129  free_page_and_swap_cache
3         0.2129  generic_file_aio_read
3         0.2129  get_next_timer_interrupt
3         0.2129  hrtimer_get_next_event
3         0.2129  init_request_from_bio
3         0.2129  internal_add_timer
3         0.2129  kmem_cache_zalloc
3         0.2129  ktime_get_ts
3         0.2129  page_remove_rmap
3         0.2129  permission
3         0.2129  set_page_dirty_lock
3         0.2129  sys_close
3         0.2129  sys_mprotect
3         0.2129  touch_atime
3         0.2129  unlock_page
3         0.2129  zone_watermark_ok
2         0.1419  __add_entropy_words
2         0.1419  __atomic_notifier_call_chain
2         0.1419  __dec_zone_state
2         0.1419  __do_page_cache_readahead
2         0.1419  __end_that_request_first
2         0.1419  __make_request
2         0.1419  __switch_to
2         0.1419  __wake_up_bit
2         0.1419  _atomic_dec_and_lock
2         0.1419  anon_vma_prepare
2         0.1419  bio_get_nr_vecs
2         0.1419  copy_strings
2         0.1419  copy_to_user
2         0.1419  d_alloc
2         0.1419  dio_bio_complete
2         0.1419  dnotify_parent
2         0.1419  do_notify_resume
2         0.1419  do_sigaction
2         0.1419  do_sys_poll
2         0.1419  down_read_trylock
2         0.1419  elv_dispatch_sort
2         0.1419  enqueue_hrtimer
2         0.1419  find_busiest_group
2         0.1419  find_vma_prepare
2         0.1419  flush_tlb_page
2         0.1419  free_uid
2         0.1419  generic_fillattr
2         0.1419  kmap_atomic_prot
2         0.1419  native_flush_tlb_single
2         0.1419  new_inode
2         0.1419  path_release
2         0.1419  pipe_write
2         0.1419  prio_tree_insert
2         0.1419  proc_lookup
2         0.1419  quicklist_trim
2         0.1419  rb_erase
2         0.1419  rb_insert_color
2         0.1419  recalc_task_prio
2         0.1419  restore_sigcontext
2         0.1419  ret_from_intr
2         0.1419  rw_verify_area
2         0.1419  sys_brk
2         0.1419  task_rq_lock
2         0.1419  tick_nohz_update_jiffies
2         0.1419  update_wall_time
2         0.1419  vm_normal_page
2         0.1419  vma_link
2         0.1419  vma_prio_tree_add
2         0.1419  wake_up_new_task
1         0.0710  __anon_vma_link
1         0.0710  __copy_user_intel
1         0.0710  __d_path
1         0.0710  __dentry_open
1         0.0710  __free_pages_ok
1         0.0710  __freed_request
1         0.0710  __get_user_4
1         0.0710  __init_rwsem
1         0.0710  __kmalloc
1         0.0710  __page_set_anon_rmap
1         0.0710  __pagevec_lru_add
1         0.0710  __pagevec_lru_add_active
1         0.0710  __rb_rotate_left
1         0.0710  __sk_dst_check
1         0.0710  __tasklet_schedule
1         0.0710  __vm_enough_memory
1         0.0710  __vma_link_rb
1         0.0710  __wait_on_bit
1         0.0710  __wake_up
1         0.0710  __wake_up_common
1         0.0710  _d_rehash
1         0.0710  acpi_hw_low_level_read
1         0.0710  acpi_hw_register_read
1         0.0710  add_timer_randomness
1         0.0710  alloc_pid
1         0.0710  anon_vma_unlink
1         0.0710  atomic_notifier_call_chain
1         0.0710  attach_pid
1         0.0710  bio_alloc
1         0.0710  bit_waitqueue
1         0.0710  blk_backing_dev_unplug
1         0.0710  blk_queue_bounce
1         0.0710  block_llseek
1         0.0710  block_read_full_page
1         0.0710  cache_reap
1         0.0710  cached_lookup
1         0.0710  call_rcu
1         0.0710  cfq_may_queue
1         0.0710  cfq_merge
1         0.0710  cfq_queue_empty
1         0.0710  clockevents_program_event
1         0.0710  cp_new_stat64
1         0.0710  cpu_idle
1         0.0710  create_read_pipe
1         0.0710  current_io_context
1         0.0710  d_path
1         0.0710  debug_mutex_free_waiter
1         0.0710  del_timer
1         0.0710  dequeue_signal
1         0.0710  dequeue_task
1         0.0710  detach_pid
1         0.0710  dio_complete
1         0.0710  dio_new_bio
1         0.0710  dio_zero_block
1         0.0710  disk_round_stats
1         0.0710  dnotify_flush
1         0.0710  do_IRQ
1         0.0710  do_brk
1         0.0710  do_exit
1         0.0710  do_fork
1         0.0710  do_generic_mapping_read
1         0.0710  do_syslog
1         0.0710  do_wait
1         0.0710  dummy_inode_alloc_security
1         0.0710  dummy_vm_enough_memory
1         0.0710  dup_fd
1         0.0710  effective_prio
1         0.0710  elv_insert
1         0.0710  elv_rqhash_add
1         0.0710  enable_8259A_irq
1         0.0710  exit_aio
1         0.0710  exit_mmap
1         0.0710  exit_thread
1         0.0710  fget
1         0.0710  fget_light
1         0.0710  filp_close
1         0.0710  find_extend_vma
1         0.0710  find_next_bit
1         0.0710  find_next_zero_bit
1         0.0710  find_vma_prev
1         0.0710  flush_signal_handlers
1         0.0710  fput
1         0.0710  free_hot_page
1         0.0710  free_pages_bulk
1         0.0710  free_pgd_range
1         0.0710  free_pipe_info
1         0.0710  generic_drop_inode
1         0.0710  generic_file_buffered_write
1         0.0710  generic_file_open
1         0.0710  generic_unplug_device
1         0.0710  get_empty_filp
1         0.0710  get_index
1         0.0710  get_nr_files
1         0.0710  get_request
1         0.0710  get_signal_to_deliver
1         0.0710  get_unused_fd
1         0.0710  getname
1         0.0710  half_md4_transform
1         0.0710  hrtimer_init
1         0.0710  hrtimer_start
1         0.0710  init_new_context
1         0.0710  init_waitqueue_head
1         0.0710  inode_setattr
1         0.0710  inotify_d_instantiate
1         0.0710  install_special_mapping
1         0.0710  ktime_get
1         0.0710  kunmap_atomic
1         0.0710  lapic_next_event
1         0.0710  lock_hrtimer_base
1         0.0710  lock_timer_base
1         0.0710  locks_remove_posix
1         0.0710  may_open
1         0.0710  memory_open
1         0.0710  mempool_alloc
1         0.0710  mempool_alloc_slab
1         0.0710  mm_init
1         0.0710  mm_release
1         0.0710  mntput_no_expire
1         0.0710  native_set_pte_at
1         0.0710  notifier_call_chain
1         0.0710  ns_to_timespec
1         0.0710  open_exec
1         0.0710  open_namei
1         0.0710  page_waitqueue
1         0.0710  percpu_counter_mod
1         0.0710  pipe_release
1         0.0710  proc_flush_task
1         0.0710  proc_sys_lookup_table_one
1         0.0710  profile_munmap
1         0.0710  radix_tree_insert
1         0.0710  radix_tree_preload
1         0.0710  rb_first
1         0.0710  read_chan
1         0.0710  recalc_bh_state
1         0.0710  recalc_sigpending_tsk
1         0.0710  release_task
1         0.0710  resched_task
1         0.0710  resume_kernel
1         0.0710  resume_userspace
1         0.0710  rt_set_nexthop
1         0.0710  secure_ip_id
1         0.0710  select_nohz_load_balancer
1         0.0710  send_signal
1         0.0710  seq_path
1         0.0710  seq_printf
1         0.0710  set_page_dirty
1         0.0710  should_remove_suid
1         0.0710  sigprocmask
1         0.0710  sock_aio_write
1         0.0710  submit_bio
1         0.0710  sys_fstat64
1         0.0710  sys_llseek
1         0.0710  sys_poll
1         0.0710  sys_rt_sigprocmask
1         0.0710  tcp_poll
1         0.0710  tick_do_update_jiffies64
1         0.0710  tick_nohz_restart_sched_tick
1         0.0710  tick_nohz_stop_sched_tick
1         0.0710  tick_sched_timer
1         0.0710  tty_ldisc_try
1         0.0710  tty_wakeup
1         0.0710  vfs_getattr
1         0.0710  vfs_llseek
1         0.0710  vfs_permission
1         0.0710  vfs_write
1         0.0710  vmtruncate
1         0.0710  vsnprintf
1         0.0710  wake_up_bit
1         0.0710  wake_up_process
1         0.0710  write_cache_pages

--------------030208090408010003070506--

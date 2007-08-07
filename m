Return-Path: <linux-kernel-owner+w=401wt.eu-S1765840AbXHGOxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765840AbXHGOxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbXHGOxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:53:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:59596 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752831AbXHGOxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:53:38 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1+ilF9nDyqiTFSuqWt0Z6jePu6Z8UAlfhgjUZylHx
	1SwUiywnHK4ykZ
From: Dimitrios Apostolou <jimis@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
Date: Tue, 7 Aug 2007 17:50:50 +0300
User-Agent: KMail/1.9.7
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       =?utf-8?q?Rafa=C5=82_Bilski?= <rafalbilski@interia.pl>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200708031903.10063.jimis@gmx.net>
In-Reply-To: <200708031903.10063.jimis@gmx.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_LbIuGjbp0PRf3Z1"
Message-Id: <200708071750.51019.jimis@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_LbIuGjbp0PRf3Z1
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello again, 

I 'm now using libata on the same system described before (see attached 
dmesg.txt). When writing to both disks I think the problem is now worse 
(pata_oprof_bad.txt, pata_vmstat_bad.txt), even the oprofile script needed 
half an hour to complete! For completion I also attach the same tests when I 
write to only one disk (pata_vmstat_1disk.txt, pata_oprof_1disk.txt), whence 
everything is normal. 

FWIW, libata did not give me any performance benefit, 20MB/s is again the peak 
hdparm reports. 


Thanks, 
Dimitris


--Boundary-00=_LbIuGjbp0PRf3Z1
Content-Type: text/plain;
  charset="utf-8";
  name="pata_vmstat_1disk.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="pata_vmstat_1disk.txt"

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 1  1      0 128812  19620  82484    0    0   117  7817  355  708 24 50 22  4
 0  1      0 128804  19620  82484    0    0     0 21120  330  673  0  1  0 99
 0  1      0 128804  19620  82484    0    0     0 21184  341  683  0  4  0 96
 0  1      0 128804  19620  82484    0    0     0 21120  335  675  0  4  0 96
 0  1      0 128804  19620  82484    0    0     0 21124  340  682  0  3  0 97
 0  1      0 128744  19620  82484    0    0     0 21120  341  678  0  2  0 98
 1  1      0 128744  19628  82484    0    0     0 20980  339  687  0  2  0 98
 1  1      0 128744  19628  82484    0    0     0 21120  346  675  0  3  0 97
 1  1      0 128744  19628  82484    0    0     0 21120  345  679  0  4  0 96
 0  1      0 128744  19628  82484    0    0     0 21128  337  682  0  3  0 97

--Boundary-00=_LbIuGjbp0PRf3Z1
Content-Type: text/plain;
  charset="utf-8";
  name="pata_oprof_1disk.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="pata_oprof_1disk.txt"

Tue Aug  7 17:47:43 EEST 2007
+ opcontrol --vmlinux=/usr/src/linux-2.6.22-ARCH/vmlinux
+ opcontrol --start
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Daemon started.
Profiler running.
+ sleep 5
+ opcontrol --shutdown
Stopping profiling.
Killing daemon.
+ echo

+ echo

+ echo

+ opreport
CPU: PIII, speed 798.031 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
    40037 96.5142 vmlinux
      413  0.9956 libc-2.6.so
      225  0.5424 oprofiled
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	      224 99.5556 oprofiled
	        1  0.4444 anon (tgid:5252 range:0xb7fb6000-0xb7fb7000)
      215  0.5183 bash
      208  0.5014 ld-2.6.so
       87  0.2097 ext3
       87  0.2097 oprofile
       68  0.1639 libata
       54  0.1302 ISO8859-1.so
       21  0.0506 jbd
       11  0.0265 badblocks
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        8 72.7273 badblocks
	        3 27.2727 anon (tgid:5166 range:0xb7f1d000-0xb7f1e000)
        7  0.0169 imap-login
        6  0.0145 grep
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        5 83.3333 grep
	        1 16.6667 anon (tgid:5267 range:0x805b000-0x807c000)
        6  0.0145 libext2fs.so.2.4
        6  0.0145 locale-archive
        5  0.0121 sd_mod
        3  0.0072 gawk
        3  0.0072 libcrypto.so.0.9.8
        2  0.0048 tr
        2  0.0048 libncurses.so.5.6
        2  0.0048 screen-4.0.3
        2  0.0048 libnetsnmp.so.15.0.0
        2  0.0048 dovecot
        2  0.0048 sshd
        1  0.0024 ls
        1  0.0024 libdl-2.6.so
        1  0.0024 libnss_files-2.6.so
        1  0.0024 libpcre.so.0.0.1
        1  0.0024 libreadline.so.5.2
        1  0.0024 dirname
        1  0.0024 which
        1  0.0024 libpopt.so.0.0.0
        1  0.0024 dovecot-auth
+ echo

+ echo

+ echo

+ opreport -l /usr/src/linux-2.6.22-ARCH/vmlinux
CPU: PIII, speed 798.031 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
28617    71.4764  cpu_idle
4163     10.3979  poll_idle
3220      8.0426  quicklist_trim
1465      3.6591  check_pgt_cache
414       1.0340  delay_tsc
188       0.4696  do_wp_page
115       0.2872  iowrite8
82        0.2048  ioread8
67        0.1673  mask_and_ack_8259A
65        0.1623  __handle_mm_fault
52        0.1299  get_page_from_freelist
45        0.1124  __copy_to_user_ll
44        0.1099  __blockdev_direct_IO
43        0.1074  unmap_vmas
34        0.0849  put_page
30        0.0749  page_fault
28        0.0699  schedule
22        0.0549  follow_page
20        0.0500  __bio_add_page
20        0.0500  blk_rq_map_sg
19        0.0475  __d_lookup
19        0.0475  enable_8259A_irq
17        0.0425  kmem_cache_free
16        0.0400  filemap_nopage
16        0.0400  kmem_cache_alloc
15        0.0375  __link_path_walk
15        0.0375  find_get_page
14        0.0350  copy_process
14        0.0350  page_address
12        0.0300  __switch_to
12        0.0300  blk_recount_segments
12        0.0300  getnstimeofday
11        0.0275  generic_make_request
11        0.0275  radix_tree_lookup
11        0.0275  read_tsc
11        0.0275  sysenter_past_esp
10        0.0250  __generic_file_aio_write_nolock
10        0.0250  copy_page_range
9         0.0225  cfq_insert_request
9         0.0225  do_generic_mapping_read
9         0.0225  do_page_fault
9         0.0225  enqueue_hrtimer
9         0.0225  find_vma
9         0.0225  ktime_get_ts
9         0.0225  load_elf_binary
8         0.0200  __mod_timer
8         0.0200  cfq_dispatch_requests
8         0.0200  dio_send_cur_page
8         0.0200  get_next_timer_interrupt
8         0.0200  handle_level_irq
8         0.0200  mempool_free
8         0.0200  rb_insert_color
8         0.0200  sched_clock
8         0.0200  strnlen_user
8         0.0200  submit_page_section
7         0.0175  __mutex_lock_slowpath
7         0.0175  blk_backing_dev_unplug
7         0.0175  dio_bio_add_page
7         0.0175  do_IRQ
7         0.0175  hrtimer_force_reprogram
7         0.0175  iowrite32
7         0.0175  try_to_wake_up
6         0.0150  __do_softirq
6         0.0150  do_mmap_pgoff
6         0.0150  fget_light
6         0.0150  find_busiest_group
6         0.0150  permission
6         0.0150  rb_erase
6         0.0150  scsi_dispatch_cmd
6         0.0150  task_running_tick
5         0.0125  __add_entropy_words
5         0.0125  __const_udelay
5         0.0125  __mutex_unlock_slowpath
5         0.0125  __rcu_pending
5         0.0125  _atomic_dec_and_lock
5         0.0125  blk_remove_plug
5         0.0125  block_llseek
5         0.0125  cfq_set_request
5         0.0125  clockevents_program_event
5         0.0125  debug_mutex_add_waiter
5         0.0125  del_timer
5         0.0125  dio_bio_complete
5         0.0125  elv_completed_request
5         0.0125  get_request
5         0.0125  hweight32
5         0.0125  kfree
5         0.0125  lock_timer_base
5         0.0125  memcpy
5         0.0125  native_load_tls
5         0.0125  preempt_schedule
5         0.0125  scsi_get_command
5         0.0125  submit_bio
5         0.0125  tick_nohz_stop_sched_tick
5         0.0125  update_wall_time
4         0.0100  __dentry_open
4         0.0100  __end_that_request_first
4         0.0100  __make_request
4         0.0100  _spin_lock_irqsave
4         0.0100  add_timer_randomness
4         0.0100  alloc_inode
4         0.0100  bio_add_page
4         0.0100  block_read_full_page
4         0.0100  cfq_remove_request
4         0.0100  cond_resched
4         0.0100  dequeue_task
4         0.0100  dio_get_page
4         0.0100  do_sync_write
4         0.0100  dup_fd
4         0.0100  elv_insert
4         0.0100  error_code
4         0.0100  filp_close
4         0.0100  find_next_zero_bit
4         0.0100  flush_tlb_mm
4         0.0100  free_pgtables
4         0.0100  generic_permission
4         0.0100  generic_unplug_device
4         0.0100  get_user_pages
4         0.0100  hrtimer_try_to_cancel
4         0.0100  lock_hrtimer_base
4         0.0100  max_block
4         0.0100  rw_verify_area
4         0.0100  scsi_request_fn
4         0.0100  select_nohz_load_balancer
4         0.0100  tick_nohz_restart_sched_tick
4         0.0100  unlink_file_vma
3         0.0075  __alloc_pages
3         0.0075  __copy_from_user_ll
3         0.0075  __copy_user_intel
3         0.0075  __find_get_block
3         0.0075  __find_get_block_slow
3         0.0075  __fput
3         0.0075  __kmalloc
3         0.0075  __mutex_init
3         0.0075  __pte_alloc
3         0.0075  __rcu_process_callbacks
3         0.0075  __scsi_put_command
3         0.0075  __wake_up_bit
3         0.0075  anon_vma_link
3         0.0075  arch_get_unmapped_area_topdown
3         0.0075  bio_alloc_bioset
3         0.0075  bio_free
3         0.0075  bio_init
3         0.0075  blk_queue_bounce
3         0.0075  blkdev_get_blocks
3         0.0075  cache_alloc_refill
3         0.0075  call_rcu
3         0.0075  cfq_completed_request
3         0.0075  cfq_service_tree_add
3         0.0075  d_alloc
3         0.0075  debug_mutex_lock_common
3         0.0075  dnotify_parent
3         0.0075  do_path_lookup
3         0.0075  do_softirq
3         0.0075  do_sync_read
3         0.0075  do_sys_poll
3         0.0075  drive_stat_acct
3         0.0075  elv_next_request
3         0.0075  file_update_time
3         0.0075  free_block
3         0.0075  generic_file_aio_write_nolock
3         0.0075  generic_file_direct_write
3         0.0075  generic_segment_checks
3         0.0075  get_empty_filp
3         0.0075  get_request_wait
3         0.0075  get_unused_fd
3         0.0075  getname
3         0.0075  hrtimer_forward
3         0.0075  hrtimer_start
3         0.0075  inode_init_once
3         0.0075  inotify_d_instantiate
3         0.0075  io_schedule
3         0.0075  irq_entries_start
3         0.0075  kmem_cache_zalloc
3         0.0075  kunmap_atomic
3         0.0075  mark_page_accessed
3         0.0075  mutex_remove_waiter
3         0.0075  notifier_call_chain
3         0.0075  pipe_read
3         0.0075  rb_next
3         0.0075  recalc_task_prio
3         0.0075  run_timer_softirq
3         0.0075  scsi_device_unbusy
3         0.0075  scsi_finish_command
3         0.0075  scsi_io_completion
3         0.0075  scsi_run_queue
3         0.0075  set_normalized_timespec
3         0.0075  smp_apic_timer_interrupt
3         0.0075  sys_lseek
3         0.0075  vfs_write
2         0.0050  __atomic_notifier_call_chain
2         0.0050  __blk_put_request
2         0.0050  __d_path
2         0.0050  __dec_zone_state
2         0.0050  __do_page_cache_readahead
2         0.0050  __getblk
2         0.0050  __inc_zone_page_state
2         0.0050  __inc_zone_state
2         0.0050  __remove_hrtimer
2         0.0050  __rmqueue
2         0.0050  __scsi_get_command
2         0.0050  __wake_up
2         0.0050  account_system_time
2         0.0050  alloc_pid
2         0.0050  anon_vma_unlink
2         0.0050  atomic_notifier_call_chain
2         0.0050  bit_waitqueue
2         0.0050  blk_do_ordered
2         0.0050  cfq_init_prio_data
2         0.0050  cfq_queue_empty
2         0.0050  clocksource_get_next
2         0.0050  common_interrupt
2         0.0050  copy_to_user
2         0.0050  current_fs_time
2         0.0050  deactivate_task
2         0.0050  debug_mutex_unlock
2         0.0050  dentry_iput
2         0.0050  dio_bio_end_io
2         0.0050  dio_new_bio
2         0.0050  disk_round_stats
2         0.0050  do_exit
2         0.0050  do_lookup
2         0.0050  do_mremap
2         0.0050  do_sigaction
2         0.0050  do_wait
2         0.0050  dummy_capget
2         0.0050  dummy_inode_permission
2         0.0050  elv_may_queue
2         0.0050  elv_queue_empty
2         0.0050  elv_rqhash_del
2         0.0050  end_that_request_last
2         0.0050  enqueue_task
2         0.0050  exit_itimers
2         0.0050  fget
2         0.0050  file_move
2         0.0050  file_read_actor
2         0.0050  find_or_create_page
2         0.0050  flush_signal_handlers
2         0.0050  flush_tlb_page
2         0.0050  fput
2         0.0050  free_hot_cold_page
2         0.0050  free_page_and_swap_cache
2         0.0050  generic_fillattr
2         0.0050  get_signal_to_deliver
2         0.0050  init_request_from_bio
2         0.0050  inotify_inode_queue_event
2         0.0050  internal_add_timer
2         0.0050  irq_enter
2         0.0050  irq_exit
2         0.0050  kill_fasync
2         0.0050  kref_put
2         0.0050  ktime_get
2         0.0050  link_path_walk
2         0.0050  mempool_alloc
2         0.0050  mm_release
2         0.0050  native_load_esp0
2         0.0050  native_read_tsc
2         0.0050  page_cache_readahead
2         0.0050  pipe_poll
2         0.0050  radix_tree_insert
2         0.0050  raise_softirq
2         0.0050  rcu_needs_cpu
2         0.0050  recalc_sigpending_tsk
2         0.0050  release_pages
2         0.0050  release_task
2         0.0050  run_posix_cpu_timers
2         0.0050  sched_balance_self
2         0.0050  scheduler_tick
2         0.0050  scsi_done
2         0.0050  scsi_prep_fn
2         0.0050  scsi_put_command
2         0.0050  scsi_softirq_done
2         0.0050  sys_fstat64
2         0.0050  sys_mprotect
2         0.0050  sys_open
2         0.0050  tasklet_action
2         0.0050  tick_do_update_jiffies64
2         0.0050  tick_nohz_update_jiffies
2         0.0050  unlock_buffer
2         0.0050  vm_normal_page
2         0.0050  vma_adjust
2         0.0050  vma_prio_tree_add
2         0.0050  vsnprintf
1         0.0025  __activate_task
1         0.0025  __block_prepare_write
1         0.0025  __dequeue_signal
1         0.0025  __elv_add_request
1         0.0025  __free_pages_ok
1         0.0025  __generic_unplug_device
1         0.0025  __get_free_pages
1         0.0025  __get_user_4
1         0.0025  __mark_inode_dirty
1         0.0025  __mod_zone_page_state
1         0.0025  __mutex_lock_interruptible_slowpath
1         0.0025  __page_set_anon_rmap
1         0.0025  __path_lookup_intent_open
1         0.0025  __remove_shared_vm_struct
1         0.0025  __scsi_done
1         0.0025  __sigqueue_alloc
1         0.0025  __sock_create
1         0.0025  __tasklet_schedule
1         0.0025  __tcp_push_pending_frames
1         0.0025  __user_walk_fd
1         0.0025  __vm_enough_memory
1         0.0025  alloc_page_buffers
1         0.0025  anon_vma_prepare
1         0.0025  arch_align_stack
1         0.0025  arch_setup_additional_pages
1         0.0025  autoremove_wake_function
1         0.0025  bio_endio
1         0.0025  bio_fs_destructor
1         0.0025  bio_put
1         0.0025  blk_plug_device
1         0.0025  blk_run_queue
1         0.0025  blk_start_queueing
1         0.0025  blk_unplug_timeout
1         0.0025  blkdev_direct_IO
1         0.0025  cache_reap
1         0.0025  can_vma_merge_after
1         0.0025  cfq_add_rq_rb
1         0.0025  cfq_cic_rb_lookup
1         0.0025  cfq_may_queue
1         0.0025  cleanup_timers
1         0.0025  clear_bdi_congested
1         0.0025  clear_inode
1         0.0025  clocksource_watchdog
1         0.0025  copy_strings_kernel
1         0.0025  cp_new_stat64
1         0.0025  create_empty_buffers
1         0.0025  credit_entropy_store
1         0.0025  d_rehash
1         0.0025  datagram_poll
1         0.0025  dec_zone_page_state
1         0.0025  dequeue_signal
1         0.0025  dev_watchdog
1         0.0025  dio_bio_submit
1         0.0025  dio_cleanup
1         0.0025  dio_complete
1         0.0025  dio_zero_block
1         0.0025  do_select
1         0.0025  do_sys_open
1         0.0025  do_timer
1         0.0025  down_read_trylock
1         0.0025  dput
1         0.0025  drain_array
1         0.0025  dummy_bprm_alloc_security
1         0.0025  dummy_file_alloc_security
1         0.0025  dummy_task_alloc_security
1         0.0025  elf_map
1         0.0025  elv_dequeue_request
1         0.0025  elv_dispatch_sort
1         0.0025  elv_rb_add
1         0.0025  elv_rb_del
1         0.0025  elv_rqhash_add
1         0.0025  elv_set_request
1         0.0025  exit_mmap
1         0.0025  expand_files
1         0.0025  fasync_helper
1         0.0025  fd_install
1         0.0025  file_ra_state_init
1         0.0025  find_extend_vma
1         0.0025  find_next_bit
1         0.0025  find_vma_prev
1         0.0025  flush_old_exec
1         0.0025  flush_thread
1         0.0025  free_pid
1         0.0025  free_poll_entry
1         0.0025  generic_file_aio_read
1         0.0025  generic_file_direct_IO
1         0.0025  generic_file_open
1         0.0025  get_device
1         0.0025  get_nr_files
1         0.0025  get_task_mm
1         0.0025  hrtimer_get_next_event
1         0.0025  hrtimer_interrupt
1         0.0025  hrtimer_reprogram
1         0.0025  idle_cpu
1         0.0025  init_new_context
1         0.0025  init_page_buffers
1         0.0025  init_timer
1         0.0025  inode_change_ok
1         0.0025  inode_sub_bytes
1         0.0025  inotify_dentry_parent_queue_event
1         0.0025  iov_fault_in_pages_read
1         0.0025  ip_local_deliver
1         0.0025  ip_output
1         0.0025  kmap_atomic_prot
1         0.0025  kref_get
1         0.0025  kthread_should_stop
1         0.0025  lapic_next_event
1         0.0025  locks_remove_flock
1         0.0025  lru_cache_add_active
1         0.0025  may_open
1         0.0025  mempool_free_slab
1         0.0025  mod_timer
1         0.0025  mutex_unlock
1         0.0025  native_apic_write
1         0.0025  native_flush_tlb
1         0.0025  native_flush_tlb_single
1         0.0025  native_set_pte_at
1         0.0025  neigh_lookup
1         0.0025  new_inode
1         0.0025  note_interrupt
1         0.0025  notify_change
1         0.0025  number
1         0.0025  ordered_bio_endio
1         0.0025  page_add_file_rmap
1         0.0025  page_remove_rmap
1         0.0025  page_waitqueue
1         0.0025  path_lookup_open
1         0.0025  path_walk
1         0.0025  percpu_counter_mod
1         0.0025  pipe_write
1         0.0025  prepare_to_copy
1         0.0025  prio_tree_insert
1         0.0025  proc_flush_task
1         0.0025  proc_lookup
1         0.0025  put_io_context
1         0.0025  raise_softirq_irqoff
1         0.0025  rb_first
1         0.0025  rb_prev
1         0.0025  rcu_pending
1         0.0025  rcu_process_callbacks
1         0.0025  read_chan
1         0.0025  release_vm86_irqs
1         0.0025  remove_suid
1         0.0025  restore_nocheck
1         0.0025  resume_userspace
1         0.0025  ret_from_intr
1         0.0025  rq_init
1         0.0025  sched_exit
1         0.0025  schedule_tail
1         0.0025  schedule_timeout
1         0.0025  scsi_add_timer
1         0.0025  scsi_alloc_sgtable
1         0.0025  scsi_end_request
1         0.0025  scsi_free_sgtable
1         0.0025  scsi_get_cmd_from_req
1         0.0025  scsi_next_command
1         0.0025  search_binary_handler
1         0.0025  secure_ip_id
1         0.0025  seq_printf
1         0.0025  sha_transform
1         0.0025  show_stat
1         0.0025  special_mapping_nopage
1         0.0025  split_vma
1         0.0025  strncpy_from_user
1         0.0025  sys_brk
1         0.0025  sys_close
1         0.0025  sys_dup2
1         0.0025  sys_faccessat
1         0.0025  sys_gettimeofday
1         0.0025  sys_lookup_dcookie
1         0.0025  sys_mkdirat
1         0.0025  sys_read
1         0.0025  sys_rt_sigprocmask
1         0.0025  sys_set_thread_area
1         0.0025  sys_socketcall
1         0.0025  sys_wait4
1         0.0025  sys_write
1         0.0025  task_rq_lock
1         0.0025  tcp_ack
1         0.0025  tcp_poll
1         0.0025  tcp_v4_rcv
1         0.0025  tick_sched_timer
1         0.0025  tty_ioctl
1         0.0025  unix_poll
1         0.0025  up_write
1         0.0025  vfs_getattr
1         0.0025  vfs_llseek
1         0.0025  vfs_mkdir
1         0.0025  vfs_read
1         0.0025  vm_stat_account
1         0.0025  vma_link
1         0.0025  vma_merge
1         0.0025  vma_prio_tree_insert
1         0.0025  vma_prio_tree_remove
1         0.0025  wake_up_bit
1         0.0025  wake_up_new_task
+ date
Tue Aug  7 17:47:50 EEST 2007

--Boundary-00=_LbIuGjbp0PRf3Z1
Content-Type: text/plain;
  charset="utf-8";
  name="pata_oprof_bad.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="pata_oprof_bad.txt"

Tue Aug  7 17:06:32 EEST 2007
+ opcontrol --vmlinux=/usr/src/linux-2.6.22-ARCH/vmlinux
+ opcontrol --start
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Daemon started.
Profiler running.
+ sleep 5
+ opcontrol --shutdown
Stopping profiling.
Killing daemon.
+ echo

+ echo

+ echo

+ opreport
CPU: PIII, speed 798.031 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
    36680 82.6759 vmlinux
     2666  6.0091 libc-2.6.so
     1069  2.4095 perl
      700  1.5778 libpython2.5.so.1.0
      638  1.4380 mpop
      595  1.3411 libata
      326  0.7348 oprofiled
      322  0.7258 ld-2.6.so
      211  0.4756 libgnutls.so.13.3.0
      211  0.4756 libtasn1.so.3.0.10
      207  0.4666 bash
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	      205 99.0338 bash
	        1  0.4831 anon (tgid:4308 range:0xb7f72000-0xb7f73000)
	        1  0.4831 anon (tgid:4321 range:0xb7ea8000-0xb7fd2000)
      117  0.2637 ext3
       95  0.2141 jbd
       85  0.1916 oprofile
       77  0.1736 imap-login
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	       72 93.5065 imap-login
	        2  2.5974 anon (tgid:3959 range:0xb7f25000-0xb7f26000)
	        2  2.5974 anon (tgid:3960 range:0xb7ee9000-0xb7eea000)
	        1  1.2987 anon (tgid:4102 range:0xb7f92000-0xb7f93000)
       51  0.1150 badblocks
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	       31 60.7843 badblocks
	       16 31.3725 anon (tgid:4024 range:0xb7ef2000-0xb7ef3000)
	        4  7.8431 anon (tgid:4023 range:0xb7f20000-0xb7f21000)
       49  0.1104 ISO8859-1.so
       39  0.0879 libpthread-2.6.so
       39  0.0879 skge
       32  0.0721 sd_mod
       31  0.0699 dovecot
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	       30 96.7742 dovecot
	        1  3.2258 anon (tgid:3937 range:0xb7f8b000-0xb7f8c000)
       17  0.0383 libext2fs.so.2.4
       16  0.0361 libgcrypt.so.11.2.3
       16  0.0361 dovecot-auth
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	       14 87.5000 dovecot-auth
	        2 12.5000 anon (tgid:3940 range:0xb7fa8000-0xb7fa9000)
       11  0.0248 locale-archive
       10  0.0225 libnetsnmpmibs.so.15.0.0
        9  0.0203 libcrypto.so.0.9.8
        8  0.0180 libnetsnmp.so.15.0.0
        6  0.0135 ls
        5  0.0113 reiserfs
        4  0.0090 gawk
        3  0.0068 grep
        3  0.0068 snmpd
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        2 66.6667 anon (tgid:3920 range:0xb7fd9000-0xb7fda000)
	        1 33.3333 snmpd
        2  0.0045 libdl-2.6.so
        2  0.0045 libnss_files-2.6.so
        2  0.0045 mktemp
        2  0.0045 libnetsnmpagent.so.15.0.0
        2  0.0045 libpopt.so.0.0.0
        2  0.0045 imap
        1  0.0023 libattr.so.1.1.0
        1  0.0023 libncurses.so.5.6
        1  0.0023 python2.5
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        1 100.000 anon (tgid:4269 range:0xb7eed000-0xb7eee000)
        1  0.0023 screen-4.0.3
        1  0.0023 crond
        1  0.0023 sshd
+ echo

+ echo

+ echo

+ opreport -l /usr/src/linux-2.6.22-ARCH/vmlinux
CPU: PIII, speed 798.031 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
9556     26.0523  delay_tsc
6424     17.5136  iowrite8
6178     16.8430  __switch_to
4015     10.9460  schedule
3335      9.0921  ioread8
1429      3.8959  iowrite32
363       0.9896  native_load_tls
205       0.5589  __blockdev_direct_IO
154       0.4198  dequeue_task
149       0.4062  mask_and_ack_8259A
129       0.3517  __copy_to_user_ll
125       0.3408  follow_page
118       0.3217  do_wp_page
97        0.2644  put_page
86        0.2345  blk_rq_map_sg
82        0.2236  blk_recount_segments
73        0.1990  __bio_add_page
67        0.1827  scsi_request_fn
64        0.1745  __handle_mm_fault
64        0.1745  unmap_vmas
63        0.1718  get_page_from_freelist
61        0.1663  hweight32
60        0.1636  task_running_tick
58        0.1581  __link_path_walk
54        0.1472  __make_request
54        0.1472  rb_erase
53        0.1445  do_page_fault
53        0.1445  hrtimer_interrupt
50        0.1363  kmem_cache_alloc
46        0.1254  irq_entries_start
46        0.1254  page_address
44        0.1200  static_prio_timeslice
42        0.1145  dio_bio_add_page
41        0.1118  sched_clock
40        0.1091  enable_8259A_irq
39        0.1063  dio_send_cur_page
38        0.1036  elv_insert
38        0.1036  filemap_nopage
38        0.1036  get_user_pages
37        0.1009  submit_page_section
36        0.0981  __d_lookup
36        0.0981  kmem_cache_free
36        0.0981  sysenter_past_esp
35        0.0954  page_fault
34        0.0927  dio_get_page
34        0.0927  restore_all
33        0.0900  __generic_file_aio_write_nolock
33        0.0900  cfq_insert_request
31        0.0845  __mutex_lock_slowpath
31        0.0845  blk_do_ordered
31        0.0845  cfq_dispatch_requests
30        0.0818  scsi_get_command
28        0.0763  _spin_lock_irqsave
28        0.0763  find_get_page
28        0.0763  generic_make_request
28        0.0763  preempt_schedule_irq
27        0.0736  cache_reap
26        0.0709  bio_add_page
25        0.0682  __mod_timer
25        0.0682  elv_next_request
25        0.0682  scsi_prep_fn
24        0.0654  dio_bio_complete
23        0.0627  cfq_set_request
23        0.0627  find_vma
23        0.0627  mempool_free
22        0.0600  __const_udelay
22        0.0600  fget_light
21        0.0573  bio_alloc_bioset
21        0.0573  del_timer
21        0.0573  do_sys_poll
20        0.0545  scsi_dispatch_cmd
19        0.0518  __add_entropy_words
19        0.0518  __generic_unplug_device
19        0.0518  mark_page_accessed
19        0.0518  native_read_tsc
18        0.0491  cfq_may_queue
18        0.0491  vm_normal_page
17        0.0463  __alloc_pages
17        0.0463  copy_process
17        0.0463  drain_array
17        0.0463  try_to_wake_up
17        0.0463  vsnprintf
16        0.0436  generic_file_direct_IO
16        0.0436  vfs_write
15        0.0409  __copy_from_user_ll
15        0.0409  blk_backing_dev_unplug
15        0.0409  block_llseek
15        0.0409  cfq_service_tree_add
15        0.0409  generic_file_direct_write
15        0.0409  ip_append_data
15        0.0409  proc_sys_lookup_table_one
15        0.0409  update_wall_time
14        0.0382  __find_get_block
14        0.0382  cfq_remove_request
14        0.0382  dio_cleanup
13        0.0354  cache_alloc_refill
13        0.0354  generic_file_aio_write_nolock
13        0.0354  math_state_restore
13        0.0354  mempool_alloc
13        0.0354  preempt_schedule
12        0.0327  __pollwait
12        0.0327  __wake_up_bit
12        0.0327  do_lookup
12        0.0327  elv_dequeue_request
12        0.0327  file_update_time
12        0.0327  get_request
12        0.0327  load_elf_binary
12        0.0327  lock_timer_base
12        0.0327  permission
12        0.0327  restore_nocheck
11        0.0300  __do_softirq
11        0.0300  __scsi_get_command
11        0.0300  add_timer_randomness
11        0.0300  cfq_choose_req
11        0.0300  current_fs_time
11        0.0300  do_generic_mapping_read
11        0.0300  free_block
11        0.0300  generic_permission
11        0.0300  init_request_from_bio
10        0.0273  blk_plug_device
10        0.0273  cond_resched
10        0.0273  dnotify_parent
10        0.0273  do_sync_write
10        0.0273  scsi_get_cmd_from_req
10        0.0273  scsi_init_cmd_errh
10        0.0273  smp_apic_timer_interrupt
9         0.0245  __find_get_block_slow
9         0.0245  __mutex_unlock_slowpath
9         0.0245  _atomic_dec_and_lock
9         0.0245  dio_bio_submit
9         0.0245  elv_dispatch_sort
9         0.0245  internal_add_timer
9         0.0245  kref_put
9         0.0245  radix_tree_lookup
9         0.0245  rw_verify_area
9         0.0245  strnlen_user
9         0.0245  tick_sched_timer
8         0.0218  __end_that_request_first
8         0.0218  cfq_completed_request
8         0.0218  debug_mutex_add_waiter
8         0.0218  do_mmap_pgoff
8         0.0218  drive_stat_acct
8         0.0218  io_schedule
8         0.0218  kunmap_atomic
8         0.0218  scsi_alloc_sgtable
8         0.0218  scsi_end_request
8         0.0218  unix_poll
7         0.0191  __fput
7         0.0191  bio_init
7         0.0191  blkdev_get_blocks
7         0.0191  cfq_activate_request
7         0.0191  cfq_cic_rb_lookup
7         0.0191  cfq_dispatch_insert
7         0.0191  elv_rqhash_add
7         0.0191  get_task_mm
7         0.0191  get_unmapped_area
7         0.0191  handle_level_irq
7         0.0191  inode_init_once
7         0.0191  memcpy
7         0.0191  number
7         0.0191  page_remove_rmap
7         0.0191  pipe_poll
7         0.0191  rb_insert_color
7         0.0191  read_tsc
7         0.0191  rq_init
7         0.0191  scsi_add_timer
7         0.0191  scsi_init_io
7         0.0191  strncpy_from_user
7         0.0191  sys_write
6         0.0164  __blk_put_request
6         0.0164  blkdev_direct_IO
6         0.0164  block_write_full_page
6         0.0164  debug_mutex_unlock
6         0.0164  dio_zero_block
6         0.0164  do_path_lookup
6         0.0164  dput
6         0.0164  elv_completed_request
6         0.0164  getnstimeofday
6         0.0164  kfree
6         0.0164  kref_get
6         0.0164  link_path_walk
6         0.0164  open_namei
6         0.0164  run_posix_cpu_timers
6         0.0164  scsi_io_completion
6         0.0164  scsi_next_command
6         0.0164  sock_poll
6         0.0164  submit_bio
6         0.0164  sync_sb_inodes
6         0.0164  up_read
5         0.0136  __copy_user_intel
5         0.0136  __getblk
5         0.0136  __ip_route_output_key
5         0.0136  arch_get_unmapped_area_topdown
5         0.0136  bit_waitqueue
5         0.0136  blk_done_softirq
5         0.0136  blk_queue_bounce
5         0.0136  blk_remove_plug
5         0.0136  cfq_add_rq_rb
5         0.0136  copy_page_range
5         0.0136  copy_to_user
5         0.0136  do_sync_read
5         0.0136  error_code
5         0.0136  file_ra_state_init
5         0.0136  find_next_zero_bit
5         0.0136  generic_segment_checks
5         0.0136  generic_unplug_device
5         0.0136  inotify_inode_queue_event
5         0.0136  irq_exit
5         0.0136  kmap_atomic_prot
5         0.0136  max_block
5         0.0136  may_expand_vm
5         0.0136  neigh_lookup
5         0.0136  proc_lookup
5         0.0136  rb_next
5         0.0136  scheduler_tick
5         0.0136  scsi_decide_disposition
5         0.0136  scsi_device_unbusy
5         0.0136  scsi_finish_command
5         0.0136  sys_open
5         0.0136  sys_rt_sigprocmask
5         0.0136  tcp_transmit_skb
5         0.0136  vma_adjust
5         0.0136  zone_watermark_ok
4         0.0109  __rmqueue
4         0.0109  __xfrm_lookup
4         0.0109  account_system_time
4         0.0109  add_wait_queue
4         0.0109  cfq_queue_empty
4         0.0109  clocksource_get_next
4         0.0109  device_not_available
4         0.0109  dio_bio_end_io
4         0.0109  dio_new_bio
4         0.0109  do_filp_open
4         0.0109  do_gettimeofday
4         0.0109  down_read
4         0.0109  down_read_trylock
4         0.0109  dummy_inode_permission
4         0.0109  elv_queue_empty
4         0.0109  elv_rb_add
4         0.0109  find_extend_vma
4         0.0109  flush_old_exec
4         0.0109  flush_tlb_page
4         0.0109  fput
4         0.0109  generic_fillattr
4         0.0109  getname
4         0.0109  handle_IRQ_event
4         0.0109  kmap_atomic
4         0.0109  kmem_cache_zalloc
4         0.0109  ktime_get
4         0.0109  lru_cache_add_active
4         0.0109  mempool_alloc_slab
4         0.0109  native_flush_tlb_single
4         0.0109  need_resched
4         0.0109  remove_vma
4         0.0109  resume_userspace
4         0.0109  skb_copy_and_csum_bits
4         0.0109  sys_mprotect
4         0.0109  tcp_poll
4         0.0109  vm_stat_account
3         0.0082  I_BDEV
3         0.0082  __delay
3         0.0082  __dentry_open
3         0.0082  __elv_add_request
3         0.0082  __inc_zone_state
3         0.0082  __kmalloc
3         0.0082  __pagevec_lru_add_active
3         0.0082  __rcu_pending
3         0.0082  __scsi_put_command
3         0.0082  __wake_up_common
3         0.0082  account_user_time
3         0.0082  alloc_inode
3         0.0082  anon_vma_unlink
3         0.0082  apic_timer_interrupt
3         0.0082  bio_get_nr_vecs
3         0.0082  blk_complete_request
3         0.0082  cfq_rb_erase
3         0.0082  common_interrupt
3         0.0082  copy_from_user
3         0.0082  copy_strings
3         0.0082  cp_new_stat64
3         0.0082  deactivate_task
3         0.0082  dio_complete
3         0.0082  do_exit
3         0.0082  do_munmap
3         0.0082  do_timer
3         0.0082  do_writepages
3         0.0082  elv_rb_del
3         0.0082  end_that_request_last
3         0.0082  file_read_actor
3         0.0082  filemap_write_and_wait
3         0.0082  filp_close
3         0.0082  free_hot_cold_page
3         0.0082  generic_file_aio_read
3         0.0082  get_device
3         0.0082  get_empty_filp
3         0.0082  get_index
3         0.0082  get_nr_files
3         0.0082  icmp_push_reply
3         0.0082  inode_sub_bytes
3         0.0082  ip_push_pending_frames
3         0.0082  kobject_put
3         0.0082  ktime_get_ts
3         0.0082  locks_remove_flock
3         0.0082  lru_cache_add
3         0.0082  may_open
3         0.0082  n_tty_receive_buf
3         0.0082  neigh_update
3         0.0082  nf_ct_attach
3         0.0082  percpu_counter_mod
3         0.0082  pgd_alloc
3         0.0082  put_device
3         0.0082  radix_tree_gang_lookup_tag
3         0.0082  radix_tree_insert
3         0.0082  rcu_check_callbacks
3         0.0082  recalc_task_prio
3         0.0082  scsi_release_buffers
3         0.0082  scsi_run_queue
3         0.0082  setup_sigcontext
3         0.0082  show_stat
3         0.0082  sigprocmask
3         0.0082  sock_alloc_send_skb
3         0.0082  sys_close
3         0.0082  sys_gettimeofday
3         0.0082  task_rq_lock
3         0.0082  timespec_trunc
3         0.0082  touch_atime
3         0.0082  vfs_llseek
3         0.0082  vma_merge
3         0.0082  wake_up_inode
3         0.0082  xrlim_allow
2         0.0055  __alloc_skb
2         0.0055  __atomic_notifier_call_chain
2         0.0055  __bread
2         0.0055  __dec_zone_page_state
2         0.0055  __free_pages_ok
2         0.0055  __freed_request
2         0.0055  __ip_select_ident
2         0.0055  __qdisc_run
2         0.0055  __rcu_process_callbacks
2         0.0055  __tcp_select_window
2         0.0055  __vm_enough_memory
2         0.0055  __wake_up
2         0.0055  arch_setup_additional_pages
2         0.0055  bdev_read_only
2         0.0055  bio_free
2         0.0055  bio_fs_destructor
2         0.0055  blk_run_queue
2         0.0055  blk_start_queueing
2         0.0055  block_read_full_page
2         0.0055  call_rcu
2         0.0055  cfq_init_prio_data
2         0.0055  cfq_put_queue
2         0.0055  cfq_put_request
2         0.0055  cfq_resort_rr_list
2         0.0055  clear_bdi_congested
2         0.0055  clockevents_program_event
2         0.0055  copy_semundo
2         0.0055  credit_entropy_store
2         0.0055  current_io_context
2         0.0055  d_instantiate
2         0.0055  dcache_readdir
2         0.0055  dec_zone_page_state
2         0.0055  dev_ioctl
2         0.0055  disk_round_stats
2         0.0055  do_sigaction
2         0.0055  do_softirq
2         0.0055  do_sys_open
2         0.0055  do_wait
2         0.0055  dummy_file_alloc_security
2         0.0055  dummy_file_fcntl
2         0.0055  dummy_file_permission
2         0.0055  dummy_vm_enough_memory
2         0.0055  elv_may_queue
2         0.0055  elv_rqhash_del
2         0.0055  enqueue_hrtimer
2         0.0055  enqueue_task
2         0.0055  file_kill
2         0.0055  find_vma_prev
2         0.0055  free_pages_bulk
2         0.0055  free_pgtables
2         0.0055  freed_request
2         0.0055  generic_file_mmap
2         0.0055  get_request_wait
2         0.0055  half_md4_transform
2         0.0055  hrtimer_init
2         0.0055  icmp_send
2         0.0055  idle_cpu
2         0.0055  init_page_buffers
2         0.0055  init_timer
2         0.0055  inotify_dentry_parent_queue_event
2         0.0055  invalidate_inode_buffers
2         0.0055  ip_output
2         0.0055  ip_route_input
2         0.0055  kill_fasync
2         0.0055  ll_back_merge_fn
2         0.0055  locks_remove_posix
2         0.0055  mod_timer
2         0.0055  mutex_remove_waiter
2         0.0055  nameidata_to_filp
2         0.0055  note_interrupt
2         0.0055  notifier_call_chain
2         0.0055  ordered_bio_endio
2         0.0055  page_waitqueue
2         0.0055  path_lookup_open
2         0.0055  path_walk
2         0.0055  poll_initwait
2         0.0055  prio_tree_next
2         0.0055  proc_sys_lookup_table
2         0.0055  put_io_context
2         0.0055  put_pid
2         0.0055  queue_delayed_work
2         0.0055  raise_softirq
2         0.0055  rb_prev
2         0.0055  rcu_pending
2         0.0055  recalc_sigpending_tsk
2         0.0055  release_pages
2         0.0055  ret_from_exception
2         0.0055  ret_from_intr
2         0.0055  run_timer_softirq
2         0.0055  schedule_delayed_work
2         0.0055  schedule_timeout
2         0.0055  scsi_put_command
2         0.0055  seq_printf
2         0.0055  seq_read
2         0.0055  should_remove_suid
2         0.0055  sk_alloc
2         0.0055  sock_init_data
2         0.0055  split_vma
2         0.0055  submit_bh
2         0.0055  sys_brk
2         0.0055  sys_faccessat
2         0.0055  sys_fstat64
2         0.0055  sys_mmap2
2         0.0055  sys_rt_sigaction
2         0.0055  tcp_current_mss
2         0.0055  unlink_file_vma
2         0.0055  vma_link
2         0.0055  worker_thread
2         0.0055  writeback_inodes
1         0.0027  __activate_task
1         0.0027  __block_write_full_page
1         0.0027  __blocking_notifier_call_chain
1         0.0027  __brelse
1         0.0027  __capable
1         0.0027  __d_path
1         0.0027  __dec_zone_state
1         0.0027  __dequeue_signal
1         0.0027  __do_page_cache_readahead
1         0.0027  __first_cpu
1         0.0027  __follow_mount
1         0.0027  __get_user_4
1         0.0027  __iget
1         0.0027  __kfree_skb
1         0.0027  __lru_add_drain
1         0.0027  __mark_inode_dirty
1         0.0027  __mutex_init
1         0.0027  __page_set_anon_rmap
1         0.0027  __path_lookup_intent_open
1         0.0027  __put_task_struct
1         0.0027  __put_unused_fd
1         0.0027  __random32
1         0.0027  __rb_rotate_right
1         0.0027  __remove_hrtimer
1         0.0027  __scsi_done
1         0.0027  __set_page_dirty_nobuffers
1         0.0027  __udp4_lib_rcv
1         0.0027  __vma_link
1         0.0027  __wait_on_buffer
1         0.0027  __writepage
1         0.0027  activate_page
1         0.0027  add_disk_randomness
1         0.0027  add_to_page_cache
1         0.0027  alarm_setitimer
1         0.0027  alloc_pid
1         0.0027  anon_pipe_buf_release
1         0.0027  anon_vma_link
1         0.0027  anon_vma_prepare
1         0.0027  arch_pick_mmap_layout
1         0.0027  arch_unmap_area_topdown
1         0.0027  arp_hash
1         0.0027  arp_process
1         0.0027  atomic_notifier_call_chain
1         0.0027  bictcp_cong_avoid
1         0.0027  bio_alloc
1         0.0027  bio_hw_segments
1         0.0027  bio_phys_segments
1         0.0027  bio_put
1         0.0027  blockable_page_cache_readahead
1         0.0027  cached_lookup
1         0.0027  cfq_allow_merge
1         0.0027  check_userspace
1         0.0027  clear_inode
1         0.0027  clear_page_dirty_for_io
1         0.0027  clear_user
1         0.0027  compute_creds
1         0.0027  copy_files
1         0.0027  csum_partial_copy_generic
1         0.0027  d_alloc
1         0.0027  d_path
1         0.0027  debug_mutex_free_waiter
1         0.0027  debug_mutex_lock_common
1         0.0027  debug_mutex_set_owner
1         0.0027  dentry_iput
1         0.0027  dev_get_flags
1         0.0027  dev_queue_xmit
1         0.0027  do_IRQ
1         0.0027  do_fcntl
1         0.0027  do_mpage_readpage
1         0.0027  do_nanosleep
1         0.0027  do_select
1         0.0027  down_write
1         0.0027  dst_alloc
1         0.0027  dummy_bprm_check_security
1         0.0027  dummy_capable
1         0.0027  dummy_inode_getattr
1         0.0027  dummy_task_free_security
1         0.0027  dummy_task_wait
1         0.0027  effective_prio
1         0.0027  eligible_child
1         0.0027  elv_merge
1         0.0027  elv_set_request
1         0.0027  exit_aio
1         0.0027  exit_itimers
1         0.0027  exit_robust_list
1         0.0027  expand_files
1         0.0027  extract_buf
1         0.0027  fib_get_table
1         0.0027  fib_semantic_match
1         0.0027  fib_validate_source
1         0.0027  file_move
1         0.0027  file_permission
1         0.0027  find_busiest_group
1         0.0027  find_get_pages_tag
1         0.0027  find_or_create_page
1         0.0027  find_vma_prepare
1         0.0027  finish_wait
1         0.0027  flush_signal_handlers
1         0.0027  flush_tlb_mm
1         0.0027  free_page_and_swap_cache
1         0.0027  free_pgd_range
1         0.0027  free_pipe_info
1         0.0027  free_poll_entry
1         0.0027  generic_block_bmap
1         0.0027  generic_file_buffered_write
1         0.0027  get_futex_key
1         0.0027  get_io_context
1         0.0027  get_vmalloc_info
1         0.0027  get_write_access
1         0.0027  groups_search
1         0.0027  hrtimer_run_queues
1         0.0027  icmp_out_count
1         0.0027  iget_locked
1         0.0027  inc_zone_page_state
1         0.0027  inode_add_bytes
1         0.0027  ip_queue_xmit
1         0.0027  ip_rcv
1         0.0027  ip_route_output_flow
1         0.0027  ip_route_output_key
1         0.0027  irq_enter
1         0.0027  jiffies_64_to_clock_t
1         0.0027  kblockd_schedule_work
1         0.0027  kthread_should_stop
1         0.0027  local_bh_enable
1         0.0027  local_bh_enable_ip
1         0.0027  lock_hrtimer_base
1         0.0027  lookup_mnt
1         0.0027  mark_buffer_dirty
1         0.0027  mm_alloc
1         0.0027  mntput_no_expire
1         0.0027  mod_zone_page_state
1         0.0027  module_put
1         0.0027  mutex_unlock
1         0.0027  native_load_esp0
1         0.0027  native_read_cr0
1         0.0027  native_write_cr0
1         0.0027  netif_receive_skb
1         0.0027  notify_change
1         0.0027  page_add_file_rmap
1         0.0027  page_add_new_anon_rmap
1         0.0027  page_cache_readahead
1         0.0027  page_check_address
1         0.0027  pfifo_fast_enqueue
1         0.0027  pipe_wait
1         0.0027  pipe_write_fasync
1         0.0027  poll_freewait
1         0.0027  prepare_binprm
1         0.0027  prepare_to_copy
1         0.0027  prio_tree_insert
1         0.0027  proc_flush_task
1         0.0027  proc_sys_permission
1         0.0027  profile_tick
1         0.0027  pty_write
1         0.0027  put_files_struct
1         0.0027  put_pages_list
1         0.0027  queue_delayed_work_on
1         0.0027  quicklist_trim
1         0.0027  radix_tree_tag_clear
1         0.0027  radix_tree_tag_set
1         0.0027  release_open_intent
1         0.0027  release_vm86_irqs
1         0.0027  remove_suid
1         0.0027  remove_wait_queue
1         0.0027  resched_task
1         0.0027  rt_hash_code
1         0.0027  run_local_timers
1         0.0027  run_rebalance_domains
1         0.0027  run_workqueue
1         0.0027  rwsem_wake
1         0.0027  sched_exit
1         0.0027  scsi_free_sgtable
1         0.0027  scsi_softirq_done
1         0.0027  set_bh_page
1         0.0027  sha_transform
1         0.0027  show_map_internal
1         0.0027  single_release
1         0.0027  sk_common_release
1         0.0027  skb_clone
1         0.0027  skb_release_data
1         0.0027  sock_create
1         0.0027  sock_def_write_space
1         0.0027  softlockup_tick
1         0.0027  sync_buffer
1         0.0027  sync_dirty_buffer
1         0.0027  sys_clone
1         0.0027  sys_connect
1         0.0027  sys_fcntl64
1         0.0027  sys_kill
1         0.0027  sys_llseek
1         0.0027  sys_mkdirat
1         0.0027  sys_poll
1         0.0027  sys_select
1         0.0027  sys_socket
1         0.0027  sys_stat64
1         0.0027  sys_wait4
1         0.0027  syscall_exit
1         0.0027  sysctl_head_next
1         0.0027  tcp_ack
1         0.0027  tcp_rcv_established
1         0.0027  tcp_v4_send_check
1         0.0027  test_set_page_writeback
1         0.0027  tick_program_event
1         0.0027  tty_hung_up_p
1         0.0027  tty_write
1         0.0027  unlock_buffer
1         0.0027  update_process_times
1         0.0027  vfs_read
1         0.0027  vmstat_next
1         0.0027  wake_up_bit
+ date
Tue Aug  7 17:35:14 EEST 2007

--Boundary-00=_LbIuGjbp0PRf3Z1
Content-Type: text/plain;
  charset="utf-8";
  name="pata_vmstat_bad.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="pata_vmstat_bad.txt"

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 4  2      0 168488  10972  47144    0    0   218 23466  381  763 26 52 16  7
 4  2      0 168480  10972  47152    0    0     0 16000  252  516 19 81  0  0
 5  2      0 168480  10972  47152    0    0     0 16000  254  482 26 74  0  0
 5  2      0 168480  10972  47152    0    0     0 16000  253  485 16 84  0  0
 5  2      0 168480  10972  47152    0    0     0 16004  253  474 13 87  0  0
 5  2      0 168480  10972  47152    0    0     0 16000  252  470 22 78  0  0
 5  2      0 168480  10980  47152    0    0     0 15860  252  476 22 78  0  0
 5  2      0 168480  10980  47152    0    0     0 16000  250  486 13 87  0  0
 5  2      0 168480  10980  47152    0    0     0 16000  252  475 39 61  0  0
 5  2      0 168480  10980  47152    0    0     0 16000  256  464 45 55  0  0

--Boundary-00=_LbIuGjbp0PRf3Z1
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.txt"

Linux version 2.6.22-ARCH (root@Wohnung) (gcc version 4.2.1 20070704 (prerelease)) #1 SMP PREEMPT Thu Aug 2 18:27:37 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fff0000 (usable)
 BIOS-e820: 000000000fff0000 - 000000000fff3000 (ACPI NVS)
 BIOS-e820: 000000000fff3000 - 0000000010000000 (ACPI data)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
using polling idle threads.
0MB HIGHMEM available.
255MB LOWMEM available.
Entering add_active_range(0, 0, 65520) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    65520
  HighMem     65520 ->    65520
early_node_map[1] active PFN ranges
    0:        0 ->    65520
On node 0 totalpages: 65520
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 479 pages used for memmap
  Normal zone: 60945 pages, LIFO batch:15
  HighMem zone: 0 pages used for memmap
DMI 2.2 present.
ACPI: RSDP 000F6B30, 0014 (r0 GBT   )
ACPI: RSDT 0FFF3000, 0028 (r1 GBT    AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 0FFF3040, 0074 (r1 GBT    AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 0FFF30C0, 224C (r1 GBT    AWRDACPI     1000 MSFT  100000C)
ACPI: FACS 0FFF0000, 0040
ACPI: PM-Timer IO Port: 0x4008
Allocating PCI resources starting at 20000000 (gap: 10000000:efff0000)
Built 1 zonelists.  Total pages: 65009
Kernel command line: auto BOOT_IMAGE=arch ro root=/dev/sdb1 lapic nmi_watchdog=0 idle=poll
Local APIC disabled by BIOS -- reenabling.
Found and enabled local APIC!
mapped APIC to ffffd000 (fee00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 1024 (order: 10, 4096 bytes)
Detected 798.031 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 254928k/262080k available (2392k kernel code, 6700k reserved, 787k data, 304k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff82000 - 0xfffff000   ( 500 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xd0800000 - 0xff7fe000   ( 751 MB)
    lowmem  : 0xc0000000 - 0xcfff0000   ( 255 MB)
      .init : 0xc0421000 - 0xc046d000   ( 304 kB)
      .data : 0xc03561df - 0xc041b1bc   ( 787 kB)
      .text : 0xc0100000 - 0xc03561df   (2392 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1597.74 BogoMIPS (lpj=2661984)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0387fbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU serial number disabled.
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 11k freed
Early unpacking initramfs... done
ACPI: Core revision 20070126
ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
ACPI: setting ELCR to 0200 (from 1e00)
CPU0: Intel Pentium III (Coppermine) stepping 06
SMP motherboard not detected.
Brought up 1 CPUs
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb370, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
ACPI: RTC can wake from S4
pnp: 00:00: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:00: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: d8000000-dfffffff
  PREFETCH window: 20000000-200fffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 5, 131072 bytes)
TCP bind hash table entries: 8192 (order: 4, 98304 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 597k freed
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
apm: overridden by ACPI.
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: VIA PCI bridge detected. Disabling DAC.
Activating ISA DMA hang workarounds.
Boot video device is 0000:01:00.0
isapnp: Scanning for PnP cards...
Switched to high resolution mode on CPU 0
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
loop: module loaded
input: Macintosh mouse button emulation as /class/input/input0
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
Freeing unused kernel memory: 304k freed
libata version 2.21 loaded.
pata_via 0000:00:07.1: version 0.3.1
scsi0 : pata_via
scsi1 : pata_via
ata1: PATA max UDMA/66 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001e000 irq 14
ata2: PATA max UDMA/66 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001e008 irq 15
ata1.00: ATA-7: WDC WD2500JB-55REA0, 20.00K20, max UDMA/100
ata1.00: 488397168 sectors, multi 16: LBA48 
ata1.01: ata_hpa_resize 1: hpa sectors (33554433) is smaller than sectors (40132503)
ata1.01: ATA-5: MAXTOR 6L020J1, A93.0500, max UDMA/133
ata1.01: 40132503 sectors, multi 16: LBA 
ata1.00: configured for UDMA/66
ata1.01: configured for UDMA/66
ata2.00: ATA-7: WDC WD2500JB-55REA0, 20.00K20, max UDMA/100
ata2.00: 488397168 sectors, multi 16: LBA48 
ata2.00: configured for UDMA/66
scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500JB-55R 20.0 PQ: 0 ANSI: 5
scsi 0:0:1:0: Direct-Access     ATA      MAXTOR 6L020J1   A93. PQ: 0 ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      WDC WD2500JB-55R 20.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: unknown partition table
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:1:0: [sdb] 40132503 512-byte hardware sectors (20548 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:1:0: [sdb] 40132503 512-byte hardware sectors (20548 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2
sd 0:0:1:0: [sdb] Attached SCSI disk
sd 1:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
sd 1:0:0:0: [sdc] Write Protect is off
sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
sd 1:0:0:0: [sdc] Write Protect is off
sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: unknown partition table
sd 1:0:0:0: [sdc] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input3
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input4
ACPI: Sleep Button (CM) [SLPB]
ACPI: Processor [CPU0] (supports 2 throttling states)
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x0000e400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Linux agpgart interface v0.102 (c) Dave Jones
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 12
PCI: setting IRQ 12 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 12 (level, low) -> IRQ 12
skge 1.11 addr 0xe4000000 irq 12 chip Yukon rev 1
skge eth0: addr 00:0f:38:6a:9c:fe
sk98lin: driver has been replaced by the skge driver and is scheduled for removal
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
agpgart: Detected VIA Apollo Pro 133 chipset
agpgart: AGP aperture is 64M @ 0xe0000000
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
PPP generic driver version 2.4.2
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
input: PC Speaker as /class/input/input5
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
md: md0 stopped.
EXT3 FS on sdb1, internal journal
ReiserFS: sdb2: found reiserfs format "3.6" with standard journal
ReiserFS: sdb2: using ordered data mode
ReiserFS: sdb2: journal params: device sdb2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sdb2: checking transaction log (sdb2)
ReiserFS: sdb2: Using r5 hash to sort names
skge eth0: enabling interface
skge eth0: Link is up at 1000 Mbps, full duplex, flow control both

--Boundary-00=_LbIuGjbp0PRf3Z1--

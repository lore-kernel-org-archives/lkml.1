Return-Path: <linux-kernel-owner+w=401wt.eu-S965157AbXCAPBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965157AbXCAPBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965154AbXCAPBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:01:32 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:52959 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965157AbXCAPBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:01:31 -0500
Date: Thu, 1 Mar 2007 17:57:42 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070301145742.GC12684@2ka.mipt.ru>
References: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <200703011228.01144.dada1@cosmosbay.com> <20070301114731.GA20773@2ka.mipt.ru> <200703011412.51256.dada1@cosmosbay.com> <20070301144350.GA12684@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
In-Reply-To: <20070301144350.GA12684@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 17:58:26 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline

On Thu, Mar 01, 2007 at 05:43:50PM +0300, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> On Thu, Mar 01, 2007 at 02:12:50PM +0100, Eric Dumazet (dada1@cosmosbay.com) wrote:
> > On Thursday 01 March 2007 12:47, Evgeniy Polyakov wrote:
> > >
> > > Could you provide at least remote way to find it?
> > >
> > 
> > Sure :)
> > 
> > > I only found the same problem at
> > > http://lkml.org/lkml/2006/10/27/3
> > >
> > > but without any hits to solve the problem.
> > >
> > > I will try CVS oprofile, if it works I will provide details of course.
> > >
> > 
> > # cat CVS/Root
> > CVS/Root::pserver:anonymous@oprofile.cvs.sourceforge.net:/cvsroot/oprofile
> > 
> > # cvs diff >/tmp/oprofile.diff
> > 
> > Hope it helps
> 
> One of the hunks failed, since it was in CVS already.
> After setting up some mirrors, I've installed all bits needed for
> oprofile.
> Attached kevent and epoll profiles.
> 
> In that tests I got epoll perf about 4400 req/s, kevent was about 5300.

Attached kevent profile with 6100 req/sec.
They all look exactly the same for me - there no kevent or epoll
functions in profiles at all.

-- 
	Evgeniy Polyakov

--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=koi8-r
Content-Disposition: attachment; filename="profile.kevent"

CPU: AMD64 processors, speed 2210.08 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
103425   55.0868  cpu_idle
8214      4.3750  enter_idle
4712      2.5097  tcp_v4_rcv
3805      2.0266  IRQ0x51_interrupt
3154      1.6799  tcp_ack
2777      1.4791  kmem_cache_free
2286      1.2176  kfree
2155      1.1478  memset_c
1747      0.9305  csum_partial_copy_generic
1710      0.9108  ip_output
1620      0.8629  dev_queue_xmit
1551      0.8261  handle_IRQ_event
1391      0.7409  schedule
1373      0.7313  tcp_rcv_state_process
1337      0.7121  ip_rcv
1100      0.5859  ip_queue_xmit
965       0.5140  ip_route_input
939       0.5001  tcp_sendmsg
935       0.4980  __do_softirq
923       0.4916  ip_local_deliver
916       0.4879  csum_partial
905       0.4820  system_call
889       0.4735  tcp_transmit_skb
884       0.4708  tcp_v4_do_rcv
812       0.4325  netif_receive_skb
778       0.4144  __d_lookup
760       0.4048  __alloc_skb
747       0.3979  local_bh_enable
737       0.3925  __tcp_push_pending_frames
702       0.3739  kfree_skbmem
698       0.3718  pfifo_fast_enqueue
678       0.3611  kmem_cache_alloc
651       0.3467  fget
640       0.3409  pfifo_fast_dequeue
637       0.3393  net_rx_action
629       0.3350  __link_path_walk
602       0.3206  preempt_schedule
599       0.3190  __fput
594       0.3164  sock_wfree
589       0.3137  copy_user_generic_string
579       0.3084  ret_from_intr
559       0.2977  _atomic_dec_and_lock
552       0.2940  __kfree_skb
549       0.2924  skb_clone
514       0.2738  number
494       0.2631  rt_hash_code
473       0.2519  dput
466       0.2482  tcp_parse_options
446       0.2376  tcp_rcv_established
433       0.2306  tcp_recvmsg
431       0.2296  tcp_poll
417       0.2221  get_unused_fd
417       0.2221  sysret_check
377       0.2008  rb_erase
364       0.1939  __tcp_select_window
363       0.1933  lock_timer_base
347       0.1848  __mod_timer
329       0.1752  ip_append_data
326       0.1736  exit_idle
325       0.1731  ret_from_sys_call
317       0.1688  d_alloc
302       0.1609  do_path_lookup
295       0.1571  __ip_route_output_key
290       0.1545  eth_type_trans
285       0.1518  sys_close
283       0.1507  cache_alloc_refill
282       0.1502  mask_and_ack_8259A
275       0.1465  thread_return
267       0.1422  call_softirq
265       0.1411  tcp_rtt_estimator
260       0.1385  tcp_data_queue
258       0.1374  __dentry_open
258       0.1374  vsnprintf
255       0.1358  dentry_iput
255       0.1358  tcp_current_mss
250       0.1332  sk_stream_mem_schedule
239       0.1273  find_next_zero_bit
233       0.1241  cache_grow
233       0.1241  tcp_send_fin
222       0.1182  try_to_wake_up
219       0.1166  sock_recvmsg
216       0.1150  do_generic_mapping_read
211       0.1124  sys_fcntl
209       0.1113  get_empty_filp
207       0.1103  call_rcu
206       0.1097  strncpy_from_user
195       0.1039  sock_def_readable
190       0.1012  generic_drop_inode
190       0.1012  restore_args
184       0.0980  get_page_from_freelist
182       0.0969  sys_recvfrom
176       0.0937  do_lookup
174       0.0927  common_interrupt
171       0.0911  fget_light
167       0.0889  new_inode
167       0.0889  percpu_counter_mod
166       0.0884  link_path_walk
166       0.0884  skb_checksum
160       0.0852  fput
160       0.0852  release_sock
159       0.0847  memcpy_c
158       0.0842  memcmp
157       0.0836  __skb_checksum_complete
157       0.0836  tcp_init_tso_segs
148       0.0788  half_md4_transform
144       0.0767  tcp_v4_send_check
142       0.0756  del_timer
139       0.0740  current_fs_time
135       0.0719  update_send_head
129       0.0687  do_sys_open
126       0.0671  rb_insert_color
125       0.0666  bictcp_cong_avoid
124       0.0660  __put_unused_fd
123       0.0655  schedule_timeout
121       0.0644  clear_inode
118       0.0628  sock_close
116       0.0618  __do_page_cache_readahead
115       0.0613  alloc_inode
115       0.0613  lookup_mnt
114       0.0607  tcp_snd_test
113       0.0602  mod_timer
112       0.0597  generic_permission
109       0.0581  tcp_select_initial_window
101       0.0538  locks_remove_posix
98        0.0522  fd_install
97        0.0517  find_get_page
97        0.0517  sk_reset_timer
94        0.0501  try_to_del_timer_sync
93        0.0495  __follow_mount
92        0.0490  igrab
91        0.0485  page_cache_readahead
90        0.0479  dnotify_flush
90        0.0479  prepare_to_wait
90        0.0479  put_page
89        0.0474  expand_files
89        0.0474  getname
88        0.0469  inotify_dentry_parent_queue_event
88        0.0469  tcp_sync_mss
87        0.0463  __path_lookup_intent_open
86        0.0458  file_free_rcu
85        0.0453  may_open
85        0.0453  skb_copy_datagram_iovec
84        0.0447  IRQ0x20_interrupt
82        0.0437  tcp_cwnd_validate
81        0.0431  copy_page_c
81        0.0431  d_instantiate
81        0.0431  groups_search
80        0.0426  permission
79        0.0421  __handle_mm_fault
79        0.0421  file_kill
79        0.0421  get_task_mm
76        0.0405  rw_verify_area
74        0.0394  copy_to_user
73        0.0389  __wake_up_bit
72        0.0383  __wake_up
72        0.0383  cond_resched
72        0.0383  mntput_no_expire
69        0.0368  memmove
69        0.0368  sock_sendmsg
69        0.0368  tcp_setsockopt
68        0.0362  open_namei
68        0.0362  retint_kernel
67        0.0357  wake_up_inode
66        0.0352  inet_sendmsg
66        0.0352  tcp_event_data_recv
65        0.0346  generic_file_open
64        0.0341  touch_atime
63        0.0336  sock_release
63        0.0336  tcp_send_ack
62        0.0330  file_move
62        0.0330  filp_close
57        0.0304  mutex_unlock
55        0.0293  inet_sk_rebuild_header
55        0.0293  page_fault
55        0.0293  sockfd_lookup
54        0.0288  memset
54        0.0288  sk_stream_rfree
52        0.0277  __tcp_ack_snd_check
52        0.0277  inode_init_once
52        0.0277  sock_common_recvmsg
52        0.0277  tcp_check_space
51        0.0272  sys_open
49        0.0261  iret_label
47        0.0250  locks_remove_flock
46        0.0245  __rb_rotate_left
46        0.0245  tcp_v4_tw_remember_stamp
46        0.0245  unmap_vmas
45        0.0240  finish_wait
44        0.0234  inet_sock_destruct
44        0.0234  sprintf
43        0.0229  tcp_cong_avoid
42        0.0224  inotify_inode_queue_event
41        0.0218  __alloc_pages
41        0.0218  __lookup_mnt
41        0.0218  _spin_lock_bh
41        0.0218  tcp_init_cwnd
38        0.0202  clear_page_c
38        0.0202  tcp_unhash
37        0.0197  bit_waitqueue
37        0.0197  memcpy_toiovec
36        0.0192  iput
35        0.0186  do_filp_open
35        0.0186  init_timer
35        0.0186  sock_fasync
31        0.0165  __delay
31        0.0165  exit_intr
31        0.0165  vfs_permission
30        0.0160  sk_alloc
29        0.0154  copy_from_user
28        0.0149  free_hot_cold_page
27        0.0144  __put_user_8
27        0.0144  del_timer_sync
27        0.0144  hrtimer_run_queues
26        0.0138  init_once
26        0.0138  sk_stop_timer
25        0.0133  tcp_rcv_space_adjust
25        0.0133  tcp_v4_destroy_sock
23        0.0123  copy_page_range
23        0.0123  find_vma
22        0.0117  blockable_page_cache_readahead
22        0.0117  invalidate_inode_buffers
21        0.0112  do_page_fault
21        0.0112  do_wp_page
20        0.0107  in_group_p
20        0.0107  inet_getname
20        0.0107  mutex_lock
20        0.0107  tcp_slow_start
20        0.0107  zone_watermark_ok
18        0.0096  file_ra_state_init
17        0.0091  mark_page_accessed
16        0.0085  __find_get_block
15        0.0080  rt_run_flush
14        0.0075  __down_read
14        0.0075  __up_read
14        0.0075  apic_timer_interrupt
11        0.0059  destroy_inode
11        0.0059  flush_tlb_page
11        0.0059  vm_normal_page
10        0.0053  error_exit
10        0.0053  memcpy
9         0.0048  __get_user_4
9         0.0048  retint_restore_args
9         0.0048  retint_swapgs
8         0.0043  __rb_rotate_right
8         0.0043  run_local_timers
7         0.0037  error_sti
7         0.0037  inode_has_buffers
7         0.0037  nameidata_to_filp
7         0.0037  timespec_trunc
6         0.0032  __tcp_checksum_complete_user
6         0.0032  _spin_lock_irqsave
6         0.0032  _write_lock_bh
6         0.0032  filemap_nopage
6         0.0032  wake_up_bit
5         0.0027  __getblk
5         0.0027  __iget
5         0.0027  _read_lock_irqsave
5         0.0027  find_vma_prepare
5         0.0027  mmput
4         0.0021  __free_pages
4         0.0021  __mutex_init
4         0.0021  do_mmap_pgoff
4         0.0021  lru_cache_add_active
3         0.0016  __down_read_trylock
3         0.0016  __find_get_block_slow
3         0.0016  __make_request
3         0.0016  __mark_inode_dirty
3         0.0016  __remove_shared_vm_struct
3         0.0016  copy_strings
3         0.0016  do_notify_resume
3         0.0016  free_hot_page
3         0.0016  generic_file_aio_read
3         0.0016  generic_make_request
3         0.0016  load_elf_binary
3         0.0016  page_waitqueue
3         0.0016  prio_tree_insert
3         0.0016  prio_tree_replace
3         0.0016  rcu_start_batch
3         0.0016  unlock_page
3         0.0016  vma_link
3         0.0016  vma_merge
3         0.0016  zonelist_policy
2         0.0011  __block_prepare_write
2         0.0011  __pagevec_lru_add_active
2         0.0011  __put_user_4
2         0.0011  __vma_link_rb
2         0.0011  _read_lock_bh
2         0.0011  alloc_pages_current
2         0.0011  anon_vma_unlink
2         0.0011  copy_process
2         0.0011  d_lookup
2         0.0011  dentry_unhash
2         0.0011  do_mpage_readpage
2         0.0011  do_sigaction
2         0.0011  error_entry
2         0.0011  flush_old_exec
2         0.0011  kmem_flagcheck
2         0.0011  mempool_free
2         0.0011  page_add_file_rmap
2         0.0011  run_workqueue
2         0.0011  sched_balance_self
2         0.0011  set_personality_64bit
2         0.0011  strnlen_user
2         0.0011  sys_mprotect
2         0.0011  sys_rt_sigaction
2         0.0011  vfs_lstat_fd
2         0.0011  worker_thread
1        5.3e-04  __brelse
1        5.3e-04  __d_path
1        5.3e-04  __down_write_nested
1        5.3e-04  __lookup_hash
1        5.3e-04  __page_set_anon_rmap
1        5.3e-04  __strnlen_user
1        5.3e-04  __up_write
1        5.3e-04  __vm_enough_memory
1        5.3e-04  add_timer_randomness
1        5.3e-04  anon_vma_link
1        5.3e-04  bio_alloc_bioset
1        5.3e-04  blk_recount_segments
1        5.3e-04  can_vma_merge_after
1        5.3e-04  cap_bprm_apply_creds
1        5.3e-04  cond_resched_softirq
1        5.3e-04  copy_from_read_buf
1        5.3e-04  cpuset_fork
1        5.3e-04  cpuset_update_task_memory_state
1        5.3e-04  dnotify_parent
1        5.3e-04  do_exit
1        5.3e-04  do_munmap
1        5.3e-04  do_select
1        5.3e-04  do_wait
1        5.3e-04  end_bio_bh_io_sync
1        5.3e-04  exit_sem
1        5.3e-04  file_read_actor
1        5.3e-04  filldir64
1        5.3e-04  find_or_create_page
1        5.3e-04  find_vma_prev
1        5.3e-04  flush_thread
1        5.3e-04  free_pgd_range
1        5.3e-04  free_pgtables
1        5.3e-04  generic_fillattr
1        5.3e-04  get_unmapped_area
1        5.3e-04  inode_sub_bytes
1        5.3e-04  kthread_should_stop
1        5.3e-04  mm_init
1        5.3e-04  path_release
1        5.3e-04  pipe_release
1        5.3e-04  prio_tree_remove
1        5.3e-04  profile_munmap
1        5.3e-04  remove_wait_queue
1        5.3e-04  retint_check
1        5.3e-04  seq_puts
1        5.3e-04  strchr
1        5.3e-04  sys_brk
1        5.3e-04  sys_execve
1        5.3e-04  sys_mmap
1        5.3e-04  sys_munmap
1        5.3e-04  sys_read
1        5.3e-04  sys_rmdir
1        5.3e-04  sys_rt_sigprocmask
1        5.3e-04  truncate_complete_page
1        5.3e-04  tty_ldisc_deref
1        5.3e-04  tty_ldisc_try
1        5.3e-04  tty_termios_baud_rate
1        5.3e-04  tty_write
1        5.3e-04  udp_rcv
1        5.3e-04  vfs_rmdir
1        5.3e-04  vfs_stat_fd
1        5.3e-04  vfs_write
1        5.3e-04  vm_acct_memory
1        5.3e-04  vm_stat_account
1        5.3e-04  vma_adjust
1        5.3e-04  vma_prio_tree_remove
1        5.3e-04  wake_up_new_task

--vGgW1X5XWziG23Ko--

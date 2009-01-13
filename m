Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZAMVLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZAMVLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZAMVLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:11:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:34173 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbZAMVLG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:11:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,261,1231142400"; 
   d="scan'208";a="656843055"
From: "Ma, Chinang" <chinang.ma@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       Chris Mason <chris.mason@oracle.com>
Date: Tue, 13 Jan 2009 14:10:40 -0700
Subject: Mainline kernel OLTP performance update
Thread-Topic: Mainline kernel OLTP performance update
Thread-Index: Acl1w2OfuFLxEdRzT8eQTXKBx3R4Sg==
Message-ID: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is latest 2.6.29-rc1 kernel OLTP performance result. Compare to 2.6.24.2 the regression is around 3.5%.

Linux OLTP Performance summary
Kernel#            Speedup(x)   Intr/s  CtxSw/s us%  sys%   idle%  iowait%
2.6.24.2                1.000   21969   43425   76   24     0      0
2.6.27.2                0.973   30402   43523   74   25     0      1
2.6.29-rc1              0.965   30331   41970   74   26     0      0

Server configurations:
Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)

======oprofile CPU_CLK_UNHALTED for top 30 functions
Cycles% 2.6.24.2                   Cycles% 2.6.27.2
1.0500 qla24xx_start_scsi          1.2125 qla24xx_start_scsi
0.8089 schedule                    0.6962 kmem_cache_alloc
0.5864 kmem_cache_alloc            0.6209 qla24xx_intr_handler
0.4989 __blockdev_direct_IO        0.4895 copy_user_generic_string
0.4152 copy_user_generic_string    0.4591 __blockdev_direct_IO
0.3953 qla24xx_intr_handler        0.4409 __end_that_request_first
0.3596 scsi_request_fn             0.3729 __switch_to
0.3188 __switch_to                 0.3716 try_to_wake_up
0.2889 lock_timer_base             0.3531 lock_timer_base
0.2519 task_rq_lock                0.3393 scsi_request_fn
0.2474 aio_complete                0.3038 aio_complete
0.2460 scsi_alloc_sgtable          0.2989 memset_c
0.2445 generic_make_request        0.2633 qla2x00_process_completed_re
0.2263 qla2x00_process_completed_re0.2583 pick_next_highest_task_rt
0.2118 blk_queue_end_tag           0.2578 generic_make_request
0.2085 dio_bio_complete            0.2510 __list_add
0.2021 e1000_xmit_frame            0.2459 task_rq_lock
0.2006 __end_that_request_first    0.2322 kmem_cache_free
0.1954 generic_file_aio_read       0.2206 blk_queue_end_tag
0.1949 kfree                       0.2205 __mod_timer
0.1915 tcp_sendmsg                 0.2179 update_curr_rt
0.1901 try_to_wake_up              0.2164 sd_prep_fn
0.1895 kref_get                    0.2130 kref_get
0.1864 __mod_timer                 0.2075 dio_bio_complete
0.1863 thread_return               0.2066 push_rt_task
0.1854 math_state_restore          0.1974 qla24xx_msix_default
0.1775 __list_add                  0.1935 generic_file_aio_read
0.1721 memset_c                    0.1870 scsi_device_unbusy
0.1706 find_vma                    0.1861 tcp_sendmsg
0.1688 read_tsc                    0.1843 e1000_xmit_frame

======oprofile CPU_CLK_UNHALTED for top 30 functions
Cycles% 2.6.24.2                   Cycles% 2.6.29-rc1
1.0500 qla24xx_start_scsi          1.0691 qla24xx_intr_handler
0.8089 schedule                    0.7701 copy_user_generic_string
0.5864 kmem_cache_alloc            0.7339 qla24xx_wrt_req_reg
0.4989 __blockdev_direct_IO        0.6458 kmem_cache_alloc
0.4152 copy_user_generic_string    0.5794 qla24xx_start_scsi
0.3953 qla24xx_intr_handler        0.5505 unmap_vmas
0.3596 scsi_request_fn             0.4869 __blockdev_direct_IO
0.3188 __switch_to                 0.4493 try_to_wake_up
0.2889 lock_timer_base             0.4291 scsi_request_fn
0.2519 task_rq_lock                0.4118 clear_page_c
0.2474 aio_complete                0.4002 __switch_to
0.2460 scsi_alloc_sgtable          0.3381 ring_buffer_consume
0.2445 generic_make_request        0.3366 rb_get_reader_page
0.2263 qla2x00_process_completed_re0.3222 aio_complete
0.2118 blk_queue_end_tag           0.3135 memset_c
0.2085 dio_bio_complete            0.2875 __list_add
0.2021 e1000_xmit_frame            0.2673 task_rq_lock
0.2006 __end_that_request_first    0.2658 __end_that_request_first
0.1954 generic_file_aio_read       0.2615 qla2x00_process_completed_re
0.1949 kfree                       0.2615 lock_timer_base
0.1915 tcp_sendmsg                 0.2456 disk_map_sector_rcu
0.1901 try_to_wake_up              0.2427 tcp_sendmsg
0.1895 kref_get                    0.2413 e1000_xmit_frame
0.1864 __mod_timer                 0.2398 kmem_cache_free
0.1863 thread_return               0.2384 pick_next_highest_task_rt
0.1854 math_state_restore          0.2225 blk_queue_end_tag
0.1775 __list_add                  0.2211 sd_prep_fn
0.1721 memset_c                    0.2167 qla24xx_queuecommand
0.1706 find_vma                    0.2109 scsi_device_unbusy
0.1688 read_tsc                    0.2095 kref_get


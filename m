Return-Path: <linux-kernel-owner+w=401wt.eu-S1763256AbZD1RWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763256AbZD1RWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763183AbZD1RWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:22:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:1243 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763154AbZD1RWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:22:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,261,1239001200"; 
   d="scan'208";a="685700319"
From: "Styner, Douglas W" <douglas.w.styner@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       "Recalde, Luis F" <luis.f.recalde@intel.com>,
       "Nelson, Doug" <doug.nelson@intel.com>,
       "Cheng, Wu-sun" <wu-sun.cheng@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       "Shunmuganathan, Rajalakshmi" <rajalakshmi.shunmuganathan@intel.com>,
       "Garg, Anil K" <anil.k.garg@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>
Date: Tue, 28 Apr 2009 10:22:28 -0700
Subject: Mainline kernel OLTP performance update
Thread-Topic: Mainline kernel OLTP performance update
Thread-Index: AcnIJefwjZqJ44avQrSJwULtPtQzUQ==
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459F3DD5@azsmsx501.amr.corp.intel.com>
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

Summary: Measured the mainline kernel from kernel.org (2.6.29.2). 

The regression for 2.6.29.2 against the baseline, 2.6.24.2 is 2.07% (2.6.29.1 regression was 2.35%).  Oprofile reports 70.419% user, 29.5709% system. 2.6.29.1 -> 2.6.29.2 comparison is below. 

Linux OLTP Performance summary
Kernel#            Speedup(x)   Intr/s  CtxSw/s us%     sys%    idle%   iowait%
2.6.24.2                1.000   22106   43709   75      24      0       0
2.6.29.2                0.979   30509   43139   75      25      0       0

Server configurations:
Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)

======oprofile CPU_CLK_UNHALTED for top 30 functions
Cycles% 2.6.24.2                   Cycles% 2.6.29.2
74.8578 <database>                 67.7080 <database>
1.0500 qla24xx_start_scsi          0.9487 qla24xx_intr_handler
0.8089 schedule                    0.8117 schedule
0.5864 kmem_cache_alloc            0.6215 qla24xx_wrt_req_reg
0.4989 __blockdev_direct_IO        0.5439 kmem_cache_alloc
0.4357 __sigsetjmp                 0.4784 qla24xx_start_scsi
0.4152 copy_user_generic_string    0.4703 __blockdev_direct_IO
0.3953 qla24xx_intr_handler        0.4416 try_to_wake_up
0.3850 memcpy                      0.4253 __sigsetjmp
0.3596 scsi_request_fn             0.3803 scsi_request_fn
0.3188 __switch_to                 0.3701 __switch_to
0.2889 lock_timer_base             0.3619 copy_user_generic_string
0.2750 memmove                     0.3476 rb_get_reader_page
0.2519 task_rq_lock                0.3149 symbols)
0.2474 aio_complete                0.3006 aio_complete
0.2460 scsi_alloc_sgtable          0.2903 memset_c
0.2445 generic_make_request        0.2883 ring_buffer_consume
0.2263 qla2x00_process_completed_re0.2719 lock_timer_base
0.2118 blk_queue_end_tag           0.2699 __list_add
0.2085 dio_bio_complete            0.2474 blk_queue_end_tag
0.2021 e1000_xmit_frame            0.2453 memmove
0.2006 __end_that_request_first    0.2392 e1000_xmit_frame
0.1954 generic_file_aio_read       0.2290 ipc_lock
0.1949 kfree                       0.2290 task_rq_lock
0.1915 tcp_sendmsg                 0.2249 generic_make_request
0.1901 try_to_wake_up              0.2167 kref_get
0.1895 kref_get                    0.2147 tcp_sendmsg
0.1864 __mod_timer                 0.2045 qla2x00_process_completed_re
0.1863 thread_return               0.2045 pick_next_highest_task_rt

-- 2.6.29.1 vs. 2.6.29.2
Linux OLTP Performance summary
Kernel#            Speedup(x)   Intr/s  CtxSw/s us%     sys%    idle%   iowait%
2.6.29.1                1.000   30570   42818   74      25      0       0
2.6.29.2                1.003   30509   43139   75      25      0       0

Server configurations:
Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)

======oprofile CPU_CLK_UNHALTED for top 30 functions
Cycles% 2.6.29.1                   Cycles% 2.6.29.2
64.5424 <database>                 67.7080 <database>
1.1571 qla24xx_intr_handler        0.9487 qla24xx_intr_handler
0.9209 schedule                    0.8117 schedule
0.6533 kmem_cache_alloc            0.6215 qla24xx_wrt_req_reg
0.5456 qla24xx_wrt_req_reg         0.5439 kmem_cache_alloc
0.5247 try_to_wake_up              0.4784 qla24xx_start_scsi
0.4858 qla24xx_start_scsi          0.4703 __blockdev_direct_IO
0.4485 __sigsetjmp                 0.4416 try_to_wake_up
0.3976 __blockdev_direct_IO        0.4253 __sigsetjmp
0.3857 __switch_to                 0.3803 scsi_request_fn
0.3692 copy_user_generic_string    0.3701 __switch_to
0.3648 aio_complete                0.3619 copy_user_generic_string
0.3633 scsi_request_fn             0.3476 rb_get_reader_page
0.3259 rb_get_reader_page          0.3149 symbols)
0.3109 ring_buffer_consume         0.3006 aio_complete
0.3050 memset_c                    0.2903 memset_c
0.2900 pick_next_highest_task_rt   0.2883 ring_buffer_consume
0.2885 page_fault                  0.2719 lock_timer_base
0.2855 task_rq_lock                0.2699 __list_add
0.2691 mwait_idle                  0.2474 blk_queue_end_tag
0.2661 lock_timer_base             0.2453 memmove
0.2616 symbols)                    0.2392 e1000_xmit_frame
0.2616 __list_add                  0.2290 ipc_lock
0.2541 tcp_sendmsg                 0.2290 task_rq_lock
0.2302 blk_queue_end_tag           0.2249 generic_make_request
0.2242 e1000_xmit_frame            0.2167 kref_get
0.2198 scsi_softirq_done           0.2147 tcp_sendmsg
0.2183 qla2x00_process_completed_re0.2045 qla2x00_process_completed_re
0.2168 memmove                     0.2045 pick_next_highest_task_rt
0.2138 cpupri_set                  0.2024 __mod_timer
0.2078 qla24xx_process_response_que0.2004 kmem_cache_free

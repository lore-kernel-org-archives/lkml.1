Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZDWQuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZDWQuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756463AbZDWQuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:50:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:1541 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041AbZDWQuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:50:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,236,1239001200"; 
   d="scan'208";a="406196770"
From: "Styner, Douglas W" <douglas.w.styner@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 Apr 2009 09:49:57 -0700
Subject: Mainline kernel OLTP performance update
Thread-Topic: Mainline kernel OLTP performance update
Thread-Index: AcnEM4iJo5nISKgQTiy+YVInIUdN7A==
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345836A3A@azsmsx501.amr.corp.intel.com>
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


Summary: Measured the mainline kernel from kernel.org (2.6.30-rc2). 

The regression for 2.6.30-rc2 against the baseline, 2.6.24.2 is 1.95%.  Note the dip in cycles for database compared to us% in summary.  

Linux OLTP Performance summary
Kernel#            Speedup(x)   Intr/s  CtxSw/s us%     sys%    idle%   iowait%
2.6.24.2                1.000   22106   43709   75      24      0       0
2.6.30-rc2              0.981   30755   43072   75      25      0       0

Server configurations:
Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)


======oprofile 0.9.3 CPU_CLK_UNHALTED for top 30 functions
Cycles% 2.6.24.2                   Cycles% 2.6.30-rc2
74.8578 <database>                   67.6966 <database>
1.0500 qla24xx_start_scsi          1.1724 qla24xx_start_scsi
0.8089 schedule                    1.0578 qla24xx_intr_handler
0.5864 kmem_cache_alloc            0.8259 __schedule
0.4989 __blockdev_direct_IO        0.7451 kmem_cache_alloc
0.4357 __sigsetjmp                 0.4872 __blockdev_direct_IO
0.4152 copy_user_generic_string    0.4390 task_rq_lock
0.3953 qla24xx_intr_handler        0.4338 __sigsetjmp
0.3850 memcpy                      0.4195 __switch_to
0.3596 scsi_request_fn             0.3713 copy_user_generic_string
0.3188 __switch_to                 0.3608 __list_add
0.2889 lock_timer_base             0.3595 rb_get_reader_page
0.2750 memmove                     0.3309 ring_buffer_consume
0.2519 task_rq_lock                0.3152 scsi_request_fn
0.2474 aio_complete                0.3048 try_to_wake_up
0.2460 scsi_alloc_sgtable          0.2983 tcp_sendmsg
0.2445 generic_make_request        0.2931 lock_timer_base
0.2263 qla2x00_process_completed_re0.2840 aio_complete
0.2118 blk_queue_end_tag           0.2697 memset_c
0.2085 dio_bio_complete            0.2527 mod_timer
0.2021 e1000_xmit_frame            0.2462 qla2x00_process_completed_re
0.2006 __end_that_request_first    0.2449 memmove
0.1954 generic_file_aio_read       0.2358 blk_queue_end_tag
0.1949 kfree                       0.2241 generic_make_request
0.1915 tcp_sendmsg                 0.2215 scsi_device_unbusy
0.1901 try_to_wake_up              0.2162 mempool_free
0.1895 kref_get                    0.2097 e1000_xmit_frame
0.1864 __mod_timer                 0.2097 kmem_cache_free
0.1863 thread_return               0.2058 kfree
0.1854 math_state_restore          0.1993 sched_clock_cpu
 
Thanks,
Doug

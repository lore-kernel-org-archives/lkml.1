Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbZEDPwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbZEDPwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbZEDPwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:52:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:14822 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbZEDPwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:52:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,292,1239001200"; 
   d="scan'208";a="138963337"
From: "Styner, Douglas W" <douglas.w.styner@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Ma, Chinang" <chinang.ma@intel.com>,
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
Date: Mon, 4 May 2009 08:52:21 -0700
Subject: 
Thread-Index: AcnM0E+Nwe+14GGkR56q7IVjkGSrWw==
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345BCC181@azsmsx501.amr.corp.intel.com>
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

Summary: Measured the mainline kernel from kernel.org (2.6.30-rc4). 

The regression for 2.6.30-rc4 against the baseline, 2.6.24.2 is 2.15% (2.6.30-rc3 regression was 1.91%).  Oprofile reports 70.1204% user, 29.874% system. 

Linux OLTP Performance summary
Kernel#            Speedup(x)   Intr/s  CtxSw/s us%     sys%    idle%   iowait%
2.6.24.2                1.000   22106   43709   75      24      0       0
2.6.30-rc4              0.978   30581   43034   75      25      0       0

Server configurations:
Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)


======oprofile CPU_CLK_UNHALTED for top 30 functions
Cycles% 2.6.24.2                   Cycles% 2.6.30-rc4
74.8578 <database>                 67.8732 <database>
1.0500 qla24xx_start_scsi          1.1162 qla24xx_start_scsi
0.8089 schedule                    0.9888 qla24xx_intr_handler
0.5864 kmem_cache_alloc            0.8776 __schedule
0.4989 __blockdev_direct_IO        0.7401 kmem_cache_alloc
0.4357 __sigsetjmp                 0.4914 read_hpet
0.4152 copy_user_generic_string    0.4792 __sigsetjmp
0.3953 qla24xx_intr_handler        0.4368 __blockdev_direct_IO
0.3850 memcpy                      0.3822 task_rq_lock
0.3596 scsi_request_fn             0.3781 __switch_to
0.3188 __switch_to                 0.3620 __list_add
0.2889 lock_timer_base             0.3377 rb_get_reader_page
0.2750 memmove                     0.3336 copy_user_generic_string
0.2519 task_rq_lock                0.3195 try_to_wake_up
0.2474 aio_complete                0.3114 scsi_request_fn
0.2460 scsi_alloc_sgtable          0.3114 ring_buffer_consume
0.2445 generic_make_request        0.2932 aio_complete
0.2263 qla2x00_process_completed_re0.2730 lock_timer_base
0.2118 blk_queue_end_tag           0.2588 memset_c
0.2085 dio_bio_complete            0.2588 mod_timer
0.2021 e1000_xmit_frame            0.2447 generic_make_request
0.2006 __end_that_request_first    0.2426 qla2x00_process_completed_re
0.1954 generic_file_aio_read       0.2265 tcp_sendmsg
0.1949 kfree                       0.2184 memmove
0.1915 tcp_sendmsg                 0.2184 kfree
0.1901 try_to_wake_up              0.2103 scsi_device_unbusy
0.1895 kref_get                    0.2083 mempool_free
0.1864 __mod_timer                 0.1961 blk_queue_end_tag
0.1863 thread_return               0.1941 kmem_cache_free
0.1854 math_state_restore          0.1921 kref_get

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZD0WQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZD0WQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 18:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbZD0WPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 18:15:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:30639 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161AbZD0WPv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 18:15:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,256,1239001200"; 
   d="scan'208";a="510385150"
From: "Styner, Douglas W" <douglas.w.styner@intel.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "willy@linux.intel.com" <willy@linux.intel.com>
Date: Mon, 27 Apr 2009 15:15:27 -0700
Subject: RE: Discrepancies between Oprofile and vmstat II
Thread-Topic: Discrepancies between Oprofile and vmstat II
Thread-Index: AcnHaNl8mh9jTQZWQwiviW/3Ovq4EgAAB/pwAAbxdmA=
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459877BD@azsmsx501.amr.corp.intel.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345836A3A@azsmsx501.amr.corp.intel.com>
 <87ljpmk29b.fsf@basil.nowhere.org>
 <D7C42C27E6CB1E4D8CBDF2F81EA92A26034598724F@azsmsx501.amr.corp.intel.com>
 <20090427185305.GG27382@one.firstfloor.org> 
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


> I believe so, but will confirm.
>
> > opcontrol -e=CPU_CLK_UNHALTED:80000 -e=LLC_MISSES:6000
> > 
> > Using another profiling tool to confirm, we see 74.784% user, 25.174% > > kernel.
>
> Just verifying -- you also see it when you use a shorter period than 80000 > right?

Confirmed.  Changes in profile appear to be due to increased sampling by oprofile with lower value.

Linux OLTP Performance summary
Kernel#            Speedup(x)   Intr/s  CtxSw/s us%     sys%    idle%   iowait%
2.6.30-rc3              1.000   30593   43976   74      25      0       1
2.6.30-rc3              1.001   30534   43210   75      25      0       0

Server configurations:
Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)

======oprofile CPU_CLK_UNHALTED for top 30 functions
-e=CPU_CLK_UNHALTED:80000          -e=CPU_CLK_UNHALTED:20000
Cycles% 2.6.30-rc3                 Cycles% 2.6.30-rc3
68.5544 <database>                 65.6876 <database>
1.1859 qla24xx_start_scsi          1.1033 kstat_irqs_cpu
0.9436 qla24xx_intr_handler        1.0575 rb_get_reader_page
0.8307 __schedule                  1.0034 qla24xx_start_scsi
0.7194 kmem_cache_alloc            0.9305 qla24xx_intr_handler
0.5026 __blockdev_direct_IO        0.8410 ring_buffer_consume
0.4319 __sigsetjmp                 0.8160 __schedule
0.4244 scsi_request_fn             0.5683 kmem_cache_alloc
0.3853 rb_get_reader_page          0.4517 __sigsetjmp
0.3777 __switch_to                 0.4413 unmap_vmas
0.3552 __list_add                  0.3809 __blockdev_direct_IO
0.3552 task_rq_lock                0.3726 __switch_to
0.3371 try_to_wake_up              0.3310 __list_add
0.3221 ring_buffer_consume         0.3206 task_rq_lock
0.2844 aio_complete                0.3123 scsi_request_fn
0.2588 memmove                     0.2977 aio_complete
0.2588 mod_timer                   0.2914 try_to_wake_up
0.2558 generic_make_request        0.2644 page_fault
0.2543 tcp_sendmsg                 0.2436 kmem_cache_free
0.2528 copy_user_generic_string    0.2415 scsi_device_unbusy
0.2468 lock_timer_base             0.2352 copy_user_generic_string
0.2468 memset_c                    0.2311 memmove
0.2288 blk_queue_end_tag           0.2227 lock_timer_base
0.2257 qla2x00_process_completed_re0.2123 generic_make_request
0.2212 kref_get                    0.2103 kfree
0.2182 mempool_free                0.2040 find_vma
0.2137 sd_prep_fn                  0.2019 sd_prep_fn
0.2122 e1000_xmit_frame            0.2019 blk_queue_end_tag
0.2062 dequeue_rt_stack            0.2019 tcp_sendmsg
0.2047 scsi_device_unbusy          0.1998 qla2x00_process_completed_re

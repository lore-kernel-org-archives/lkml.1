Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196Ab0AYS0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0AYS0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662Ab0AYS0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:26:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:63926 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab0AYS0c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:26:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,339,1262592000"; 
   d="scan'208";a="767131272"
From: "Ma, Chinang" <chinang.ma@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       Chris Mason <chris.mason@oracle.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Garg, Anil K" <anil.k.garg@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>
Date: Mon, 25 Jan 2010 11:26:30 -0700
Subject: Mainline kernel OLTP performance update
Thread-Topic: Mainline kernel OLTP performance update
Thread-Index: Acqd6+phNz8e/kpaQ8SlBGUMCwwNEg==
Message-ID: <ABB50297B039B5448A55447953C8FE8C45F12B6F@azsmsx501.amr.corp.intel.com>
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

Here is an OLTP performance summary comparing 2.6.33-rc4 to Red Hat EL5.4 release. Both kernels were compiled using the same EL5.4 .config to minimize configuration differences.

Comparing to RHEL 5.4 baseline, 2.6.33-rc4 kernel has around 0.8% OLTP performance regression.

Linux OLTP Performance summary
Kernel#            Speedup(x)   Intr/s  CtxSw/s us%     sys%  idle%  iowait%
2.6.18-164.el5(RHEL5.4) 1.000   144080  181307  68      28      1       4
2.6.32.1                0.983   248305  174940  67      32      0       1
2.6.33-rc4              0.992   221354  180750  68      30      0       2

Hardware configuration
NHM-EP 2.93GHz 2 sockets/8 cores/16 threads
72GB memory  
4x LSI 3801SAS + 2x QLA2300, 192 SSDs + 28 spindles log

======oprofile CPU_CLK_UNHALTED for top 30 functions
Cycles% 2.6.18-164.el5             Cycles% 2.6.33-rc4
70.5642 <dbms>        		     69.4350 <dbms>
1.4696 mpt_interrupt               0.9540 mpt_interrupt
0.9001 kmem_cache_free             0.7649 scsi_request_fn
0.7807 schedule                    0.6990 __blockdev_direct_IO
0.7769 __blockdev_direct_IO        0.6729 schedule
0.6053 scsi_request_fn             0.6721 kmem_cache_alloc
0.5003 kmem_cache_alloc            0.6245 kmem_cache_free
0.4355 kmem_cache_zalloc           0.4556 pick_next_highest_task_rt
0.4090 list_del                    0.3538 __switch_to
0.3570 gup_huge_pmd                0.3397 memmove
0.3452 __switch_to                 0.3339 rb_get_reader_page
0.3399 kfree                       0.3318 try_to_wake_up
0.3371 task_rq_lock                0.3309 sd_prep_fn
0.3173 __sigsetjmp                 0.3219 list_del
0.3153 memmove                     0.3217 ring_buffer_consume
0.2869 lock_timer_base             0.3100 kfree
0.2851 generic_make_request        0.3085 __sigsetjmp
0.2613 scsi_get_command            0.3073 mptscsih_qcmd
0.2599 __generic_file_aio_read     0.2810 scsi_device_unbusy
0.2567 fget_light                  0.2727 generic_make_request
0.2434 mptscsih_io_done            0.2510 touch_atime
0.2413 touch_atime                 0.2480 generic_file_aio_read
0.2380 get_request                 0.2453 memset_c
0.2282 try_to_wake_up              0.2448 fget_light
0.2248 mptscsih_qcmd               0.2218 dequeue_rt_stack
0.2196 sd_init_command             0.2140 sys_io_submit
0.2035 device_not_available        0.2063 scsi_dispatch_cmd
0.2032 elv_queue_empty             0.2027 _setjmp
0.2007 __errno_location            0.1996 mptscsih_io_done
0.2006 math_state_restore          0.1973 gup_huge_pmd
0.2003 _setjmp                     0.1908 __list_add
0.1995 kref_get                    0.1880 submit_page_section
0.1979 mempool_alloc               0.1879 task_rq_lock
0.1965 scsi_prep_fn                0.1856 __errno_location








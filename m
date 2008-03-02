Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbYCBUZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbYCBUZa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYCBUZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:25:20 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:50716 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbYCBUZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:25:20 -0500
Date: Mon, 3 Mar 2008 01:55:06 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: discuss@LessWatts.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de,
       suresh.b.siddha@intel.com, Gautham R Shenoy <ego@in.ibm.com>,
       Chanda Sethia <chanda.sethia@in.ibm.com>
Subject: Re: Too many timer interrupts in NO_HZ
Message-ID: <20080302202506.GE10028@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	discuss@LessWatts.org,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
	venkatesh.pallipadi@intel.com, tglx@linutronix.de,
	suresh.b.siddha@intel.com, Gautham R Shenoy <ego@in.ibm.com>,
	Chanda Sethia <chanda.sethia@in.ibm.com>
References: <20080302194812.GD10028@dirshya.in.ibm.com> <20080302115709.30403490@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080302115709.30403490@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven <arjan@infradead.org> [2008-03-02 11:57:09]:
[sniped]
 
> 
> please show us powertop -d output; that way we can at least see sort of what
> is going on...

Here you go...

[root@XXXX sv]# powertop -d
PowerTOP 1.9    (C) 2007 Intel Corporation 

Collecting data for 15 seconds 
< Detailed C-state information is only available on Mobile CPUs (laptops) >
P-states (frequencies)
  2.40 Ghz     0.0%
  2.13 Ghz     0.0%
  1.87 Ghz     0.0%
  1.60 Ghz   100.0%
Wakeups-from-idle per second :  3.1     interval: 15.0s
no ACPI power usage estimate available
Top causes for wakeups:
  41.4% (  2.4)       <interrupt> : eth0 
  17.2% (  1.0)                ip : bnx2_open (bnx2_timer) 
   9.2% (  0.5)     <kernel core> : neigh_table_init_no_netlink (neigh_periodic_timer) 
   3.4% (  0.2)      <kernel IPI> : function call interrupts 
   3.4% (  0.2)              init : schedule_timeout (process_timeout) 
   3.4% (  0.2)            python : schedule_timeout (process_timeout) 
   3.4% (  0.2)     <kernel core> : __netdev_watchdog_up (dev_watchdog) 
   3.4% (  0.2)          sendmail : schedule_timeout (process_timeout) 
   3.4% (  0.2)     <kernel core> : page_writeback_init (wb_timer_fn) 
   2.3% (  0.1)       <interrupt> : aacraid 
   2.3% (  0.1)        rc.sysinit : start_this_handle (commit_timeout) 
   1.1% (  0.1)     <kernel core> : sk_reset_timer (tcp_delack_timer) 
   1.1% (  0.1)              sshd : sk_reset_timer (tcp_write_timer) 
   1.1% (  0.1)     <kernel core> : cache_register (delayed_work_timer_fn) 
   1.1% (  0.1)     <kernel core> : init_nonfatal_mce_checker (delayed_work_timer_fn) 
   1.1% (  0.1)             crond : do_nanosleep (hrtimer_wakeup) 
   1.1% (  0.1)     <kernel core> : neigh_add_timer (neigh_timer_handler) 

Suggestion: increase the VM dirty writeback time from 5.00 to 15 seconds with:
  echo 1500 > /proc/sys/vm/dirty_writeback_centisecs 
This wakes the disk up less frequenty for background VM activity

Suggestion: enable the noatime filesystem option by executing the following command:
   mount -o remount,noatime /          or by pressing the T key 
noatime disables persistent access time of file accesses, which causes lots of disk IO.

--Vaidy


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbZFYLUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbZFYLUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 07:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbZFYLUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 07:20:13 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42311 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751312AbZFYLUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 07:20:12 -0400
Date: Thu, 25 Jun 2009 06:20:13 -0500
From: Robin Holt <holt@sgi.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: What is swapper, and why it is causing so many wakeups?
Message-ID: <20090625112013.GB6878@sgi.com>
References: <4e5e476b0906240716q6638a0eevad790c439f5bdae6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0906240716q6638a0eevad790c439f5bdae6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Search include/linux/init_task.h for swapper.  It defines the task
that each processor executes when their runqueue is empty.  All you
are seeing is task-wise idle cpu that is servicing interrupts, etc and
completing work.

Good Luck,
Robin

On Wed, Jun 24, 2009 at 04:16:19PM +0200, Corrado Zoccolo wrote:
> Hi,
> my /proc/timer_stats shows a lot of activity due to 'swapper'.
> It is currently the main cause of wakeups on my netbook, an acer
> aspire one with Atom N270 cpu.
> The funny thing is that I have no swap partition, so I don't think
> swapper should have so much work to do.
> Is there a way to reduce its activity?
> 
> Timer Stats Version: v0.2
> Sample period: 298.025 s
>  23207,     0 swapper          hrtimer_start_range_ns (tick_sched_timer)
>  23806,     0 swapper          hrtimer_start_range_ns (tick_sched_timer)
>   651,  2615 lxterminal       hrtimer_start_range_ns (hrtimer_wakeup)
> 3275D,  1520 S50cpufreq       cpufreq_governor_dbs (delayed_work_timer_fn)
> 3373D,  1520 S50cpufreq       cpufreq_governor_dbs (delayed_work_timer_fn)
>    60,     0 swapper          page_writeback_init (wb_timer_fn)
>    60,  2582 xscreensaver     hrtimer_start_range_ns (hrtimer_wakeup)
>    21,  2139 X                hrtimer_start (it_real_fn)
>  1684,     0 swapper          hrtimer_start (tick_sched_timer)
>   279,  2139 X                queue_delayed_work (delayed_work_timer_fn)
>   297,  2585 lxpanel          hrtimer_start_range_ns (hrtimer_wakeup)
>   298,  2272 ifplugd          hrtimer_start_range_ns (hrtimer_wakeup)
>   149,  2156 ifplugd          hrtimer_start_range_ns (hrtimer_wakeup)
>    37,  2139 X                hrtimer_start_range_ns (hrtimer_wakeup)
>    30,  2221 ip               ath5k_start (ath5k_calibrate)
>  1040,     0 swapper          hrtimer_start (tick_sched_timer)
>    38,     1 swapper          neigh_table_init_no_netlink (neigh_periodic_timer)
>    50,  2156 ifplugd          __netdev_watchdog_up (dev_watchdog)
>    75,     1 swapper          neigh_table_init_no_netlink (neigh_periodic_timer)
>  284D,     1 swapper          schedule_delayed_work_on (delayed_work_timer_fn)
>  273D,     1 swapper          schedule_delayed_work_on (delayed_work_timer_fn)
>   149,  2545 net_applet       hrtimer_start_range_ns (hrtimer_wakeup)
>   149,     1 swapper          schedule_delayed_work_on (delayed_work_timer_fn)
>   149,     1 swapper          schedule_delayed_work_on (delayed_work_timer_fn)
>    60,     1 init             hrtimer_start_range_ns (hrtimer_wakeup)
>    24,  1321 btrfs-transacti  schedule_timeout (process_timeout)
>   137,     1 swapper          enqueue_task_rt (sched_rt_period_timer)
>    74,  2594 menu-cached      hrtimer_start_range_ns (hrtimer_wakeup)
>    48,  2269 wpa_supplicant   hrtimer_start_range_ns (hrtimer_wakeup)
>  1296,   484 phy0             queue_delayed_work (delayed_work_timer_fn)
>    30,     1 swapper          sta_info_start (sta_info_cleanup)
>     2,     0 swapper          neigh_add_timer (neigh_timer_handler)
>     3,  1276 mount            start_this_handle (commit_timeout)
>     1,  2998 iwgetid          do_acct_process (acct_timeout)
>     5,     1 swapper          queue_delayed_work (delayed_work_timer_fn)
>     2,   479 async/1          scsi_request_fn (blk_rq_timed_out_timer)
>     5,  1708 crond            hrtimer_start_range_ns (hrtimer_wakeup)
>    10,  1564 syslogd          hrtimer_start (it_real_fn)
>     9,  1756 hald             hrtimer_start_range_ns (hrtimer_wakeup)
>     1,     1 swapper          inet_init (inet_frag_secret_rebuild)
>     1,     1 swapper          flow_cache_init (flow_cache_new_hashrnd)
>     1,     1 swapper          ipv6_frag_init (inet_frag_secret_rebuild)
>     3,     0 swapper          addrconf_verify (addrconf_verify)
>     1,     1 swapper          queue_delayed_work (delayed_work_timer_fn)
>     1,  3017 modprobe         do_acct_process (acct_timeout)
>     1,   252 ksuspend_usbd    schedule_timeout (process_timeout)
>     1,   252 ksuspend_usbd    schedule_timeout (process_timeout)
>     1,   252 ksuspend_usbd    schedule_timeout (process_timeout)
>     8,   258 khubd            schedule_timeout (process_timeout)
>   110,     0 swapper          ehci_work (ehci_watchdog)
>     2,   258 khubd            schedule_timeout (process_timeout)
>     2,   258 khubd            schedule_timeout (process_timeout)
>     1,  3044 usb-stor-scan    schedule_timeout (process_timeout)
>     1,  3058 scsi_scan_2      scsi_request_fn (blk_rq_timed_out_timer)
>     4,  3043 usb-storage      schedule_timeout (process_timeout)
>     1,  3043 usb-storage      schedule_timeout (process_timeout)
>     1,  3043 usb-storage      schedule_timeout (process_timeout)
>     1,   258 khubd            schedule_timeout (process_timeout)
>     1,  3070 usb-stor-scan    schedule_timeout (process_timeout)
>     1,  3086 async/0          schedule_timeout (process_timeout)
>     1,  3084 scsi_scan_3      scsi_request_fn (blk_rq_timed_out_timer)
>     1,  3042 pam_console_app  do_acct_process (acct_timeout)
>     2,     1 swapper          inet_initpeers (peer_check_expire)
>     1,  3144 iwgetid          do_acct_process (acct_timeout)
>     1,  1312 btrfs-endio-met  schedule_timeout (process_timeout)
>     1,  3151 modprobe         do_acct_process (acct_timeout)
>     9,  2139 X                vt_ioctl (kd_nosound)
>     1,  3176 modprobe         do_acct_process (acct_timeout)
>    10,  3235 iwlist           hrtimer_start_range_ns (hrtimer_wakeup)
>     8,  2615 lxterminal       hrtimer_start_range_ns (hrtimer_wakeup)
>     1,  3003 less             do_acct_process (acct_timeout)
> 61320 total events, 205.994 events/sec
> 
> -- 
> __________________________________________________________________________
> 
> dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
> PhD - Department of Computer Science - University of Pisa, Italy
> --------------------------------------------------------------------------



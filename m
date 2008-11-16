Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbYKPV17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbYKPV17 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 16:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYKPV0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 16:26:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43672 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbYKPV0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 16:26:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Palfrader <peter@palfrader.org>
Subject: Re: broken ownership of /proc/sys/ files on 2.6.27
Date: Sun, 16 Nov 2008 22:31:00 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20081116205922.GI28958@anguilla.noreply.org>
In-Reply-To: <20081116205922.GI28958@anguilla.noreply.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811162231.01358.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 16 of November 2008, Peter Palfrader wrote:
> Hi,
> 
> on several (probably all) of my systems running a 2.6.27 kernel on at
> least i386, amd64, ia64, sparc proc/sys does have files not owned by
> root:

Well, my system running 2.6.27.6 doesn't have this problem.
 
> weasel@villa:~$ find /proc/sys ! -uid 0 -ls
> 2273612    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:55 /proc/sys/kernel/sched_rt_runtime_us
> 2273615    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:55 /proc/sys/kernel/core_uses_pid
> 2273616    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:55 /proc/sys/kernel/core_pattern
> 2273621    0 -rw-r--r--   1 nobody   munin           0 Nov 16 20:55 /proc/sys/kernel/hotplug
> 2273622    0 -rw-r--r--   1 nobody   munin           0 Nov 16 20:55 /proc/sys/kernel/acct
> 2273623    0 -rw-r--r--   1 nobody   munin           0 Nov 16 20:55 /proc/sys/kernel/sysrq
> 2273624    0 -rw-------   1 nobody   munin           0 Nov 16 20:55 /proc/sys/kernel/cad_pid
> 2273625    0 -rw-r--r--   1 nobody   munin           0 Nov 16 20:55 /proc/sys/kernel/threads-max
> 2217102    0 -r--r--r--   1 joy      Debian          0 Nov 16 19:57 /proc/sys/kernel/random/entropy_avail
> 2273626    0 -rw-r--r--   1 nobody   munin           0 Nov 16 20:55 /proc/sys/kernel/overflowuid
> 2273627    0 -rw-r--r--   1 nobody   munin           0 Nov 16 20:55 /proc/sys/kernel/overflowgid
> 2273628    0 -rw-r--r--   1 nobody   munin           0 Nov 16 20:55 /proc/sys/kernel/panic_on_oops
> 2273635    0 -r--r--r--   1 nobody   nogroup         0 Nov 16 20:55 /proc/sys/kernel/bootloader_type
> 2273636    0 -rw-r--r--   1 weasel   Debian          0 Nov 16 20:55 /proc/sys/kernel/kstack_depth_to_print
> 2273638    0 -rw-r--r--   1 weasel   Debian          0 Nov 16 20:55 /proc/sys/kernel/randomize_va_space
> 2273598    0 dr-xr-xr-x   0 weasel   Debian          0 Nov 16 20:55 /proc/sys/vm
> 2209118    0 -r--r--r--   1 joy      Debian          0 Nov 16 19:50 /proc/sys/fs/file-nr
> weasel@villa:~$ uname -a
> Linux villa 2.6.27.6-dsa-dl380-oldxeon #2 SMP Fri Nov 14 01:40:49 CET 2008 i686 GNU/Linux
> 
> 
> weasel@ravel:~$ find /proc/sys ! -uid 0 -ls
> 3917380    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:57 /proc/sys/kernel/sched_latency_ns
> 3917381    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:57 /proc/sys/kernel/sched_wakeup_granularity_ns
> 3917382    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:57 /proc/sys/kernel/sched_shares_ratelimit
> 3917383    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:57 /proc/sys/kernel/sched_child_runs_first
> 3917384    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:57 /proc/sys/kernel/sched_features
> 3917387    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:57 /proc/sys/kernel/sched_rt_period_us
> 3917388    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:57 /proc/sys/kernel/sched_rt_runtime_us
> 3917389    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:57 /proc/sys/kernel/sched_compat_yield
> 3847910    0 -rw-r--r--   1 joeyh    Debian          0 Nov 16 20:11 /proc/sys/kernel/pid_max
> 3917373    0 dr-xr-xr-x   0 weasel   Debian          0 Nov 16 20:57 /proc/sys/fs
> 3917376    0 dr-xr-xr-x   0 nagios   nagios          0 Nov 16 20:57 /proc/sys/net
> weasel@ravel:~$ uname -a
> Linux ravel 2.6.27.6-dsa-amd64-opteron #2 SMP Fri Nov 14 01:32:43 CET 2008 x86_64 GNU/Linux
> 
> weasel@caballero:~$ find /proc/sys ! -uid 0 -ls
>   6950    0 -rw-r--r--   1 weasel   Debian          0 Nov 16 20:48 /proc/sys/kernel/sched_min_granularity_ns
>   6951    0 -rw-r--r--   1 weasel   Debian          0 Nov 16 20:48 /proc/sys/kernel/sched_latency_ns
>   6955    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:48 /proc/sys/kernel/sched_features
>   6959    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:48 /proc/sys/kernel/sched_rt_runtime_us
>   2173    0 -r--r--r--   1 nobody   munin           0 Nov 16 20:35 /proc/sys/kernel/random/entropy_avail
>   6971    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:48 /proc/sys/kernel/overflowuid
>   6972    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:48 /proc/sys/kernel/overflowgid
>   6973    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:48 /proc/sys/kernel/panic_on_oops
>   6974    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:48 /proc/sys/kernel/printk_ratelimit
>   6975    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:48 /proc/sys/kernel/printk_ratelimit_burst
>   6978    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:48 /proc/sys/kernel/softlockup_panic
>   6979    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:48 /proc/sys/kernel/softlockup_thresh
>   6980    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:48 /proc/sys/kernel/hung_task_check_count
>   1618    0 -r--r--r--   1 nobody   munin           0 Nov 16 20:35 /proc/sys/fs/file-nr
> weasel@caballero:~$ uname -a
> Linux caballero 2.6.27.2-dsa-mckinley #1 SMP Sun Oct 19 12:14:46 UTC 2008 ia64 GNU/Linux
> 
> weasel@spontini:~$ find /proc/sys ! -uid 0 -ls
>  41263    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:58 /proc/sys/kernel/panic
>  41264    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:58 /proc/sys/kernel/core_uses_pid
>  41267    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:58 /proc/sys/kernel/real-root-dev
>  41271    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:58 /proc/sys/kernel/scons-poweroff
>  41272    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:58 /proc/sys/kernel/ctrl-alt-del
>  41273    0 -r--r--r--   1 nagios   nagios          0 Nov 16 20:58 /proc/sys/kernel/sg-big-buff
>  41280    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:58 /proc/sys/kernel/printk
>  41291    0 -r--r--r--   1 nagios   nagios          0 Nov 16 20:58 /proc/sys/kernel/version
>  41292    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:58 /proc/sys/kernel/hostname
>  41293    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:58 /proc/sys/kernel/domainname
>  41294    0 -rw-r--r--   1 nagios   nagios          0 Nov 16 20:58 /proc/sys/kernel/shmmax
>   5299    0 -r--r--r--   1 nobody   munin           0 Nov 16 19:22 /proc/sys/fs/file-nr
>  41259    0 dr-xr-xr-x   0 weasel   Debian          0 Nov 16 20:58 /proc/sys/debug
> weasel@spontini:~$ uname -a
> Linux spontini 2.6.27.2-dsa-usii #2 SMP Sun Oct 19 16:34:26 CEST 2008 sparc64 GNU/Linux
> 
> 
> That's probably not how it should be, right?

No, it's not.

Thanks,
Rafael

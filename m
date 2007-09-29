Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbXI2LL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbXI2LL2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 07:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbXI2LLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 07:11:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:11339 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbXI2LLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 07:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=piDYDvAxmLauVRszPfFJcTVbv0CenQ7PSxlnKYhAN6GAREoP8VMmdar+MFgceWUQh7HyRdpshpQUuzyHHQhJ5JZHE0SGMAQzc9cTm75x7mM2dwTihcOQuWWvkeuHYgDerrzGnGGwp9lumhCe/7pDhzF+IYbAybNpUEhI6+A/cNs=
Message-ID: <e85b9d30709290411u4f48d716o3260bab7d71261ff@mail.gmail.com>
Date: Sat, 29 Sep 2007 13:11:14 +0200
From: Matthew <jackdachef@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v22, for v2.6.23-rc8, v2.6.22.8, v2.6.21.7, v2.6.20.20
Cc: mingo@chiara.csoma.elte.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo & everbody on the list,

first of all: many thanks for developing this great scheduler (also:
kudos to Con Kolivas for having developed SD & CK-patchset)

(this is my second mail to this list and I hope I'm doing everything right)

I'm doing some backup during work right now: rsyncing my home
partition (nearly 180 GB) to another harddrive locally &
since I'm running compiz-fusion, openoffice and gnome, therefore am in
some real "working environment" I thought:
give Ingo's new scheduler a test-ride during heavy load ;)

first some impressions:
cpu load balancing looks great again (pretty symmetrical loading on
both cores - it looks pretty similar to 19.1 if not better if I recall
right),
v20 wasn't that "good-looking" ;) (with gnome-system-monitor)

both cpus have a continous load of ~  70% right now so I'll be
starting up 9 instances of glxgears, below are some output & details
of my system
(cpu frequency switching is disabled since it doesn't work right now
with the current bios version)

short summary: unfortunately after starting glxgears everything
stuttered a lot, don't know if it's expactable during that heavy load
- just wanted to let you know; after having closed each instance of
glxgears, everything was fine again ...

cat /proc/sched_debug
Sched Debug Version: v0.05-v22, 2.6.23-rc8-cfs-v22 #1
now at 3890590.670323 msecs
  .sysctl_sched_latency                    : 20.000000
  .sysctl_sched_nr_latency                 : 0.000020
  .sysctl_sched_wakeup_granularity         : 2.000000
  .sysctl_sched_batch_wakeup_granularity   : 25.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 3

cpu#0, 2404.249 MHz
  .nr_running                    : 4
  .load                          : 4096
  .nr_switches                   : 7648325
  .nr_load_updates               : 2103023
  .nr_uninterruptible            : 58007
  .jiffies                       : 3590591
  .next_balance                  : 3.590615
  .curr->pid                     : 4942
  .clock                         : 2102704.853484
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 3939505.166968
  .clock_warps                   : 0
  .clock_overflows               : 1525057
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 0.999846
  .cpu_load[0]                   : 3072
  .cpu_load[1]                   : 3148
  .cpu_load[2]                   : 3448
  .cpu_load[3]                   : 3598
  .cpu_load[4]                   : 3612

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 705800.821444
  .min_vruntime                  : 705800.818396
  .max_vruntime                  : 705800.821444
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 2
  .load                          : 3072
  .nr_spread_over                : 0

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 114142.324354
  .min_vruntime                  : 705800.818396
  .max_vruntime                  : 114142.460206
  .spread                        : 0.135852
  .spread0                       : 0.000000
  .nr_running                    : 3
  .load                          : 3072
  .nr_spread_over                : 0

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 705800.818396
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 705800.818396
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 705800.818396
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
               X  4043    114142.410694   1413252   120
0               0               0.000000               0.000000
       0.000000
        glxgears  4938    114142.460206    251121   120
0               0               0.000000               0.000000
       0.000000
        glxgears  4939    114142.324354    418180   120
0               0               0.000000               0.000000
       0.000000
R            cat  4942    373113.531317        11   120
0               0               0.000000               0.000000
       0.000000

cpu#1, 2404.249 MHz
  .nr_running                    : 4
  .load                          : 4096
  .nr_switches                   : 9227086
  .nr_load_updates               : 2014314
  .nr_uninterruptible            : 4294909290
  .jiffies                       : 3590591
  .next_balance                  : 3.590623
  .curr->pid                     : 4932
  .clock                         : 2014009.406851
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 3939505.462830
  .clock_warps                   : 0
  .clock_overflows               : 1490105
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 0.999845
  .cpu_load[0]                   : 4096
  .cpu_load[1]                   : 4096
  .cpu_load[2]                   : 4102
  .cpu_load[3]                   : 4148
  .cpu_load[4]                   : 4210

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 582740.765855
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -123060.052541
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 127569.587650
  .min_vruntime                  : 582740.768735
  .max_vruntime                  : 127573.669809
  .spread                        : 4.082159
  .spread0                       : -123060.049661
  .nr_running                    : 4
  .load                          : 4096
  .nr_spread_over                : 0

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 582740.771821
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -123060.046575
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 582740.774902
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -123060.043494
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 582740.777696
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -123060.040700
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
        glxgears  4932    127569.592544    440228   120
0               0               0.000000               0.000000
       0.000000
        glxgears  4933    127569.593334    555188   120
0               0               0.000000               0.000000
       0.000000
        glxgears  4934    127569.593355    713648   120
0               0               0.000000               0.000000
       0.000000
        glxgears  4935    127573.669809    419649   120
0               0               0.000000               0.000000
       0.000000


cat /proc/meminfo
MemTotal:      2074264 kB
MemFree:         52624 kB
Buffers:         38704 kB
Cached:        1468288 kB
SwapCached:          0 kB
Active:         565544 kB
Inactive:      1378496 kB
HighTotal:     1179136 kB
HighFree:         1976 kB
LowTotal:       895128 kB
LowFree:         50648 kB
SwapTotal:     2698912 kB
SwapFree:      2698516 kB
Dirty:           38508 kB
Writeback:           0 kB
AnonPages:      437052 kB
Mapped:         116140 kB
Slab:            33768 kB
SReclaimable:    16652 kB
SUnreclaim:      17116 kB
PageTables:       3704 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   3736044 kB
Committed_AS:   817652 kB
VmallocTotal:   118776 kB
VmallocUsed:     56224 kB
VmallocChunk:    60916 kB

hardware: NVIDIA 7600GT, P5W DH Deluxe, Core2 Duo 6600 "Conroe", 2048
MB Ram (DDR2-800, 6400)
GNU/Gentoo hardened x86 2.6 profile, gcc-4.2.1 hardened; glibc 2.6.1
kernel: 2.6.23-rc8-git3 (+ cfs-devel v22)

9 instances of glxgears, 1 instance of openoffice, 1 instance of
screen, 1 window firefox, gnome-2.20 running
compiz-fusion running (via nvidia GLX_EXT_texture_from_pixmap) ,
nvidia-drivers-100.14.19-r10

/dev/dm-1 reiserfs    213G  175G   38G  83% /home
/dev/dm-2 reiserfs    213G   56G  157G  27% /bak    <== rsync -aur
--delete /home/ /bak/
(1st hdd on Intel ICH7R, 2nd hdd on Jmicron; both S-ATA2, ahci)

readahead-cache for both harddrives: 4 MB (via blockdev --setra), 16
MB internal harddisk cache (seagate 7200.10)
I/O-scheduler: deadline scheduler; partition-type: reiserfs v3.6;
mount-options: noatime,nodiratime,data=writeback,commit=120
SLAB: slub

result: most times only 2-3 of the glxgears-windows were running, the
rest was stuttering / halting (no motion)
mouse movement was pretty discountinous, keyboard input was also delayed

Please keep up the good work !

Cheers
Mat

Return-Path: <linux-kernel-owner+w=401wt.eu-S1030608AbXD1BJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030608AbXD1BJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030649AbXD1BJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:09:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:37865 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030608AbXD1BJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:09:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jO0tY86jHaBnkPI6rPQ1cc527gT6C5hpG9Uopi4DgViUjqaHidfrg5hCP/83QxBNHq+NqK9qXzcwFtIBVaXeq3c5EjgETHxHaMINrZuk9RFkquOPA2N6JX3HHV5MKcgmKSJDKXvXVUxaZWbUMAwquVBl3i6VtNWzVe0HcTAb1tI=
Message-ID: <8cd998d50704271809g52a47c2bv392378d01ca2f34b@mail.gmail.com>
Date: Sat, 28 Apr 2007 11:09:00 +1000
From: "Con Kolivas" <kernel@kolivas.org>
To: hechacker1 <hechacker1@gmail.com>
Subject: Re: "REPORT: sd-0.46 vs cfs-v6 vs mainline 2.6.21-rc7 Beryl + Video + Audio"
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "ck list" <ck@vds.kolivas.org>
In-Reply-To: <6700d24e0704262101v132bec29nf9fd6c93fe8748a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6700d24e0704262101v132bec29nf9fd6c93fe8748a@mail.gmail.com>
X-Google-Sender-Auth: 44673fc815ca32f0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/04/07, hechacker1 <hechacker1@gmail.com> wrote:
> "REPORT: sd-0.46 vs cfs-v6 vs mainline 2.6.21-rc7 Beryl + Video + Audio"
>
> Hardware:
> Dell Inspiron 700m laptop
> 1.7GHz Pentium M (Dothan 2M cache)
> 2GB RAM
> 1000Hz
> Gentoo Linux
> dyn-tick
> 700m # cat /sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate
> 10000 (microseconds, 10ms)
> 855gm integrated video/chipset
> xf86-video-i810 (intel 1.7.4) DRI enabled
> xorg-server-1.2.0-r3
> beryl-core 0.3.0-svn
> MPlayer dev-SVN-rUNKNOWN-4.1.2 - x11
> Gnome totem 2.16.5 - x11-gstreamer
> reiser4 w/cryptcompress
>
> Screenshot:
> http://ordorica.org/misc/beryl.png
>
> muine playing mp3's off mounted windows share
>
> Tests run under 16 bit color which provides a constant 75 fps
> on one cube side (fps forced limited). Drops to ~45-50 fps during
> animation/rotate/scale (depending on complexity of rendering)
> Vsync off. 75Hz refresh 1280x800.
>
> totem running fullscreen playing 700MB divx "An Inconvenient Truth.avi" on
> one side of cube/desktop
> gmplayer running fullscreen on another cube side (same file).
>
> The given observations/numbers are when I move the cube with my mouse
> and view two faces at one time (see screenshot). One face is playing the
> totem video, the other containing my terminals.
>
>
> Some numbers I've seen other people throw around:
> I don't know their relevance.
>
> cfs-v6:
> 700m kernel # cat sched_granularity_ns
> 5000000
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  5  0      0 221480    300 1394612    0    0   181     0 6068 5317 69  6 25  0
>  4  0      0 220880    300 1395268    0    0   176     0 6147 5579 68  6 27  0
>  1  0      0 220340    300 1395768    0    0   167     0 6052 5393 70  6 24  0
>  6  0      0 219920    300 1396204    0    0   103     0 5830 5211 73  6 21  0
>
> top - 18:31:17 up  7:45,  5 users,  load average: 5.18, 4.73, 4.28
> Tasks:  98 total,   4 running,  94 sleeping,   0 stopped,   0 zombie
> Cpu(s): 91.6%us,  6.4%sy,  0.0%ni,  0.3%id,  0.0%wa,  1.3%hi,  0.3%si,  0.0%st
> Mem:   2057700k total,  1845952k used,   211748k free,      300k buffers
> Swap:   987988k total,        0k used,   987988k free,  1404040k cached
>
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 18046 hechacke  20   0  189m  83m  20m S 38.7  4.2  12:04.64 totem
> 18059 hechacke  20   0 51280  30m  18m R 25.8  1.5   9:47.36 gmplayer
> 12117 root      20   0  275m  54m  18m R 20.2  2.7  15:18.38 Xorg
> 22730 hechacke  20   0  119m  35m  18m R  5.3  1.7   0:12.68 mono
> 12350 hechacke  20   0 63820 6776 4328 S  3.6  0.3   2:20.36 beryl
> 16465 hechacke  20   0 43960  15m  10m S  2.3  0.8   0:07.14 gnome-terminal
> 12200 hechacke  20   0  5308 4016 1740 S  0.3  0.2   0:05.45 gconfd-2
> 12215 hechacke  20   0 38704 8956 7588 S  0.3  0.4   0:08.90 xfce4-clipman-p
>
> Observation:
> Music plays perfectly.
> Audio of video's play perfectly.
> New processes take forever to start. Firefox (already cached in ram) takes
> about 5 seconds to start; even right after closing it.
> Browsing the web is slow.
> Already open applications are responsive.
> Behavior of video:
> video's both moving forward. totem is updating about every half second.
> mplayer updates about every 3 seconds.
>
> -----------------------------------------------------------------------------
>
> cfs-v6:
> 700m kernel # cat sched_granularity_ns
> 2000000
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  5  0      0  99604     44 1519364    0    0     0     0 3903 5575 91  5  5  0
>  3  0      0  99512     44 1519364    0    0     0     0 5990 6783 72  5 23  0
>  3  0      0 100412     44 1519364    0    0     0     0 6858 7261 67  5 28  0
>  1  0      0 100412     44 1519364    0    0     0     0 7426 7634 62  4 34  0
>  4  0      0 100288     44 1519364    0    0     0     0 7039 7442 60  6 34  0
>
> top - 19:05:09 up  8:18,  5 users,  load average: 3.62, 4.16, 4.28
> Tasks:  98 total,   4 running,  94 sleeping,   0 stopped,   0 zombie
> Cpu(s): 69.8%us,  5.0%sy,  0.0%ni, 24.5%id,  0.0%wa,  0.7%hi,  0.0%si,  0.0%st
> Mem:   2057700k total,  2009396k used,    48304k free,      300k buffers
> Swap:   987988k total,        0k used,   987988k free,  1555428k cached
>
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 18059 hechacke  20   0 51332  30m  18m R 30.8  1.5  18:48.17 gmplayer
> 18046 hechacke  20   0  189m  83m  20m S 20.9  4.2  23:25.49 totem
> 12117 root      20   0  276m  57m  18m S  9.6  2.8  20:59.01 Xorg
> 22730 hechacke  20   0  129m  36m  18m R  8.6  1.8   1:28.59 mono
> 22930 hechacke  20   0 65480 8392 4320 S  4.0  0.4   0:53.38 beryl
> 12213 hechacke  20   0 34472 7680 6484 S  0.7  0.4   1:16.41 xfce4-battery-p
>
> Observation:
> Music plays perfectly.
> Audio of video's play perfectly.
> New processes take forever to start.
> Browsing the web is slow.
> Already open applications are responsive.
> Behavior of video:
> video's both moving forward. totem is updating about every 1/3 second.
> mplayer updates about every 1 seconds.
> Rotating the cube is smoother than with 5000000, beryl seems more responsive.
> After much trial and error i've decided on 2000000 as my optimum granularity
> for beryl and to provide the most screen updates.
> Larger or smaller values only make it worse.
>
> -----------------------------------------------------------------------------
> sd-0.46:
> 700m kernel # cat rr_interval
> 6
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  3  0      0 903128    524 859056    0    0   171     0 2138 13766 90  9  0  0
>  5  0      0 902468    524 859696    0    0   171     0 2800 12937 83  9  8  0
>  1  0      0 901292    524 860616    0    0   301     0 2670 11063 76  7 17  0
>  1  0      0 900692    524 861396    0    0   216   137 3576 10129 66  7 21  6
>  1  0      0 899644    524 862036    0    0   171     0 3011 11523 78  7 15  0
>
> top - 19:56:21 up 7 min,  5 users,  load average: 4.56, 2.79, 1.23
> Tasks: 102 total,   4 running,  98 sleeping,   0 stopped,   0 zombie
> Cpu(s): 64.7%us,  5.3%sy,  0.0%ni, 28.7%id,  0.0%wa,  1.0%hi,  0.3%si,  0.0%st
> Mem:   2057716k total,  1161536k used,   896180k free,      524k buffers
> Swap:   987988k total,        0k used,   987988k free,   865512k cached
>
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 10132 hechacke   5   0 51264  30m  18m R 29.1  1.5   0:58.74 gmplayer
> 10106 hechacke   1   0  193m  84m  18m S 17.2  4.2   1:13.03 totem
>  9817 hechacke   1   0  128m  36m  18m S 11.3  1.8   0:50.52 mono
>  9443 root       1   0  272m  47m  13m R  7.9  2.4   0:41.76 Xorg
>  9975 hechacke   1   0 63452 6332 4320 S  3.0  0.3   0:07.98 beryl
>  9823 hechacke   1   0 36136 8764 7240 S  0.3  0.4   0:00.60 xfce4-mixer-plu
>  9825 hechacke   1   0 42764  13m  10m S  0.3  0.7   0:01.64 gnome-terminal
>
> Observation:
> Music plays perfectly.
> Audio of video's play perfectly.
> New processes take forever to start. (about same as cfs)
> Browsing the web faster than cfs (a lot less lag time between clicks and render)
> Already open applications are responsive.
> Behavior of video:
> video's both moving forward. totem is updating about every 1/3 second.
> mplayer updates about every 1/2 second.
> Videos are visibly smoother compared to cfs. cube rotation is smoother
> than cfs in the sense that the fps is constant (albeit slower) than cfs.
> cfs would slow down on the video sides of the cube, while speeding up
> on the empty side.
>
> ------------------------------------------------------------------------------
> sd-0.46:
> 700m kernel # cat rr_interval
> 2
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  5  0      0 918052    536 832840    0    0   411     0 2387 15242 89 11  0  0
>  4  1      0 915600    536 834908    0    0   388     0 2283 15428 90 10  0  0
>  1  0      0 908768    536 841356    0    0  1085     0 2683 15916 84 12  0  4
>  3  0      0 923068    536 826100    0    0   537     0 2100 15797 80 12  6  1
>  3  0      0 924444    536 826484    0    0    85     0 3509 14786 69  7 24  0
>
> top - 20:10:18 up 21 min,  5 users,  load average: 3.73, 3.92, 3.00
> Tasks: 101 total,   4 running,  97 sleeping,   0 stopped,   0 zombie
> Cpu(s): 70.1%us, 11.1%sy, 12.8%ni,  0.0%id,  5.0%wa,  1.0%hi,  0.0%si,  0.0%st
> Mem:   2057716k total,  1126964k used,   930752k free,      536k buffers
> Swap:   987988k total,        0k used,   987988k free,   820380k cached
>
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 10106 hechacke   1   0  192m  85m  20m S 23.6  4.3   5:50.89 totem
> 10132 hechacke  11   0 51264  30m  18m R 23.3  1.5   4:31.65 gmplayer
> 10064 hechacke  32  12 64028  21m 8696 S 17.9  1.1   0:11.08 beagled-helper
>  9443 root       1   0  272m  49m  15m S 13.3  2.5   3:11.59 Xorg
>  9817 hechacke   1   0  128m  36m  18m S 12.6  1.8   2:16.98 mono
>  9975 hechacke   1   0 63452 6396 4316 S  2.3  0.3   0:30.94 beryl
>
> Observation:
> Music plays perfectly.
> Audio of video's play perfectly.
> New processes take forever to start.
> Browsing the web faster than cfs (better than rr_interval 6)
> Already open applications are responsive.
> Behavior of video:
> video's both moving forward. totem is doing ~4fps.
> mplayer is doing 15-25 fps.
> Obviously my choice for the smoothest experience.
>
> -----------------------------------------------------------------------------
> mainline 2.6.21-rc7
>
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  7  0      0 1012944    536 776276    0    0   256     0 3553 6388 68  7 26  0
>  1  0      0 1011956    536 777300    0    0   299     0 3315 5998 72  6 21  0
>  6  0      0 1015684    536 777108    0    0   299     0 3359 5776 82  8 10  0
>  5  0      0 1014132    536 778096    0    0   213     0 3444 6762 70  7 23  0
>  1  0      0 1020072    536 774912    0    0   384   155 3127 7239 68  9 18  5
>  5  0      0 1014224    536 777260    0    0   299     0 3480 8209 65  9 25  0
>
> top - 20:37:37 up 5 min,  4 users,  load average: 4.19, 2.54, 1.05
> Tasks:  98 total,   2 running,  96 sleeping,   0 stopped,   0 zombie
> Cpu(s): 89.5%us,  5.4%sy,  0.0%ni,  3.4%id,  0.0%wa,  1.7%hi,  0.0%si,  0.0%st
> Mem:   2057716k total,  1040344k used,  1017372k free,      536k buffers
> Swap:   987988k total,        0k used,   987988k free,   788480k cached
>
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  7912 hechacke  15   0  171m  64m  18m S 42.9  3.2   1:07.15 totem
>  7918 hechacke  15   0 51208  29m  18m S 25.0  1.5   0:55.90 gmplayer
>  5850 root      16   0  268m  45m  13m R 22.0  2.3   0:36.28 Xorg
>  7836 hechacke  15   0 63316 6288 4320 S  3.0  0.3   0:07.18 beryl
>  7945 hechacke  15   0 42184  13m  10m S  1.7  0.7   0:00.89 gnome-terminal
>
> Observation:
> Music plays perfectly.
> Audio of video's play perfectly.
> New processes don't start?!? Firefox took 30-60 seconds to appears after
> cached. Muine took 15 seconds.
> Browsing the web is faster than cfs or sd. Almost no lag.
> Already open applications are responsive.
> Behavior of video:
> video's both moving forward. totem is doing ~2fps.
> mplayer is doing ~3 fps.
> Both videos are playing, and they don't slow down with load. Unfairness
> is in play here.
>
> -----------------------------------------------------------------------------
>
> Overall:
> SD-0.46 is my new choice for scheduler. When not under load everything
> run's better or similarly to cfs or mainline. Under load however it
> shows the most responsiveness.
>
> Occasionally I had complete mouse freezes with cfs when the system was
> busy. But rarely.
>
> Under SD i haven't seen anything get starved.
>
> mainline surprisingly works better than i expected, but beryl suffers
> and responsiveness suffers under load.

Thank you very much for your feedback. I also liked greatly how you
tested everything with X at nice 0 as well.

--
-ck

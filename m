Return-Path: <linux-kernel-owner+w=401wt.eu-S1161602AbXD3AVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161602AbXD3AVl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 20:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161611AbXD3AVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 20:21:41 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:58996 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161602AbXD3AVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 20:21:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dLhGpCZ6RN7E5nHOw68ODimAEqGv8+0W4cfiv5vCMZys1OJYZtx0MOZYp1WChmmKeA3VTufVVS3Z7lupxphp11bL3XP+ZR3dk+C8xfHn+wWNQju7JyXkgGnXR9khdOtVo23WtVyYgsCJAjgVVY8t0fgWcyH+NiuTEC/F2dx5VKw=
Message-ID: <6700d24e0704291721r75518f31x87f4ce212b4c9634@mail.gmail.com>
Date: Sun, 29 Apr 2007 17:21:37 -0700
From: hechacker1 <hechacker1@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: "REPORT: sd-0.46 vs cfs-v6 vs mainline 2.6.21-rc7 Beryl + Video + Audio"
In-Reply-To: <6700d24e0704280139i4bf9e9b8i67919b6d22acacb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6700d24e0704280139i4bf9e9b8i67919b6d22acacb0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Another update:

This is the same testing but for cfs-v7.

Summary:
1. context switch rate is much higher than for cfs-v6 for the same
sched_granularity_ns 200000
2. Video playback suffered. FPS is much lower.
3. Trying different values of sched-granularity_ns didn't help
(neither did the default).
4. Firefox is actually much more responsive when the system isn't
under stress, better than any other scheduler so far.
5. Generally the system completes operations faster with cfs-v7, but
beryl FPS suffers.
6. I've monitored idle context switch rates at ~2000, and some spikes
at ~35000 (emerge -s firefox) for example.

------------------------------------------------------------------------------
cfs-v7
700m kernel # cat sched_granularity_ns
2000000

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 2  0      0 888828    536 882672    0    0   100     0 3793 13889 67  6 27  0
 5  0      0 888708    536 882768    0    0    96     0 3435 13969 69  7 24  0
 1  0      0 888468    536 882992    0    0    96     0 3704 13645 64  8 28  0
 0  0      0 888284    536 883064    0    0    72     0 4378 13557 53  7 40  0
 6  0      0 888224    536 883132    0    0    68     0 3909 13700 60  9 31  0
 0  0      0 888164    536 883216    0    0    84     0 3726 13670 65  6 29  0

top - 16:53:54 up 10 min,  5 users,  load average: 3.33, 2.78, 1.43
Tasks: 102 total,   2 running, 100 sleeping,   0 stopped,   0 zombie
Cpu(s): 57.9%us,  5.7%sy,  0.0%ni, 35.4%id,  0.0%wa,  0.7%hi,  0.3%si,  0.0%st
Mem:   2057700k total,  1172136k used,   885564k free,      536k buffers
Swap:   987988k total,        0k used,   987988k free,   885976k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
11701 hechacke  20   0 51268  30m  18m R 18.9  1.5   1:46.30 gmplayer
11620 hechacke  20   0  127m  35m  18m S 15.3  1.7   0:40.64 mono
11695 hechacke  20   0  180m  67m  20m S 14.3  3.4   1:51.19 totem
 9421 root      20   0  272m  49m  15m S 11.3  2.4   0:59.29 Xorg
11442 hechacke  20   0 63304 6232 4316 S  3.7  0.3   0:11.86 beryl

Observation:
Music plays perfectly.
Audio of video's play perfectly.
New Processes start in about the same amount of time as cfs-v6
Already open applications are responsive.
Behavior of video:
video's both moving forward. totem is doing ~0.9fps.
mplayer is doing ~1 fps.
Video's are slideshows in cfs-v7 vs cfs-v6 which was had more fps.

Going back to sd-0.46 since so far it provides the most constant FPS
under load (and thus the most responsiveness/smoothness).

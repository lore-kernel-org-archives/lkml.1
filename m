Return-Path: <linux-kernel-owner+w=401wt.eu-S1161612AbXD1Ikq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161612AbXD1Ikq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 04:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161620AbXD1Iju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 04:39:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:31890 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161612AbXD1Ijs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 04:39:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=kVnSsmBdk7AqWOj7ttkKqG3g/BN6PTspL0cZb/6k6dtt7V5DAn8s7iMuzFxb1AAFgIWWeiS8HH3zUNWXREuGjMlTaDteWV2dWrWyNVOpSg99PQQ/tl9SDDDqOfczq0Y8CosbQVI1cMQavDngipITUKMgBQMjTtxtJCsJhQ67rgI=
Message-ID: <6700d24e0704280139i4bf9e9b8i67919b6d22acacb0@mail.gmail.com>
Date: Sat, 28 Apr 2007 01:39:46 -0700
From: hechacker1 <hechacker1@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: "REPORT: sd-0.46 vs cfs-v6 vs mainline 2.6.21-rc7 Beryl + Video + Audio"
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>so SD context-switched twice as much and saturated the CPU fully, while
>under cfs-v6 there was 34% idle time left. That double context-switch
>rate and higher CPU utilization could easily result in you experiencing
>a 'smoother' desktop (and smoother video playback) on SD.
>
>could you try to maximize the preemption ratio on CFS by using a
>sched_granularity_ns of 0? Does that result in a higher context-switch
>rate and in better CPU utilization? Thanks,
>
>     Ingo

Thanks for pointing out the idle cpu usage. I hadn't noticed it before.

I re-ran the tests with sched_granularity_ns 0, but fyi, I did try
that, as well as many
values around 5000000, 1-10ms, and some huge values too just to see
how the scheduler reacted. The reason why I settled on 2000000 was
because of trial and error and determining that value produced the
best fps.

Large values than 5000000 clearly caused the FPS to drop. Too small
values did the same.

FYI, when the desktop is sitting on only one cube side, i.e. normal
desktop. The idle usage for cfs and SD goes down to nearly 0.

But when the cube is in between faces in free form mode (the mouse
controls the cube in 3D space) the idle cpu usage goes up, for both
cfs, SD, and mainline.

I looked carefully at the idle usage values for cfs-v6 and sd-0.46, and
cfs hovers around ~35% idle cpu, sd hovers around ~3-30%, usually ~15% overall.

So perhaps my video card is fill rate limited during this stress
test... but... mplayer and totem are visibly refreshing faster with
sd-0.46, almost watchable and smooth during certain points in the
video. (clearly the fps for SD is much higher)

The new results:
-----------------------------------------------------------------------------------------------

cfs-v6
700m kernel # cat sched_granularity_ns
0
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 8  0      0 894204    536 892388    0    0    45     0 4192 12237 57  7 35  0
 0  0      0 893904    536 892708    0    0    88   139 4298 12511 55  7 29  9
 4  0      0 893620    536 892964    0    0    85     0 4217 12189 55  5 39  0
 0  0      0 890272    536 893220    0    0    85     0 4285 12366 55  7 38  0
 4  0      0 881008    536 893348    0    0    43     0 4020 12610 59  6 35  0
 5  0      0 882608    536 893848    0    0    43     0 3053 12045 81  6 13  0

top - 01:03:47 up 10 min,  7 users,  load average: 3.52, 2.81, 1.41
Tasks: 103 total,   1 running, 102 sleeping,   0 stopped,   0 zombie
Cpu(s): 55.0%us,  6.3%sy,  0.0%ni, 37.3%id,  0.7%wa,  0.7%hi,  0.0%si,  0.0%st
Mem:   2057700k total,  1171508k used,   886192k free,      536k buffers
Swap:   987988k total,        0k used,   987988k free,   899704k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
20227 hechacke  20   0 51408  30m  18m S 22.9  1.5   1:44.30 gmplayer
20237 hechacke  20   0  128m  37m  18m S 14.0  1.9   0:28.88 mono
19931 root      20   0  271m  48m  15m S 11.0  2.4   0:52.76 Xorg
20214 hechacke  20   0  156m  51m  19m S 10.0  2.6   1:47.80 totem
20164 hechacke  20   0 63456 6332 4316 S  3.0  0.3   0:12.06 beryl

Observation:
Music plays perfectly.
Audio of video's play perfectly.
Processes start faster than sched_granularity_ns 2000000
Browsing the web faster than 2000000, but still not as fast as
mainline (better than cfs)
Already open applications are responsive.
Behavior of video:
video's both moving forward. totem is doing ~0.5fps.
mplayer is doing ~2 fps.
Visibly slower refreshing vs sched_granularity_ns 2000000

For some reason top doesn't seem reliable considering the system was
stressed at the time?

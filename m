Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbXHEQFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbXHEQFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 12:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbXHEQFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 12:05:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:40262 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757283AbXHEQFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 12:05:30 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1/zbVYex3PzCacL0o+/4ygAlQWuwMEztWHldn6Yfo
	sMHhne0LmAuDIB
From: Dimitrios Apostolou <jimis@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
Date: Sun, 5 Aug 2007 19:03:12 +0300
User-Agent: KMail/1.9.7
References: <200708031903.10063.jimis@gmx.net>
In-Reply-To: <200708031903.10063.jimis@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708051903.12414.jimis@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

was my report so complicated? Perhaps I shouldn't have included so many 
oprofile outputs. Anyway, if anyone wants to have a look, the most important 
is two_discs_bad.txt oprofile output, attached on my original message. The 
problem is 100% reproducible for me so I would appreciate if anyone told me 
he has similar experiences. 


Thanks, 
Dimitris



On Friday 03 August 2007 19:03:09 Dimitrios Apostolou wrote:
> Hello list,
>
> I have a P3, 256MB RAM system with 3 IDE disks attached, 2 identical
> ones as hda and hdc (primary and secondary master), and the disc with
> the OS partitions as primary slave hdb. For more info please refer to
> the attached dmesg.txt. I attach several oprofile outputs that describe
> various circumstances referenced later. The script I used to get them is
> the attached script.sh.
>
> The problem was encountered when I started two processes doing heavy I/O
> on hda and hdc, "badblocks -v -w /dev/hda" and "badblocks -v -w
> /dev/hdc". At the beginning (two_discs.txt) everything was fine and
> vmstat reported more than 90% iowait CPU load. However, after a while
> (two_discs_bad.txt) that some cron jobs kicked in, the image changed
> completely: the cpu load was now about 60% system, and the rest was user
> cpu load possibly going to the simple cron jobs.
>
> Even though under normal circumstances (for example when running
> badblocks on only one disc (one_disc.txt)) the cron jobs finish almost
> instantaneously, this time they were simply never ending and every 10
> minutes or so more and more jobs were being added to the process table.
> One day later, the vmstat still reports about 60/40 system/user cpu load,
> all processes still run (hundreds of them), and the load average is huge!
>
> Another day later the OOM killer kicks in and kills various processes,
> however never touches any badblocks process. Indeed, manually suspending
> one badblocks process remedies the situation: within some seconds the
> process table is cleared from cron jobs, cpu usage is back to 2-3% user
> and ~90% iowait and the system is normally responsive again. This
> happens no matter which badblocks process I suspend, being hda or hdc.
>
> Any ideas about what could be wrong? I should note that the kernel is my
> distro's default. As the problem seems to be scheduler specific I didn't
> bother to compile a vanilla kernel, since the applied patches seem
> irrelevant:
>
> http://archlinux.org/packages/4197/
> http://cvs.archlinux.org/cgi-bin/viewcvs.cgi/kernels/kernel26/?cvsroot=Curr
>ent&only_with_tag=CURRENT
>
>
> Thank in advance,
> Dimitris
>
>
> P.S.1: Please CC me directly as I'm not subscribed
>
> P.S.2: Keep in mind that the problematic oprofile outputs probably refer
> to much longer time than 5 sec, since due to high load the script was
> taking long to complete.
>
> P.S.3: I couldn't find anywhere in kernel documentation that setting
> nmi_watchdog=0 is neccessary for oprofile to work correctly. However,
> Documentation/nmi_watchdog.txt mentions that oprofile should disable the
> nmi_watchdog automatically, which doesn't happen with the latest kernel.



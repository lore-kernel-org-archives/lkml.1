Return-Path: <linux-kernel-owner+w=401wt.eu-S1761865AbYBZKae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761865AbYBZKae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758647AbYBZKaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:30:23 -0500
Received: from lizzard.sbs.de ([194.138.37.39]:44721 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758310AbYBZKaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:30:21 -0500
Message-ID: <47C3EA1F.3030203@siemens.com>
Date: Tue, 26 Feb 2008 11:29:51 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24.2-rt2
References: <1203639849.7551.4.camel@localhost.localdomain>
In-Reply-To: <1203639849.7551.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> We are pleased to announce the 2.6.24.2-rt2 tree, which can be
> downloaded from the location:
> 
>   http://rt.et.redhat.com/download/
> 
> Information on the RT patch can be found at:
> 
>   http://rt.wiki.kernel.org/index.php/Main_Page
> 
> Changes since 2.6.24-rt1
> 
>   - ported to 2.6.24.2
> 
>   - *** New ftrace utility ***
>       The old latency_tracer has now been replaced with the cleaned up
>       version that is being prepared for mainline.
> 
>   - compiler warning fix (Shi Weihua)

This important fix is still missing:

http://lkml.org/lkml/2008/2/5/295


At this chance: We still see the same unbalanced sched-other load on our
NUMA box as Gernot once reported [1]:

top - 11:19:20 up 4 min,  1 user,  load average: 29.52, 9.54, 3.37
Tasks: 502 total,  41 running, 461 sleeping,   0 stopped,   0 zombie
Cpu0  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu2  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu3  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu4  :  0.0%us,  0.3%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu8  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu9  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu10 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu11 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu12 :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu13 :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu14 :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu15 :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:  65513284k total,  1032032k used, 64481252k free,     6444k buffers
Swap:  3204896k total,        0k used,  3204896k free,    37312k cached

 PR   PID  NI  VIRT  SHR S %CPU %MEM    TIME+  COMMAND
 20  5603   0  705m  464 R  100  0.3   1:18.19 load-balance-te
 20  5604   0  705m  464 R  100  0.3   1:18.16 load-balance-te
 20  5605   0  705m  464 R  100  0.3   1:18.18 load-balance-te
 20  5608   0  705m  464 R  100  0.3   1:18.18 load-balance-te
 20  5611   0  705m  464 R   25  0.3   0:19.58 load-balance-te
 20  5620   0  705m  464 R   25  0.3   0:19.54 load-balance-te
 20  5606   0  705m  464 R   25  0.3   0:19.56 load-balance-te
 20  5616   0  705m  464 R   25  0.3   0:19.54 load-balance-te
 20  5607   0  705m  464 R   20  0.3   0:15.64 load-balance-te
 20  5609   0  705m  464 R   20  0.3   0:15.66 load-balance-te
 20  5614   0  705m  464 R   20  0.3   0:15.68 load-balance-te
 20  5617   0  705m  464 R   20  0.3   0:15.64 load-balance-te
 20  5619   0  705m  464 R   20  0.3   0:15.64 load-balance-te
 20  5610   0  705m  464 R   17  0.3   0:13.10 load-balance-te
 20  5618   0  705m  464 R   17  0.3   0:13.04 load-balance-te
 20  5621   0  705m  464 R   17  0.3   0:13.02 load-balance-te
 20  5622   0  705m  464 R   17  0.3   0:13.02 load-balance-te
 20  5623   0  705m  464 R   17  0.3   0:13.06 load-balance-te
 20  5624   0  705m  464 R   17  0.3   0:13.02 load-balance-te
 20  5615   0  705m  464 R    5  0.3   0:03.76 load-balance-te
 20  5633   0  705m  464 R    5  0.3   0:03.72 load-balance-te
 20  5634   0  705m  464 R    5  0.3   0:03.82 load-balance-te
 20  5635   0  705m  464 R    5  0.3   0:03.74 load-balance-te
 20  5636   0  705m  464 R    5  0.3   0:03.72 load-balance-te
 20  5638   0  705m  464 R    5  0.3   0:03.72 load-balance-te
 20  5640   0  705m  464 R    5  0.3   0:03.72 load-balance-te
 20  5612   0  705m  464 R    5  0.3   0:03.78 load-balance-te
 20  5613   0  705m  464 R    5  0.3   0:03.78 load-balance-te
 20  5625   0  705m  464 R    5  0.3   0:03.74 load-balance-te
 20  5626   0  705m  464 R    5  0.3   0:03.74 load-balance-te
 20  5627   0  705m  464 R    5  0.3   0:03.82 load-balance-te
 20  5628   0  705m  464 R    5  0.3   0:03.72 load-balance-te
 20  5629   0  705m  464 R    5  0.3   0:03.72 load-balance-te
 20  5630   0  705m  464 R    5  0.3   0:03.72 load-balance-te
 20  5631   0  705m  464 R    5  0.3   0:03.72 load-balance-te
 20  5632   0  705m  464 R    5  0.3   0:03.72 load-balance-te
 20  5637   0  705m  464 R    5  0.3   0:03.72 load-balance-te
 20  5639   0  705m  464 R    5  0.3   0:03.74 load-balance-te
 20  5641   0  705m  464 R    5  0.3   0:03.70 load-balance-te
 20  5642   0  705m  464 R    5  0.3   0:03.80 load-balance-te

I just accidentally compiled the kernel with NR_CPUS=8 first, and then
the load was balanced. Weird.

Some time ago I tried to dig into this but didn't get far due to the
limited bisectability of -rt (was at least true for .23-rtX) and limited
time. But based on this search, I suspect now that the issue is
introduced via some patch somewhere at the end of the series. If anyone
has a good pointer what to check, I would try to look into this again.

Jan

[1] http://thread.gmane.org/gmane.linux.rt.user/1640/focus=1746

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux

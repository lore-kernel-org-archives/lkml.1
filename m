Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbXIHXF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbXIHXF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 19:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbXIHXFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 19:05:14 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4302 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbXIHXFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 19:05:12 -0400
Message-ID: <46E32A5D.7080009@xs4all.nl>
Date: Sun, 09 Sep 2007 01:03:57 +0200
From: Bauke Jan Douma <bjdouma@xs4all.nl>
Reply-To: bjdouma@xs4all.nl
Organization: a training zoo
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: bogomips discrepancy on Intel Core2 Quad CPU
References: <46DBC092.8030209@xs4all.nl> <46DC1E9B.3030108@tmr.com>
In-Reply-To: <46DC1E9B.3030108@tmr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote on 03-09-07 16:47:
> Bauke Jan Douma wrote:
>> $> uname -a
>> Linux skyscraper 2.6.22.5 #7 SMP PREEMPT Sun Sep 2 12:12:25 CEST 2007 
>> i686 GNU/Linux
>>
>> $> cat /proc/cpuinfo | grep bogomips
>> bogomips    : 4813.46
>> bogomips    : 4810.91
>> bogomips    : 4810.91
>> bogomips    : 10583.94
>>
>> The latter seems way off base.
>> Prod me for more info.
>>
> I see this occasionally on a dual, speedstep (or similar) finds a way to 
> throttle down the cores under light load. I suspect that if you load the 
> system:
> 
>   for n in 1 2 3 4; do
>     nice -19 bash -c 'while true; do a=$RANDOM; done' &
>   done
> 
> Then you should see your bogomips rise on all cores.

Sorry for now getting back on this sooner.  Other matters forced it to
the backburner.

I don't have Speedstep enabled on this machine's kernel (as a matter
of fact, the entire cpufreq Kconfig subtree is unchecked). Needless to
say running your bash script doesn't change the values in any way.

I'd say the 4800-something bogomips value is the correct one (for a
2.4GHz CPU -- at least that's what I recall on single-CPU machines,
mostly bogomips being approx. twice the rated CPU speed), and the
10000-something is the one off base.

Btw., the 10000 can be something like 12000-odd after a machine reboot,
and readout on a different CPU.  The rest are all ca. 4810. Odd indeed.

bjd


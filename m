Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbXI2SeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbXI2SeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 14:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbXI2SeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 14:34:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbXI2SeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 14:34:01 -0400
Message-ID: <46FE9A90.8040402@redhat.com>
Date: Sat, 29 Sep 2007 14:33:52 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Bonnie++ with 1024k stripe SW/RAID5 causes kernel to goto D-state
References: <Pine.LNX.4.64.0709291306320.4569@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0709291306320.4569@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Kernel: 2.6.23-rc8 (older kernels do this as well)
> 
> When running the following command:
> /usr/bin/time /usr/sbin/bonnie++ -d /x/test -s 16384 -m p34 -n 
> 16:100000:16:64
> 
> It hangs unless I increase various parameters md/raid such as the 
> stripe_cache_size etc..
> 
> # ps auxww | grep D
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root       276  0.0  0.0      0     0 ?        D    12:14   0:00 [pdflush]
> root       277  0.0  0.0      0     0 ?        D    12:14   0:00 [pdflush]
> root      1639  0.0  0.0      0     0 ?        D<   12:14   0:00 [xfsbufd]
> root      1767  0.0  0.0   8100   420 ?        Ds   12:14   0:00 
> root      2895  0.0  0.0   5916   632 ?        Ds   12:15   0:00 
> /sbin/syslogd -r
> 
> See the bottom for more details.
> 
> Is this normal?  Does md only work without tuning up to a certain stripe 
> size? I use a RAID 5 with 1024k stripe which works fine with many 
> optimizations, but if I just boot the system and run bonnie++ on it 
> without applying the optimizations, it will hang in d-state.  When I run 
> the optimizations, then it exits out of D-state, pretty weird?

Not at all.  1024k stripes are way outside the norm.  If you do something way 
outside the norm, and don't tune for it in advance, don't be terribly surprised 
when something like bonnie++ brings your box to its knees.

That's not to say we couldn't make md auto-tune itself more intelligently, but 
this isn't really a bug.  With a sufficiently huge amount of RAM, you'd be able 
to dynamically allocate the buffers that you're not pre-allocating with 
stripe_cache_size, but bonnie++ is eating that up in this case.

	-- Chris

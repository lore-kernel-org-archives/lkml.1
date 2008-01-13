Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbYAMMD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbYAMMD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 07:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbYAMMDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 07:03:50 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:41939 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbYAMMDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 07:03:49 -0500
Date: Sun, 13 Jan 2008 17:33:37 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Andrew Paprocki <andrew@ishiboo.com>
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>
Subject: Re: HPET timer broken using 2.6.23.13 / nanosleep() hangs
Message-ID: <20080113120337.GA5548@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <76366b180801130310x57f24cc8s641d3ccb2415524c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76366b180801130310x57f24cc8s641d3ccb2415524c@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 06:10:52AM -0500, Andrew Paprocki wrote:
> I started debugging a problem I was having with my sky2 network driver
> under 2.6.23.13. The investigation led me to find that the HPET timer
> wasn't working at all, causing the sky2 driver to not work properly.
> Simple example:
> 
> am2:/sys/devices/system/clocksource/clocksource0# cat current_clocksource
> jiffies
> am2:/sys/devices/system/clocksource/clocksource0# time sleep 1
> real    0m1.000s
> user    0m0.000s
> sys     0m0.000s
> am2:/sys/devices/system/clocksource/clocksource0# echo tsc > current_clocksource
> am2:/sys/devices/system/clocksource/clocksource0# time sleep 1
> real    0m1.005s
> user    0m0.004s
> sys     0m0.000s
> am2:/sys/devices/system/clocksource/clocksource0# echo hpet >
> current_clocksource
> am2:/sys/devices/system/clocksource/clocksource0# time sleep 1
> <hangs indefinetly...>
> 
> Running strace shows it blocked on nanosleep(). I'm building the
> kernel with the processor type set to Athalon64. I've built it with
> and without SMP and high-res timers enabled and I get the same result.
> My previous 2.6.18-4 kernel works because it does not install HPET as
> the default timer. The same behavior occurs in 2.6.24-rc7 git head.
> I've attached the config/dmesg below.
> 

It seems the HPET timer was not being assigned any IRQs at all. Can you
try the patch at http://lkml.org/lkml/2008/1/12/128 ?

Thanks,
-- 
regards,
Dhaval

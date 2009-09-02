Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbZIBCZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbZIBCZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 22:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbZIBCZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 22:25:06 -0400
Received: from mail-yw0-f188.google.com ([209.85.211.188]:65209 "EHLO
	mail-yw0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbZIBCZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 22:25:05 -0400
Message-ID: <4A9DD790.50302@billgatliff.com>
Date: Tue, 01 Sep 2009 21:25:20 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
CC: Paul Mundt <lethal@linux-sh.org>,
       Linux Power Management List <linux-pm@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
Subject: Re: Montreal Linux Power Management Mini-Summit, July 13, 2009 -
 Meeting Notes
References: <alpine.LFD.2.00.0905211430220.4390@localhost.localdomain>	<alpine.LFD.2.00.0907301801240.17818@localhost.localdomain> <63386a3d0909011522m7a175d3eyb3bbe8a29a5fd104@mail.gmail.com>
In-Reply-To: <63386a3d0909011522m7a175d3eyb3bbe8a29a5fd104@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> I've felt a need for clock notifiers and we've cheated by using
> CPUfreq because it so happens that the clocking in system-wide
> and whenever the CPU freq change so may the other clocks.
>
> But if I put code into a PrimeCell MMC/SPI/I2C driver or whatever and
> use CPUfreq that's very unelegant, and for other platforms where
> the CPU freq don't change when this particular device clk freq
> change plain misleading.
>
> A clk pre/postchange notifier pair would really help and would
> make for elegant drivers that can handle clock freq transitions.
>   

A lot of ARM chips have peripherals that are driven by PLLs that run 
quasi-independently of the CPU clock.

If I guess correctly at what is being described above, a notifier chain 
for the users of a clock would be a clean way for peripherals to deal 
with clock speed *and* CPU speed changes, indeed.  A clock source that 
was affected by cpufreq would place itself on the cpufreq notifier 
chain, and also provide a notifier chain for peripherals that are driven 
by that clock.  When a cpufreq notification arrived, if the clock 
couldn't adjust for the cpufreq change it would use its notifier chain 
to tell all downstream peripherals about it.

A lot of peripherals could then focus just on the clock notifier chain, 
and would no longer care about cpufreq.  I like it.


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com


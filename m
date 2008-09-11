Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbYIKEZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbYIKEZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 00:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYIKEZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 00:25:09 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:32198 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYIKEZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 00:25:08 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=4LIkcjkLuXBjJV72WtwA:9 a=V2P_YzO3o3ujXdHdxU0A:7 a=TB266CL81UWUkzFglUz-GfrN0RYA:4 a=MSl-tDqOz04A:10 a=35aWkEOtFngA:10 a=2K3t0So284kA:10
Message-ID: <48C89D9F.5080404@shaw.ca>
Date: Wed, 10 Sep 2008 22:25:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mikhail.kshevetskiy@gmail.com, linux-kernel@vger.kernel.org,
       aabdulla@nvidia.com, jgarzik@pobox.com
Subject: Re: forcedeth: option to disable 100Hz timer (try 2)
References: <fa.iCGOiwuSYhYKpu85Kihny1t9YbA@ifi.uio.no> <fa.4uZtuq0waBlpfBb/4OLq4bM5Pj8@ifi.uio.no> <48C863CC.3010902@shaw.ca> <20080910173630.d0d38697.akpm@linux-foundation.org>
In-Reply-To: <20080910173630.d0d38697.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 10 Sep 2008 18:18:20 -0600
> Robert Hancock <hancockr@shaw.ca> wrote:
> 
>> Andrew Morton wrote:
>>> On Tue, 9 Sep 2008 23:34:35 +0400
>>> Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com> wrote:
>>>
>>>> On some hardware no TX done interrupts are generated, thus special
>>>> 100Hz timer interrupt is required to handle this situation properly.
>>>> Other device do not require that timer interrupt feature. 
>>>>
>>>> Forcedeth has a DEV_NEED_TIMERIRQ flag to mark the broken devices.
>>>> Unfortunately, nobody know the actual list of broken devices, so all
>>>> device has this flag on. Other problem, this flag is not user visible,
>>>> so the kernel recompilation is required to disable timer interrupts and
>>>> test a device.
>>>>
>>>> This patch add a "disable_timerirq" option to disable interrupt 
>>>> timer mentioned above. This may be extremely useful for laptop users.
>>> Why do you feel that the timer-based completions need to be disabled? 
>>> Is it causing some problem?
>> 100 unnecessary CPU wakeups per second imposes some power usage cost, 
>> especially on laptops with CPU C-states..
> 
> Is that the only reason for the change?  We still don't know...
> 
> 
> 
> Anyway, it's certainly _sufficient_ reason, however the implementation
> is pretty sad - most people won't even know that the option exists so
> they'll continue to chew more power than they need to.
> 
> How do we fix this?  Perhaps disable the timer by default, then wait
> for the first tx timeout and then enable the timer at that stage, while
> printing a message saying "add module option <foo> to prevent this
> once-off timeout from happening"?

It at least provides some way forward, where those that care can add the 
option and find out if their chipset can have the timer disabled in the 
driver by default in the future..

I'm not sure how long the TX timeout is, but I suspect it would be too 
disruptive to only enable the interrupt after a timeout. Enabling by 
default and disabling after a TX done interrupt was received would 
likely be a better approach (or one of the more creative approaches that 
others have mentioned). But it's quite likely that at least some of the 
chipsets that this driver supports don't need this timer nonsense at all.

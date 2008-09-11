Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYIKASf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYIKASf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 20:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYIKAS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 20:18:26 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:7349 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbYIKAS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 20:18:26 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=rBz25qeIdW_YTWl6FYkA:9 a=CP0yqq-Qwto0k5AxNM60jZAvA60A:4 a=MSl-tDqOz04A:10 a=35aWkEOtFngA:10 a=2K3t0So284kA:10
Message-ID: <48C863CC.3010902@shaw.ca>
Date: Wed, 10 Sep 2008 18:18:20 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       linux-kernel@vger.kernel.org, aabdulla@nvidia.com, jgarzik@pobox.com
Subject: Re: forcedeth: option to disable 100Hz timer (try 2)
References: <fa.iCGOiwuSYhYKpu85Kihny1t9YbA@ifi.uio.no> <fa.4uZtuq0waBlpfBb/4OLq4bM5Pj8@ifi.uio.no>
In-Reply-To: <fa.4uZtuq0waBlpfBb/4OLq4bM5Pj8@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 9 Sep 2008 23:34:35 +0400
> Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com> wrote:
> 
>> On some hardware no TX done interrupts are generated, thus special
>> 100Hz timer interrupt is required to handle this situation properly.
>> Other device do not require that timer interrupt feature. 
>>
>> Forcedeth has a DEV_NEED_TIMERIRQ flag to mark the broken devices.
>> Unfortunately, nobody know the actual list of broken devices, so all
>> device has this flag on. Other problem, this flag is not user visible,
>> so the kernel recompilation is required to disable timer interrupts and
>> test a device.
>>
>> This patch add a "disable_timerirq" option to disable interrupt 
>> timer mentioned above. This may be extremely useful for laptop users.
> 
> Why do you feel that the timer-based completions need to be disabled? 
> Is it causing some problem?

100 unnecessary CPU wakeups per second imposes some power usage cost, 
especially on laptops with CPU C-states..


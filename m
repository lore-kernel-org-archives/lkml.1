Return-Path: <linux-kernel-owner+w=401wt.eu-S1161133AbXBGKQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161133AbXBGKQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 05:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161130AbXBGKQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 05:16:58 -0500
Received: from postfix2-g20.free.fr ([212.27.60.43]:44339 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161133AbXBGKQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 05:16:57 -0500
Message-ID: <45C9A666.7010703@free.fr>
Date: Wed, 07 Feb 2007 11:13:58 +0100
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@elte.hu, tglx@timesys.com, johnstul@us.ibm.com, akpm@osdl.org,
       linux.kernel@free.fr
Subject: Re: One-shot high-resolution POSIX timer periodically late
References: <fa.4zD54Ie6Ozt0P4YqQSicS+XzXGw@ifi.uio.no> <fa.G+/T32f2o1M3+YGLca/O8NaAQyY@ifi.uio.no> <fa.6Ua8xjNfLKQEZZgDsoJgPMyww4g@ifi.uio.no> <fa.yQlV+WU0TgrJTVqjopa01tgCnT0@ifi.uio.no> <fa.ucVrLJ1Lh6FjdBHRglsIUc8/evk@ifi.uio.no> <fa.Id9oufyELrVbe5Wb8SRakwC0V50@ifi.uio.no> <45C1BE5C.9050001@free.fr> <20070206123716.GA8481@elte.hu>
In-Reply-To: <20070206123716.GA8481@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> John wrote:
> 
>> Ingo Molnar wrote:
>> 
>>> 2.6.18-rt7 is pretty old, do you see the problem in 2.6.20-rc6-rt5 too?
>> 
>> Ingo, Thomas,
>> 
>> I cannot reproduce in 2.6.20-rc6-rt6, but it is not strictly an 
>> apples-to-apples comparison because I get a tsc clocksource in 
>> 2.6.20-rc6-rt6, and an acpi_pm clocksource in 2.6.18.6-rt7.
> 
> That suggests that the TSC was not deemed reliable by the newer kernel, 
> which almost always means it's not realiable. I think the problems you 
> were seeing are consistent with TSC being non-monotonic - so the fix is 
> to not use the TSC - and the newer kernel does this automatically.

Ingo,

Perhaps you've mis-read my message?

*2.6.18.6-rt7* installed an acpi_pm clocksource. When I used a boot 
parameter to force the clocksource to tsc, the high-resolution timer 
infrastructure broke (timers expired several *ms* too late).

On the other hand, *2.6.20-rc6-rt6* and *2.6.20-rt2* both installed a 
tsc clock source, and it works.

Therefore, it is not the newer kernel that ignored the tsc, but the 
older kernel. Thus I don't know what to make of your comment :-)

Regards,

John


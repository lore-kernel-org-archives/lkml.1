Return-Path: <linux-kernel-owner+w=401wt.eu-S1422749AbXBAKS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422749AbXBAKS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 05:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422764AbXBAKS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 05:18:57 -0500
Received: from smtp7-g19.free.fr ([212.27.42.64]:47400 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422749AbXBAKSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 05:18:55 -0500
Message-ID: <45C1BE5C.9050001@free.fr>
Date: Thu, 01 Feb 2007 11:18:04 +0100
From: John <shill@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tglx@timesys.com, mingo@elte.hu, johnstul@us.ibm.com, akpm@osdl.org,
       shill@free.fr
Subject: Re: One-shot high-resolution POSIX timer periodically late
References: <fa.4zD54Ie6Ozt0P4YqQSicS+XzXGw@ifi.uio.no> <fa.G+/T32f2o1M3+YGLca/O8NaAQyY@ifi.uio.no> <fa.6Ua8xjNfLKQEZZgDsoJgPMyww4g@ifi.uio.no> <fa.yQlV+WU0TgrJTVqjopa01tgCnT0@ifi.uio.no> <fa.ucVrLJ1Lh6FjdBHRglsIUc8/evk@ifi.uio.no> <fa.Id9oufyELrVbe5Wb8SRakwC0V50@ifi.uio.no>
In-Reply-To: <fa.Id9oufyELrVbe5Wb8SRakwC0V50@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Same player shoot again. Fix address. ]

Ingo Molnar wrote:

> John wrote:
> 
>> John Stultz wrote:
>>
>>> Also do check the -rt tree as Ingo suggested. I mis-read your earlier
>>> email and thought you were running it.
>>
>> I've been pulling my hair over a related issue for the past two days.
>>
>> (I think I may be tickling a -hrt bug...)
>>
>> I'm working with 2.6.18.6 + patch-2.6.18-rt7
> 
> 2.6.18-rt7 is pretty old, do you see the problem in 2.6.20-rc6-rt5 too?

Ingo, Thomas,

I cannot reproduce in 2.6.20-rc6-rt6, but it is not strictly an
apples-to-apples comparison because I get a tsc clocksource in
2.6.20-rc6-rt6, and an acpi_pm clocksource in 2.6.18.6-rt7.

Here are the relevant parts of my boot messages:

Linux version 2.6.18.6-rt7
ACPI: PM-Timer IO Port: 0x4008
Clock event device pit configured with caps set: 07
Time: acpi_pm clocksource has been installed.
Clock event device pit configured with caps set: 08
Switched to high resolution mode on CPU 0

Linux version 2.6.20-rc6-rt6
ACPI: PM-Timer IO Port: 0x4008
Time: tsc clocksource has been installed.

(pit and acpi_pm have disappeared from 2.6.20-rc6-rt6)

The -rt patch set looks great, but I am somewhat hesitant to use it. It
seems it is only updated for the latest kernel version available. Or am
I mistaken? In other words, once 2.6.20 is released, and work starts on
2.6.21, if a bug is discovered in -rt, the fix will not be back-ported
to the 2.6.20.x (and 2.6.19.x, and 2.6.18.x, etc) patch set?

NB: I do need high-resolution timers, but, at the same time, I'm not
very comfortable living on the bleeding edge, where new bugs and
regressions might not get caught in release candidates. (I work on an
industrial project where continuous operation is a requirement.)

Regards.


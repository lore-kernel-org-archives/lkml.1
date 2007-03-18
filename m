Return-Path: <linux-kernel-owner+w=401wt.eu-S933325AbXCRWJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbXCRWJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 18:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933330AbXCRWJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 18:09:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:39989 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933325AbXCRWJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 18:09:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ns8TUjiaarlwHF4zmx7lIuZWEw00MqGVXw8PzLMnxGmUkGP/VxR7Hn5XaFwsVknaPBTq2D3v5OxVnhm2/M23y/Hk82awqtpRHjD9UwYwKeMOR63wz5Xe6N7s7LGWXQS4PkVoEvlzrn3WSEWUgFwm/S4q6tROgXTeumTXyqdtjg0=
Message-ID: <3d8471ca0703181509j11485441ybfae3631894c2a66@mail.gmail.com>
Date: Sun, 18 Mar 2007 23:09:11 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] Add an offset in the cyc2ns computation to fix sched_clock jumps
Cc: "Andi Kleen" <ak@suse.de>, "john stultz" <johnstul@us.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070318210819.GB19818@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d8471ca0703161114o7ad654car60c1a6b801401149@mail.gmail.com>
	 <20070318210819.GB19818@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/18, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>:
> Hi Guillaume,

Hi Mathieu, thanks for your extensive reply.

> yet another level of band-aid over a

I don't agree it's a band-aid, changing the scaling coefficient
without adjusting an offset is a bug.

> broken architecture : AMD 7th and 8th generations

Actually in my case it's Intel Pentium M Dothan.

> other parts of the kernel suffers from those TSC inconsistencies

These other parts should not use sched_clock() but the clocksource
mechanism which in my case rightly avoids the TSC and uses the
ACPI timer. And I hope it will stay that way as the TSC definitely is
not a reliable time source in my case for the reasons you gave.

> it does not deal with frequency scaling due to temperature related
> events, and does not, as I recall, deal with frequency scaling in halt
> mode.

Yep, I saw this, that's why I said in this case sched_clock() does not
return nanoseconds as it thinks it does. Thankfully, the scheduler is
not stressed when the CPU is idle. Anyway, spilling on another thread,
this is a bonus point for the RSDL scheduler as it does not account
the sleeping time of tasks.

> I also plan to update this global last_tsc every timer tick to give a
> higher bound to time accuracy.

Then I don't see how this is significantly better than the ACPI timer
except for the increased precision in short durations. For example,
my CPU can lower its frequency down to 798 MHz and the TSC
down to 350 MHz or so (measured). So your clock will think the
TSC runs at 798 MHz  when it runs at 350MHz, and every tick the
clock will make a half tick jump to catch up with its delay.

The best solution seems to buy a new computer with a reliable
TSC ;-)

Thanks.

-- 
Guillaume

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761845AbZD3Iyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761845AbZD3Iyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759434AbZD3IyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:54:21 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:1307 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271AbZD3IyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:54:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xjIjuiqP56XURCi/sNb0jjHbNSuVwyblLbVy5VWx5lQ/p5odOfxH4tzfqwOolQrOx4
         Zv+EA7Ak4M4AsonxWZ2x24ImOrhk4pWTN8FHGza2oDeDhg38ZZiTQhhc/aQxlmB+7LP7
         bHXM53HVbACTQRHHZY7wgoFBDbq5z0X1F4H2E=
MIME-Version: 1.0
In-Reply-To: <200904292147.02441.rjw@sisk.pl>
References: <208cbae30904190953t58105f13p6e11efca6d6f5322@mail.gmail.com>
	 <200904272335.33060.rjw@sisk.pl>
	 <208cbae30904290621m1fbf7bc5x27fa410a23ada3dc@mail.gmail.com>
	 <200904292147.02441.rjw@sisk.pl>
Date: Thu, 30 Apr 2009 12:54:18 +0400
Message-ID: <208cbae30904300154n447deedbucbd7c56d2cc90079@mail.gmail.com>
Subject: Re: [warn_once] warning: at kernel/hrtimer.c:625 hres_timers_resume+0x24/0x38()
From: Alexey Klimov <klimov.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael

On Wed, Apr 29, 2009 at 11:47 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday 29 April 2009, Alexey Klimov wrote:
>> Hello,
>>
>> On Tue, Apr 28, 2009 at 1:35 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Sunday 19 April 2009, Alexey Klimov wrote:
>> >> Hello all
>> >> When testing behaviour of radio-mr800 drvier when doing suspend/resume
>> >> to disk, using echo disk > /sys/power/state i have such warning in
>> >> dmesg(see below please).
>> >> Kernel is 30-rc2, up-to-date. If you need more information, feel free to ask.
>> >
>> > Can you please retest with the appended patch applied and report back?
>>
>> Of course. I applied your patch against up-to-date sources (30-rc3),
>> and have more messages after resume:
>
> Thanks!
>
>> ACPI: Preparing to enter system sleep state S4
>> PM: Saving platform NVS memory
>> ------------[ cut here ]------------
>> WARNING: at drivers/base/sys.c:405 sysdev_suspend+0xb6/0x21c()
>> Hardware name: TravelMate 2350
>> Interrupts enabled after cpufreq_suspend+0x0/0x113
>
> Well, it looks like cpufreq_suspend() left us with interrupts enabled and
> that caused the other warnings to be printed.  Not nice.
>
> What CPU is there in your box?
>
> Rafael

Yes, cpufreq_ondemand enabled. It's 1.7 GHz pentium-m. The lowest
frequency is 600 MHz.
Here is my /proc/cpuinfo:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 13
model name      : Intel(R) Pentium(R) M processor 1.70GHz
stepping        : 6
cpu MHz         : 600.000
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr mce cx8 apic sep mtrr pge mca
cmov clflush dts acpi mmx fxsr sse sse2 ss tm pbe bts est tm2
bogomips        : 1198.79
clflush size    : 64
power management:


-- 
Best regards, Klimov Alexey

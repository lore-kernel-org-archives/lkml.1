Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbZFCQn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbZFCQn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbZFCQnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:43:52 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:51567 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbZFCQnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vrc9A0bbjYmGKsWotr+2s4ovw5CtdslDjpSD6YbqiD0viQhPZfNKc56Ipoo0x41mTF
         BAcPfgAYz31EMQ6LFCY2g7oL2kMa74z6nO937rkL1/JpnmtBXzlIl7KYNFqc5DrKG197
         E3UrtJ5qcZWLCFkyHsus3irupfE0SD0eCr+zk=
MIME-Version: 1.0
In-Reply-To: <b637ec0b0905040510m5035d6bbgc98573d782b8d623@mail.gmail.com>
References: <208cbae30904190953t58105f13p6e11efca6d6f5322@mail.gmail.com>
	 <200904272335.33060.rjw@sisk.pl>
	 <208cbae30904290621m1fbf7bc5x27fa410a23ada3dc@mail.gmail.com>
	 <200904292147.02441.rjw@sisk.pl>
	 <208cbae30904300154n447deedbucbd7c56d2cc90079@mail.gmail.com>
	 <b637ec0b0905040510m5035d6bbgc98573d782b8d623@mail.gmail.com>
Date: Wed, 3 Jun 2009 20:43:52 +0400
Message-ID: <208cbae30906030943i7120fb4dq9df62b26f6ffc0b2@mail.gmail.com>
Subject: Re: [warn_once] warning: at kernel/hrtimer.c:625 hres_timers_resume+0x24/0x38()
From: Alexey Klimov <klimov.linux@gmail.com>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 4, 2009 at 4:10 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> I see the same message with 2.6.29.2 on a laptop with the same CPU
> model also with cpufreq_ondemand.
>
> In my case the first hibernate attempt gives the message and succeeds.
> The system resumes ok.
>
> A further hibernation/resume cycle results in a hang (power cycle required).
>
> It' probably a regression wrt 2.6.28.7 (I'm not sure because with the
> version upgrade I  also changed my DRI driver from fglrx to radeon and
> also the X.org userspace).
>
> Regards,
> Fabio
>
> On Thu, Apr 30, 2009 at 10:54 AM, Alexey Klimov <klimov.linux@gmail.com> wrote:
>> Hello, Rafael
>>
>> On Wed, Apr 29, 2009 at 11:47 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> On Wednesday 29 April 2009, Alexey Klimov wrote:
>>>> Hello,
>>>>
>>>> On Tue, Apr 28, 2009 at 1:35 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>> > On Sunday 19 April 2009, Alexey Klimov wrote:
>>>> >> Hello all
>>>> >> When testing behaviour of radio-mr800 drvier when doing suspend/resume
>>>> >> to disk, using echo disk > /sys/power/state i have such warning in
>>>> >> dmesg(see below please).
>>>> >> Kernel is 30-rc2, up-to-date. If you need more information, feel free to ask.
>>>> >
>>>> > Can you please retest with the appended patch applied and report back?
>>>>
>>>> Of course. I applied your patch against up-to-date sources (30-rc3),
>>>> and have more messages after resume:
>>>
>>> Thanks!
>>>
>>>> ACPI: Preparing to enter system sleep state S4
>>>> PM: Saving platform NVS memory
>>>> ------------[ cut here ]------------
>>>> WARNING: at drivers/base/sys.c:405 sysdev_suspend+0xb6/0x21c()
>>>> Hardware name: TravelMate 2350
>>>> Interrupts enabled after cpufreq_suspend+0x0/0x113
>>>
>>> Well, it looks like cpufreq_suspend() left us with interrupts enabled and
>>> that caused the other warnings to be printed.  Not nice.
>>>
>>> What CPU is there in your box?
>>>
>>> Rafael
>>
>> Yes, cpufreq_ondemand enabled. It's 1.7 GHz pentium-m. The lowest
>> frequency is 600 MHz.
>> Here is my /proc/cpuinfo:
>>
>> processor       : 0
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 13
>> model name      : Intel(R) Pentium(R) M processor 1.70GHz
>> stepping        : 6
>> cpu MHz         : 600.000
>> cache size      : 2048 KB
>> fdiv_bug        : no
>> hlt_bug         : no
>> f00f_bug        : no
>> coma_bug        : no
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 2
>> wp              : yes
>> flags           : fpu vme de pse tsc msr mce cx8 apic sep mtrr pge mca
>> cmov clflush dts acpi mmx fxsr sse sse2 ss tm pbe bts est tm2
>> bogomips        : 1198.79
>> clflush size    : 64
>> power management:

FYI:
This warning still present in latest 2.6.30-rc8. I tried to find the
problem but failed.
Probably, someone experienced developer can help here and find the problem.

-- 
Best regards, Klimov Alexey

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbYFDECI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbYFDECI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYFDEB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:01:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:14749 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYFDEBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:01:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lYllpyARQGSb0XaHATCQbOzYXlfFca+fxSy36JbNrx2HzdN3CNrRVLYR3MQZN2j2kIvN97N36SQcRc6ER9iE7w1nPs2YyPYvfzU/mBqNGSPkelCBRbODLJLD2a5VgvzuvX4/zyBISV6K2jPeEJ5ANlTjzfv3sDqJ3eKfG0r7+WU=
Message-ID: <35f686220806032101h103152dat841818982aaa5052@mail.gmail.com>
Date: Tue, 3 Jun 2008 21:01:54 -0700
From: "Alok kataria" <alokkataria1@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
Cc: akataria@vmware.com, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Dan Hecht" <dhecht@vmware.com>, "Tim Mann" <mann@vmware.com>,
       "Zachary Amsden" <zach@vmware.com>, "Sahil Rihan" <srihan@vmware.com>
In-Reply-To: <20080603182014.79a38d03@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080603182014.79a38d03@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2008 at 6:20 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Tue, 03 Jun 2008 17:41:09 -0700
> Alok Kataria <akataria@vmware.com> wrote:
>
>> On X86 platform we can use the value of cpu_khz computed during tsc
>> calibration to calculate the loops_per_jiffy value. Its very
>> important to keep the error in lpj values to minimum as any error in
>> that may result in kernel panic in check_timer.
>> In virtualization environment on a highly overloaded host, the guest
>> delay calibration may sometimes result in errors beyond the ~50% that
>> timer_irq_works can handle, resulting in the guest panicking.
> \
>
> can you guarantee that the rate tsc ticks at is the same as the current
> CPU frequency? Answer: You can't....
>

I think at the boot time atleast we can assume that, no ?
If you are referring to the cpu frequency changing at run time (aka
dynamic frequency scaling),
in that case the time_cpufreq_notifier should take care of updating
the loops_per_jiffy
value for that corresponding cpu.

> sadly we do need to calibrate this...
>
> In addition, clearly you can have different cpus in a system run at a
> different rate (both in terms of cpu_khz and, independently, in terms
> of tsc rate)
>

Again yes at run time frequency's may change but they shouldn't at boottime.
AFAIK, i don't think there are X86 MP systems with asymmetric cpus
i.e. systems with different
base frequencies. If thats not true then there sure is a problem.

Thanks,
Alok

>
> --
> If you want to reach me at my work email, use arjan@linux.intel.com
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

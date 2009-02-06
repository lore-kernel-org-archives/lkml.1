Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbZBFKvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbZBFKvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 05:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZBFKvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 05:51:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:46047 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbZBFKvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 05:51:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tvg9DvT+8pwsm8/zq+7sKo53QnFYN4HCfsPlPCqp0CCWScIF2D/lQbuN50W6jWz+33
         lhN/mLqaL5VZsascogNjttXAYJvYJHZ755FF5xb2le2fOooTRn5UVqgojBC2KYcPRS9z
         nlCTUcSnCHzkkXBQ5MycB1RyfmH8KNUxn0fSc=
MIME-Version: 1.0
In-Reply-To: <C06938CA40642541A159EE5590146C9AAC5742@EXCHANGESERVER.exchange.artec.org>
References: <C06938CA40642541A159EE5590146C9AAC5742@EXCHANGESERVER.exchange.artec.org>
Date: Fri, 6 Feb 2009 12:51:11 +0200
X-Google-Sender-Auth: e5eedb5e5689f2dd
Message-ID: <84144f020902060251j246baf79r9f3b326e3d172629@mail.gmail.com>
Subject: Re: System hangs (after some hours of working) since kernel 2.6.22.19
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Alexander Naumann <A.Naumann@artec-it.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Fri, Feb 6, 2009 at 11:06 AM, Alexander Naumann
<A.Naumann@artec-it.de> wrote:
> Summary of this bug ist hat system stops working after  a couple of hours (between 30 minutes and 6 hours).
> There are no messages at all ☹
> It just stops, I even cannot use some keys like SysRq (this ALT-PrintScreen thing).
>
> The only thing I am running is tiobench (to force system halt):
> „tiobench --numruns 10000“
> If I am running nothing, the system does not stop working or it takres verly long until it hangs.
>
> It cannot be a hardware defect because I have several equal machines and they all have the same problem.
>
> This error occures since Kernel version 2.6.22.19.
> I have tried several kernels like 2.6.23, 2.6.24., 2.6.24.7, 2.6.25, 2.6.26, 2.6.28.2
> With all of them the system hangs without any message.
> Before 2.6.22.19 I had no problems at all.

Does this mean that, for example, 2.6.22.18 works? Or do you mean
2.6.21.x worked and it stopped working starting from 2.6.22.x?

On Fri, Feb 6, 2009 at 11:06 AM, Alexander Naumann
<A.Naumann@artec-it.de> wrote:
> I have found some configuration of linux kernel so that this hang up does not occur:
> In 2.6.24.7 I have enabled ALL kernel debug options, the system did not crash.

I guess 'crashing.config' is _not_ the config you mention here (it
doesn't enable any of the kernel debugging options)?

On Fri, Feb 6, 2009 at 11:06 AM, Alexander Naumann
<A.Naumann@artec-it.de> wrote:
> Also I have included two config files for kernel 2.6.22.19.
> With one of them the system chrashes (crashing.config) with the other one it does not (working.config).
> The only difference between these two config files is that I enabled „Kernel Debug“.
>
> With all other tested kernel version I cannot see the same behaviour, they all crash after some hours, it does not matter how kernel is configured.

Just enabling CONFIG_DEBUG_KERNEL doesn't change anything so it's
probably just that the bug is hard to trigger.

On Fri, Feb 6, 2009 at 11:06 AM, Alexander Naumann
<A.Naumann@artec-it.de> wrote:
> cat /proc/cpuinfo:
> processor       : 0
> vendor_id       : CentaurHauls
> cpu family      : 6
> model           : 9
> model name      : VIA Nehemiah
> stepping        : 8
> cpu MHz         : 998.537
> cache size      : 64 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu vme de pse tsc msr cx8 sep mtrr pge cmov pat mmx fxsr sse up rng rng_en ace ace_en
> bogomips        : 1997.07
> clflush size    : 32
> power management:

This makes me wonder if there's some generic x86 change that's
behaving badly on VIA CPUs that don't get as much test coverage. One
thing you might want to try out is to disable CONFIG_X86_GENERIC and
use CONFIG_MVIAC3_2 instead of CONFIG_M586.

If that doesn't work out, you might want to strip your config to bare
minimum to see if the hang goes away. Looking at your config, at least
CONFIG_SMP, CONFIG_AGP, and CONFIG_DRM strike as good suspects.

Hope this helps,

                                           Pekka

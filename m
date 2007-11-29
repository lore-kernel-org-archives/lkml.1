Return-Path: <linux-kernel-owner+w=401wt.eu-S1761722AbXK2Kfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761722AbXK2Kfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbXK2Kfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:35:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbXK2Kfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:35:40 -0500
Date: Thu, 29 Nov 2007 11:35:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Michael Buesch <mb@bu3sch.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [BUG] jiffies counter leaps in 2.6.24-rc3
Message-ID: <20071129103511.GD10577@elte.hu>
References: <20071124175112.58193424@morte> <200711241948.58881.rjw@sisk.pl> <20071124194635.58f5a44b@morte> <200711242031.26134.rjw@sisk.pl> <20071129095034.24b3fc59@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129095034.24b3fc59@morte>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefano Brivio <stefano.brivio@polimi.it> wrote:

> Ok, I found out how to reliably reproduce this bug. The root session issue
> was a bit weird, but I noticed I usually switch to root only when I need to
> change the CPU frequency. And here's what happens:
> 
> # cpuspeedy min
> [after some time...]
> Nov 29 09:42:31 morte [ 4408.722597] b43-phy0 ERROR: PHY transmission error
> 
> # cpuspeedy max
> Nov 29 09:42:41 morte [ 1177.238599] wmaster0: STA 00:14:c1:35:8d:eb Average rate: 540 (2160/4)
> 
> It looks like jiffies get scaled exactly by a 3.75 factor, which is
> <max_frequency>/<min_frequency> here. I use acpi-cpufreq and this is my
> (only) CPU:
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 13
> model name      : Intel(R) Pentium(R) M processor 1.50GHz
> stepping        : 6
> cpu MHz         : 1500.000
> cache size      : 2048 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 2
> wp              : yes
> flags           : fpu vme de pse tsc msr mce cx8 sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe bts est tm2
> bogomips        : 2993.49
> clflush size    : 64
> 
> Any hint?

ah, the cpufreq/acpi/acpi-cpufreq angle is indeed a big clue. I've 
Cc:-ed various interested parties.

	Ingo

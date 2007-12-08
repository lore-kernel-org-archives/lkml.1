Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbXLHUI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbXLHUI1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXLHUIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:08:20 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:37888 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbXLHUIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:08:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jyC7Vj+2kVibAGlV+/X0inmPeRN4Mo3K/90v269E0ympEKNH7PBLbvDzqaaDJNleFbewvpu3U9wJLgK13zrIwrf5WWGSX1xkPACTBYaUJulssjrk9zzLTWxrMmQRu0u6oN8nAegUalxKl6dC8mCtIOOaLeIOUEmsbcHLkTkI88g=
Message-ID: <82e4877d0712081208u335c968csd1d3e9259cdd2920@mail.gmail.com>
Date: Sat, 8 Dec 2007 15:08:18 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20071208194211.GA579@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0712071453h38795e36of26324a4b123fa6c@mail.gmail.com>
	 <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
	 <alpine.LFD.0.99999.0712080821220.3070@localhost.localdomain>
	 <82e4877d0712080710g205ba93ag12ee204b15d70fdb@mail.gmail.com>
	 <82e4877d0712080736v12c1e31at9149655ae000fe50@mail.gmail.com>
	 <20071208154755.GA5255@elte.hu>
	 <82e4877d0712080800j6572734ek78a76cf7bb17a7e0@mail.gmail.com>
	 <20071208191330.GA21186@elte.hu>
	 <82e4877d0712081133y49fec9bfyee30a3010b37c435@mail.gmail.com>
	 <20071208194211.GA579@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 8, 2007 2:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Parag Warudkar <parag.warudkar@gmail.com> wrote:
>
> > Even on 100% idle I get variations that are approx in the same range
> > when not idle. Clocksource is hpet if that matters.  Next I think I
> > will disable CPU_IDLE, Tickless
>
> also try the hpet=disable boot option.

With hpet=disable (clocksource is acpi_pm ) the usleeps are somewhat
more closer to correct - under idle as well as under kernel
compilation load.
But there are still fluctuations under 100% idle -

Kernel compile
--------------------------
real    0m1.112s
user    0m0.004s
sys     0m0.000s

real    0m1.112s
user    0m0.000s
sys     0m0.000s

real    0m1.115s
user    0m0.000s
sys     0m0.000s

real    0m1.112s
user    0m0.000s
sys     0m0.000s

real    0m1.112s
user    0m0.000s
sys     0m0.000s
------------------------------
IDLE
real    0m1.112s
user    0m0.000s
sys     0m0.000s

real    0m1.131s
user    0m0.000s
sys     0m0.000s

real    0m1.112s
user    0m0.000s
sys     0m0.000s

real    0m1.112s
user    0m0.000s
sys     0m0.000s

real    0m1.139s
user    0m0.000s
sys     0m0.000s

>
> > My ssh connection just died - another lockup in dmesg -
> >
> > BUG: soft lockup - CPU#1 stuck for 14s! [sshd:509]
>
> this would suggest that the softlockup watchdog is correct and indeed
> there was some lockup of sorts?

Yep, I was about to say that there are indeed real soft-lockups going
on as opposed to the psuedo ones that we thought may be due to timer
inconsistencies.

BTW this is no-preempt config and 2.6.22  and latest Centos-5.1
kernels ran fine with HPET.

Parag

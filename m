Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbXFLNCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbXFLNCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbXFLNBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:01:52 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:22393 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbXFLNBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:01:51 -0400
Message-ID: <466E993D.5080308@msgid.tls.msk.ru>
Date: Tue, 12 Jun 2007 17:01:49 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Claas Langbehn <claas@rootdir.de>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: VIA C7 / VIA PC-1 (PC2500) anyone?
References: <466E65A7.3000206@msgid.tls.msk.ru> <5699f8f00706120344h40fe6f88vb7601c9326bd589f@mail.gmail.com> <466E8A5B.4080205@msgid.tls.msk.ru> <466E976D.7060103@rootdir.de>
In-Reply-To: <466E976D.7060103@rootdir.de>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Claas Langbehn wrote:
>> Hmm.  I wonder how to *enable* it in the first place.. ;)
>> e_powersaver.ko and acpi_cpufreq gives "No such device"
>>
> cat /proc/cpuinfo and have a look at the flags. Does it support "eps"?

I've looked at e_powersaver sources and noticied the second test in
init function (after checking for CPU model) - it fails on this very
test:

  if (!cpu_has(c, X86_FEATURE_EST))
     return -ENODEV;

(this is one of first things I did when turning the mobo on - tried
various options including CPU frequency scaling, observed it doesn't
work and tried to understand why, but didn't went much further here
because of the SIGSEGV problem which is much more serious... ;)

/proc/cpuinfo does not have "eps" (nor "est") flags:

processor       : 0
vendor_id       : CentaurHauls
cpu family      : 6
model           : 10
model name      : VIA Esther processor 1500MHz
stepping        : 9
cpu MHz         : 1496.321
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge cmov pat clflush acpi mmx fxsr sse sse2 tm nx up pni rng rng_en ace ace_en ace2 ace2_en phe phe_en pmm pmm_en
bogomips        : 3002.25
clflush size    : 64

(most close is "sep" ;)

> If not then e_powersaver is not possible. If cpufreq with acpi P-states
> does not work either then your mainboard/CPU does not support
> power saving.
> You might get in contact with Rafal Bilinski who wrote e_powersaver.

Yeah, good idea.. thanks! ;)

/mjt

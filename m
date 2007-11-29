Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbXK2IxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbXK2IxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 03:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbXK2IxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 03:53:07 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:47033 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755520AbXK2IxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:53:05 -0500
Date: Thu, 29 Nov 2007 09:50:34 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: [BUG] jiffies counter leaps in 2.6.24-rc3
Message-ID: <20071129095034.24b3fc59@morte>
In-Reply-To: <200711242031.26134.rjw@sisk.pl>
References: <20071124175112.58193424@morte>
	<200711241948.58881.rjw@sisk.pl>
	<20071124194635.58f5a44b@morte>
	<200711242031.26134.rjw@sisk.pl>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.11.29.2933
X-PerlMx-Spam: Gauge=IIIIIII, Probability=7%, Report='RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __STOCK_PHRASE_24 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I found out how to reliably reproduce this bug. The root session issue
was a bit weird, but I noticed I usually switch to root only when I need to
change the CPU frequency. And here's what happens:

# cpuspeedy min
[after some time...]
Nov 29 09:42:31 morte [ 4408.722597] b43-phy0 ERROR: PHY transmission error

# cpuspeedy max
Nov 29 09:42:41 morte [ 1177.238599] wmaster0: STA 00:14:c1:35:8d:eb Average rate: 540 (2160/4)

It looks like jiffies get scaled exactly by a 3.75 factor, which is
<max_frequency>/<min_frequency> here. I use acpi-cpufreq and this is my
(only) CPU:
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 13
model name      : Intel(R) Pentium(R) M processor 1.50GHz
stepping        : 6
cpu MHz         : 1500.000
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr mce cx8 sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe bts est tm2
bogomips        : 2993.49
clflush size    : 64

Any hint?


--
Ciao
Stefano

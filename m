Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbZKOKHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbZKOKHY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZKOKHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:07:24 -0500
Received: from mail.gmx.net ([213.165.64.20]:54203 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752555AbZKOKHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:07:23 -0500
X-Authenticated: #3373616
X-Provags-ID: V01U2FsdGVkX1+jB2sKigOjA/26uVXSJCQRMoUElGMar6jj/wRpUm
	/IeYj8ZMxdFrUt
Message-ID: <4AFFD2B8.5060400@gmx.de>
Date: Sun, 15 Nov 2009 20:06:48 +1000
From: =?UTF-8?B?U2ltb24gS8OkbXBmbGVpbg==?= <s.kaempflein@gmx.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: perf counters: problem with perf record
References: <4AFEE55B.3000906@gmx.de> <1258227980.30187.512.camel@laptop>
In-Reply-To: <1258227980.30187.512.camel@laptop>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra schrieb:
> On Sun, 2009-11-15 at 03:14 +1000, Simon Kämpflein wrote:
>> Hello,
>>
>> I have a problem with the new kernel perf tools in kernel 2.6.31.6 (very
>> nice tools by the way). I like to monitor the cache-misses of a program.
>> "perf stat -e cache-misses program" works without problems, but I can't
>> get "perf record -e cache-misses program" working (even running as root
>> and CONFIG_PERF_COUNTERS=y):
>>
>> Error: perfcounter syscall returned with -1 (Operation not supported)
>> Fatal: No CONFIG_PERF_COUNTERS=y kernel support configured?
>>
>> My CPU is a "Intel(R) Pentium(R) M processor 1.80GHz":
> 
> Does the bootlog perchance contain the output of?
> 
>         if (!cpu_has_apic) {
>                 pr_info("no APIC, boot with the \"lapic\" boot parameter
> to force-enable it.\n");
>                 pr_info("no hardware sampling interrupt available.\n");
>                 x86_pmu.apic = 0;
>         }

Yes. I didn't realize that it has something to do with the Performance
Counters because I didn't see that it belongs to the Performance Counter
output.
Maybe it's a good idea to add another comment making it clear that the
performance counters are not fully working in this case. Or detect this
case in "perf-record" and output a message relating to that.

> And does booting with the suggested lapic parameter cure your problems?
> 

Yes, thank you!

Regars,
Simon


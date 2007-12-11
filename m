Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbXLKXz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbXLKXz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbXLKXzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:55:14 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:48617 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbXLKXzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:55:12 -0500
Message-ID: <475F2358.6060006@nigel.suspend2.net>
Date: Wed, 12 Dec 2007 10:55:04 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl>
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Good day.
> 
> Would some people on x86 (both 32 and 64) be kind enough to compile and
> run the attached program? This is about testing how long I/O port access
> to port 0x80 takes. It measures in CPU cycles so CPU speed is crucial in
> reporting.
> 
> Posted a previous incarnation of this before, buried in the outb 0x80
> thread which had a serialising problem. This one should as far as I can
> see measure the right thing though. Please yell if you disagree...
> 
> For me, on a Duron 1300 (AMD756 chipset) I have a constant:
> 
> rene@7ixe4:~/src/port80$ su -c ./port80
> cycles: out 2400, in 2400
> 
> and on a PII 400 (Intel 440BX chipset) a constant:
> 
> rene@6bap:~/src/port80$ su -c ./port80
> cycles: out 553, in 251
> 
> Results are (mostly) independent of compiler optimisation, but testing
> with an -O2 compile should be most useful. Thanks!

(AMD 1.8GHz Turion, running at 800MHz. ATI RS480 - Mitac 8350 mobo)

nigel@home:~/Downloads$ gcc port80.c -o port80
nigel@home:~/Downloads$ sudo ./port80
cycles: out 1235, in 1207
nigel@home:~/Downloads$ sudo ./port80
cycles: out 1238, in 1205
nigel@home:~/Downloads$ sudo ./port80
cycles: out 1237, in 1209
nigel@home:~/Downloads$ gcc -O2 port80.c -o port80
nigel@home:~/Downloads$ sudo ./port80
cycles: out 1844674407370794, in 1844674407369408
nigel@home:~/Downloads$ sudo ./port80
cycles: out 1844674407370795, in 1844674407369404
nigel@home:~/Downloads$ sudo ./port80
cycles: out 1844674407370795, in 1844674407369409
nigel@home:~/Downloads$ sudo ./port80
cycles: out 1844674407370798, in 1844674407369407
nigel@home:~/Downloads$ cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 36
model name      : AMD Turion(tm) 64 Mobile Technology ML-34
stepping        : 2
cpu MHz         : 800.000
cache size      : 1024 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt
lm 3dnowext 3dnow rep_good pni lahf_lm
bogomips        : 1592.87
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc


Regards,

Nigel

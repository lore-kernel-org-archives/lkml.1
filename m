Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbXLLK2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbXLLK2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758199AbXLLK2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:28:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55603 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452AbXLLK2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:28:15 -0500
Subject: Re: [RFT] Port 0x80 I/O speed
From: Peter Zijlstra <peterz@infradead.org>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
References: <475F1DC6.5090403@keyaccess.nl>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 11:28:07 +0100
Message-Id: <1197455287.6985.35.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-12-12 at 00:31 +0100, Rene Herman wrote:
> Good day.
> 
> Would some people on x86 (both 32 and 64) be kind enough to compile and run 
> the attached program? This is about testing how long I/O port access to port 
> 0x80 takes. It measures in CPU cycles so CPU speed is crucial in reporting.
> 
> Posted a previous incarnation of this before, buried in the outb 0x80 thread 
> which had a serialising problem. This one should as far as I can see measure 
> the right thing though. Please yell if you disagree...
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
> Results are (mostly) independent of compiler optimisation, but testing with 
> an -O2 compile should be most useful. Thanks!

Since a lot of people reported timings for all the fancy new x86_64
hardware, I've not included those. Timings for my ancient machines still
in service:

$ gcc -o port80 -O2 port80.c
$ sudo ./port80
cycles: out 1736, in 1735
$ sudo ./port80
cycles: out 1831, in 1827
$ sudo ./port80
cycles: out 1735, in 1735
$ sudo ./port80
cycles: out 1743, in 1737
$ sudo ./port80
cycles: out 1737, in 1734

$ cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 6
model name      : AMD Athlon(tm) MP 1800+
stepping        : 2
cpu MHz         : 1533.420
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov
pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow ts
bogomips        : 3069.09
clflush size    : 32

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 6
model name      : AMD Athlon(tm) Processor
stepping        : 2
cpu MHz         : 1533.420
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov   pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow ts
bogomips        : 3067.07
clflush size    : 32


---

# ./port80
cycles: out 812, in 354
# ./port80
cycles: out 811, in 354
# ./port80
cycles: out 811, in 354
# ./port80
cycles: out 811, in 354

# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 1
cpu MHz         : 672.071
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 mmx fxsr sse
bogomips        : 1331.20


---


# ./port80
cycles: out 116, in 47
# ./port80
cycles: out 116, in 47
# ./port80
cycles: out 116, in 47
# ./port80
cycles: out 116, in 47

# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 5
model           : 2
model name      : Pentium 75 - 200
stepping        : 12
cpu MHz         : 99.476
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : yes
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr mce cx8
bogomips        : 198.24


P133 clocked at 100MHz


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbXLLSyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbXLLSyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbXLLSyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:54:47 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:61363 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbXLLSyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:54:46 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.165
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+lYpq00TX+8Wq0wYO2EIGT
Message-ID: <47602E71.1070000@reed.com>
Date: Wed, 12 Dec 2007 13:54:41 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
CC: Rene Herman <rene.herman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <47601A12.2040103@gmail.com>
In-Reply-To: <47601A12.2040103@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been having a fun time testing this on my AMD64x2 system.

Since out's to port 80 hang the system hard after a while, I can run a 
test just after booting, but the next run will typically hang it.

I did also test two ports thought to be unused.   They do *not* hang the 
system.  Thus apparently there is some device responding to port 80!

Running the (slightly modified to test 3 ports instead of just port 80) 
test when the CPU is running at 800 MHz, here's what I get for port 80 
and port ec and port ef.

port 80:   cycles: out 1430, in 792
port ef:    cycles: out 1431, in 1378
port ec:   cycles: out 1432, in 1372

[Note: port 80, when it doesn't hang, which is very often, responds to a 
read twice as fast as a port which is "not there".   Typically though, 
the second time I run the test, the system freezes solid.  Seems like 
evidence of a present device, not a missing one.  Also, port 80 responds 
when booted with acpi=off, but never seems to hang - sounds like ACPI 
causes it to be active in some way]
----------------------------

System info:  HP Pavilion dv9000z laptop (AMD64x2)

PCI bus controller is nVidia MCP51.
/proc/cpuinfo

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-60
stepping        : 2
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt rdtscp lm 3dnowext 3dnow rep_good pni cx16 lahf_lm cmp_legacy 
svm extapic cr8_legacy
bogomips        : 1608.35
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-60
stepping        : 2
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt rdtscp lm 3dnowext 3dnow rep_good pni cx16 lahf_lm cmp_legacy 
svm extapic cr8_legacy
bogomips        : 1608.35
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc


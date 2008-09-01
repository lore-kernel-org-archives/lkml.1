Return-Path: <linux-kernel-owner+w=401wt.eu-S1753618AbYIAOZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbYIAOZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYIAOZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:25:44 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:40438 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbYIAOZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:25:43 -0400
Date: Mon, 1 Sep 2008 16:25:49 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: mtrr madness
Message-ID: <20080901142549.GW25962@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 01 Sep 2008 16:25:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

it seems that all linux kernels contain a bug with mtrr:

 cat /proc/mtrr 
reg00: base=0x00000000 (   0MB), size=198656MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=197120MB: write-back, count=1
reg02: base=0x9fc00000 (2556MB), size=196612MB: uncachable, count=1
reg03: base=0x100000000 (4096MB), size=200704MB: write-back, count=1
reg04: base=0x200000000 (8192MB), size=204800MB: write-back, count=1

(watch the size)

it is definitely  present in the kernels 2.6.16, 2.6.24, 2.6.25, 2.6.26.

198656 is 0x3080000000, the correct value would be 0x80000000, similarly
197120 is 0x3020000000, the correct would be 0x20000000. 

cpu info:
processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz
stepping	: 11
cpu MHz		: 2992.510
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr dca lahf_lm
bogomips	: 5987.46
clflush size	: 64
cache_alignment	: 64
address sizes	: 38 bits physical, 48 bits virtual
power management:


-- 
Luká¹ Hejtmánek

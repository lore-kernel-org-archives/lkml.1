Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZEYImU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZEYImU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbZEYImF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:42:05 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:44780 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbZEYImE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:42:04 -0400
Message-ID: <4A1A59DD.7030101@wpkg.org>
Date: Mon, 25 May 2009 10:42:05 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: mingo@elte.hu, Alan <alan@lxorguk.ukuu.org.uk>,
       Gerd Hoffmann <kraxel@redhat.com>, jeremy@goop.org,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       JBeulich@novell.com, jbarnes@virtuousgeek.org
Subject: Re: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

>>>> Oops, the third "proper technical solutions" is missing.
>>>
>>> Yeah, the third one is to not touch MTRRs after bootup and use PAT.
>>
>> Works only in case the CPU has PAT support.
> 
> Which specific CPU without PAT support do you worry about?

Are these ones (below) good CPU to worry about? That's slightly 
off-topic as they are KVM guests, but still, the guest kernel seems to 
disable PAT (unless I'm mistaken).



KVM-86 + 2.6.27.19 guest:

# dmesg
Initializing cgroup subsys cpuset
Linux version 2.6.27.19-server-1mnb (qateam@titan.mandriva.com) (gcc 
version 4.3.2 (GCC) ) #1 SMP Thu Mar 5 00:09:04 EST 2009
PAT WC disabled due to known CPU erratum.
(...)

# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 2
model name      : QEMU Virtual CPU version 0.10.50
stepping        : 3
cpu MHz         : 2133.285
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu de pse tsc msr pae mce cx8 apic mtrr pge mca cmov 
pat pse36 clflush mmx fxsr sse sse2 syscall lm up pni
bogomips        : 4266.57
clflush size    : 64
power management:


KVM-85 + 2.6.29.1 guest:

# dmesg
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.29.1-server-4mnb (herton@n2.mandriva.com) (gcc version 
4.3.2 (GCC) ) #1 SMP Mon Apr 20 20:10:24 EDT 2009
KERNEL supported cpus:
   Intel GenuineIntel
   AMD AuthenticAMD
   NSC Geode by NSC
   Cyrix CyrixInstead
   Centaur CentaurHauls
   Transmeta GenuineTMx86
   Transmeta TransmetaCPU
   UMC UMC UMC UMC
PAT WC disabled due to known CPU erratum.
(...)

# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 2
model name      : QEMU Virtual CPU version 0.10.0
stepping        : 3
cpu MHz         : 2128.004
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu de pse tsc msr pae mce cx8 apic mtrr pge mca cmov 
pat pse36 clflush mmx fxsr sse sse2 syscall nx lm up pni hypervisor
bogomips        : 4256.00
clflush size    : 64
power management:



-- 
Tomasz Chmielewski
http://wpkg.org


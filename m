Return-Path: <linux-kernel-owner+w=401wt.eu-S935875AbXGWUcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935875AbXGWUcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933007AbXGWUc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:32:28 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33554 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762318AbXGWUc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:32:27 -0400
Date: Mon, 23 Jul 2007 22:33:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Alan Modra <amodra@bigpond.net.au>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
Message-ID: <20070723203340.GA8581@uranus.ravnborg.org>
References: <20070723193923.GL21668@ftp.linux.org.uk> <20070723200500.3BBF94D058D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723200500.3BBF94D058D@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 01:05:00PM -0700, Roland McGrath wrote:
> > On Mon, Jul 23, 2007 at 12:12:15PM -0700, Roland McGrath wrote:
> > > > rm vmlinux*; time make vmlinux
> > > > 
> > > > Vanilla tree: ~7,7 sec
> > > > With single shot ld (Roland's patch): 8,3 secs
> > > 
> > > Shouldn't you compare:
> > > 	rm vmlinux*; find . -name built-in.o -print | xargs rm
> > > 	time make vmlinux
> > > or something like that?
> > 
> > No.  You are talking about the time of full build; there it would
> > be relevant.  For incrementals it's definitely not so.
> 
> Ah, I see what you are testing.  Well, a fair test then is to do something
> that would actually happen, which is almost never just "rm vmlinux".
> i.e., at least one ld -r -o foo/built-in.o from changing one source file.

The normal case is one change somewhere => build kernel.
That can be tested by a simple
rm mm/memory.o; /usr/sbin/time make vmlinux

I will try that later.
For now I'm building an allyesconfig just to see if the build actually completes.
It is quite a number of .o files to link in one go and I fear ld will blow up 
and make my machine go OOM.

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 75
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
stepping	: 2
cpu MHz		: 2000.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8_legacy
bogomips	: 4011.99
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 75
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
stepping	: 2
cpu MHz		: 2000.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8_legacy
bogomips	: 4011.99
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

meminfo:
MemTotal:      1027044 kB
MemFree:         83040 kB
Buffers:          4996 kB
Cached:         510208 kB
SwapCached:          0 kB
Active:         447092 kB
Inactive:       406620 kB
SwapTotal:     3004112 kB
SwapFree:      2965072 kB
Dirty:          107740 kB
Writeback:           0 kB
AnonPages:      338528 kB
Mapped:          62552 kB
Slab:            50684 kB
SReclaimable:    30132 kB
SUnreclaim:      20552 kB
PageTables:      13688 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   3517632 kB
Committed_AS:   749456 kB
VmallocTotal: 34359738367 kB
VmallocUsed:     40636 kB
VmallocChunk: 34359695867 kB

	Sam

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbYCYR4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbYCYR4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbYCYR4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:56:13 -0400
Received: from n75.bullet.mail.sp1.yahoo.com ([98.136.44.51]:25132 "HELO
	n75.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753744AbYCYR4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:56:12 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 59141.72871.bm@omp101.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=5SE+vz4witOOXMH0UepW/zl1w69a1Z3xBwXso8daZG3WrcsPABN0HrtA47Jc3AP8yAJK2fumepCxH1chk6MiUXAZn3JunSX7fZVGnSlNsvnMvUO111Qy/HBS16Za353xpxTbaNJrR6juMzqY29EX1IE29lXOabEbIHXDEETzE+k=;
X-YMail-OSG: gXZfZggVM1k00S1XQ80wSzJlnquGbc008_KpSq6WziXHWA1pZ5LqQ3k9SXUMl7KS6VLZ_8_.r2Fyry52OSMViSJMQlgQ.8h0i4XHLvrAGIywjsMJoptaGqA_HDM-
Date: Tue, 25 Mar 2008 18:56:05 +0100 (CET)
From: Michael Meyer <mike65134@yahoo.de>
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 > /sys/devices/system/cpu/cpu1/online"
To: Wander Winkelhorst <w.winkelhorst@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <5699f8f00803251049s1823098u86b5431eadad2917@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <399637.85588.qm@web25801.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Wander Winkelhorst <w.winkelhorst@gmail.com>
schrieb:

> On Tue, Mar 25, 2008 at 6:23 PM, Michael Meyer
> <mike65134@yahoo.de> wrote:
> >
> >  --- Andi Kleen <andi@firstfloor.org> schrieb:
> >
> >
> >  > Luciano Rocha <luciano@eurotux.com> writes:
> >  >
> >  > > On Tue, Mar 25, 2008 at 02:47:50PM +0100,
> Michael
> >  > Meyer wrote:
> >  > > > Hi,
> >  > > >
> >  > > > what is the difference between booting a
> dual
> >  > core
> >  > > > machine with "maxcpus=1" or by deactivating
> the
> >  > second
> >  > > > core at run time with "echo 0 >
> >  > > > /sys/devices/system/cpu/cpu1/online"?
> >  > >
> >  > > maxcpus=1 should turn off the SMP alternative
> and
> >  > switch to UP only,
> >  > > optimising some locks and instructions.
> >  >
> >  > CPU hot unplug will do the same. But it is
> unlikely
> >  > it accounts
> >  > for that much performance difference.
> >  >
> >  > If he used maxcpus=0 it would make sense.
> maxcpus=0
> >  > disables
> >  > the IO-APIC which likely makes a large
> difference.
> >  > But it should
> >  > be actually slower.
> >  >
> >  > There should be actually no difference in
> theory
> >  > between max_cpus=1
> >  > and hot unplug to one CPU. Might be some bug.
> >
> >  I had the following time values:
> >
> >  maxcpus=1:
> >  real    0m1.642s
> >  user    0m1.528s
> >  sys     0m0.068s
> >
> >  maxcpus=2 and
> >  echo 1 > /sys/devices/system/cpu/cpu1/online:
> >  real    0m2.579s
> >  user    0m4.096s
> >  sys     0m0.160s
> >
> >  maxcpus=2 and
> >  echo 0 > /sys/devices/system/cpu/cpu1/online:
> >  real    0m3.757s
> >  user    0m3.632s
> >  sys     0m0.112s
> >
> >
> 
> What kind of CPU are you using? Some Intel CPU's do
> "funny stuff",
> like dynamically overclocking itself when working on
> a single thread,
> or using all of the 2nd level cache instead of
> sharing it with the
> second core.
> 
> Regards,
> Wander Winkelhorst.
> 

Intel Core 2 Duo E6600 (2.4 Ghz). I do not think that
it is capable of dynamically overclocking.

$ cat /proc/cpuinfo 
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU          6600  @
2.40GHz
stepping	: 6
cpu MHz		: 1600.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep
mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr
sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon
pebs bts pni monitor ds_cpl vmx est tm2 ssse3 cx16
xtpr lahf_lm
bogomips	: 4791.87
clflush size	: 64

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU          6600  @
2.40GHz
stepping	: 6
cpu MHz		: 1600.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep
mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr
sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon
pebs bts pni monitor ds_cpl vmx est tm2 ssse3 cx16
xtpr lahf_lm
bogomips	: 4788.35
clflush size	: 64





      E-Mails jetzt auf Ihrem Handy.
www.yahoo.de/go


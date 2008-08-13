Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYHMUXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYHMUXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYHMUXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:23:24 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:26121 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbYHMUXU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:23:20 -0400
X-BigFish: VPS-59(z21eWz1432R98dR1805M936fQ1433M9371Pzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K5K3AB-02-NHD-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Linux 2.6.27-rc3
Date: Wed, 13 Aug 2008 15:23:09 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC6C@sausexmb4.amd.com>
In-Reply-To: <64bb37e0808131318j81ba372t8a5f089e33f1dc32@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Linux 2.6.27-rc3
Thread-Index: Acj9geBu5IGm5vaFT2eumL2CqlqgqgAAC49Q
References: <alpine.LFD.1.10.0808121914270.3462@nehalem.linux-foundation.org> <64bb37e0808131318j81ba372t8a5f089e33f1dc32@mail.gmail.com>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
CC: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 13 Aug 2008 20:23:10.0547 (UTC) FILETIME=[67954230:01C8FD82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Aug 13, 2008 at 4:33 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Things really _have_ calmed down, and hopefully we've also 
> resolved a lot
> > of the regressions in -rc3.
> 
> I found a new one in -rc3 vs. -rc2.
> Only one of my cpus seems to powered down by cpufreq, because the
> topology gets filled out wrong:
> 
> correct with -rc2:
> #grep . /sys/devices/system/cpu/cpu*/cpufreq/affected_cpus
> /sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:0 1
> /sys/devices/system/cpu/cpu1/cpufreq/affected_cpus:0 1
> /sys/devices/system/cpu/cpu2/cpufreq/affected_cpus:2 3
> /sys/devices/system/cpu/cpu3/cpufreq/affected_cpus:2 3
> (The system has 2 dual core Opterons)
> 
> wrong with -rc3:
> #grep . /sys/devices/system/cpu/cpu*/cpufreq/affected_cpus
> /sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:0 1
> /sys/devices/system/cpu/cpu1/cpufreq/affected_cpus:0 1
> /sys/devices/system/cpu/cpu2/cpufreq/affected_cpus:0 1
> /sys/devices/system/cpu/cpu3/cpufreq/affected_cpus:0 1
> 
> I bisected this bug down to these commits:
> > Mark Langsdorf (2):
> >      [CPUFREQ][1/2] whitespace fix for powernow-k8
> >      [CPUFREQ][2/2] preregister support for powernow-k8

Well, that patch is likely going to get reverted because
it's causing a crash on Rafael's test box.

But before that happens, could you send me the disassembled
dump of your ACPI objects?  Iti's possible the code is wrong,
but it's also possible that your BIOS is passing a broken
_PSD.

-Mark Langsdorf
Operating System Research Center
AMD


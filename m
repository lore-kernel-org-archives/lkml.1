Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZBKGnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZBKGnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 01:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZBKGm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 01:42:56 -0500
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:51442
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZBKGmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 01:42:55 -0500
Date: Wed, 11 Feb 2009 15:42:53 +0900
From: Mattia Dongili <malattia@linux.it>
To: Guilherme Malschitzky Schroeder <guilherme.m.schroeder@gmail.com>
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       CPUFreq Mailing List <cpufreq@lists.linux.org.uk>,
       ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: ACPI regression in 2.6.29 - cpufreq_performance doesn't work
Message-ID: <20090211064253.GC641@kamineko.org>
References: <cc0fa41f0902091953y2ab718fcmdbd1c42acf270e08@mail.gmail.com> <20090210045803.GA31755@kamineko.org> <cc0fa41f0902092215i44823962t39033f6b987f273f@mail.gmail.com> <20090210110802.GB31755@kamineko.org> <cc0fa41f0902101810m77d7054ar7df7b3804cc61e66@mail.gmail.com> <cc0fa41f0902101815s149b3b06mb3fbb72363b49765@mail.gmail.com> <20090211051017.GA641@kamineko.org> <cc0fa41f0902102158y146aa60dmcddbe4c6be2ad56f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc0fa41f0902102158y146aa60dmcddbe4c6be2ad56f@mail.gmail.com>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.26-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 03:58:07AM -0200, Guilherme Malschitzky Schroeder wrote:
> On Wed, Feb 11, 2009 at 3:10 AM, Mattia Dongili <malattia@linux.it> wrote:
> > On Wed, Feb 11, 2009 at 12:15:35AM -0200, Guilherme Malschitzky Schroeder wrote:
...
> > Ha! can you check the value for
> > /sys/devices/system/cpu/cpu{0,1}/cpufreq/related_cpus
> > ?

errr... sorry, I meant to say
/sys/devices/system/cpu/cpu{0,1}/cpufreq/affected_cpus

> > or even include the full output of cpufreq-info with both kernels.

anyway from this you can see that there is actually a change
(cpufreq-info reads from affected_cpus and in 2.6.28
sys/.../cpu1/cpufreq should be a link to ../cpu0/cpufreq):

> Here it's:
> 
> 2.6.28.4
...
> # cpufreq-info
> cpufrequtils 004: cpufreq-info (C) Dominik Brodowski 2004-2006
> Report errors and bugs to cpufreq@lists.linux.org.uk, please.
> analyzing CPU 0:
>   driver: acpi-cpufreq
>   CPUs which need to switch frequency at the same time: 0 1
...
> 2.6.29-rc4
...
> # cpufreq-info
> cpufrequtils 004: cpufreq-info (C) Dominik Brodowski 2004-2006
> Report errors and bugs to cpufreq@lists.linux.org.uk, please.
> analyzing CPU 0:
>   driver: acpi-cpufreq
>   CPUs which need to switch frequency at the same time: 0
...
> analyzing CPU 1:
>   driver: acpi-cpufreq
>   CPUs which need to switch frequency at the same time: 1

So I guess you have one of those bioses that prefer sw coordination if
not told to use hw's as explained in the commit message.
And cpufreq-set behaves as it always did ;)

...
> >> >> >> commit d96f94c604453f87fe24154b87e1e9a3a72511f8
> >> >> >> Author: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
> >> >> >> Date:   Mon Feb 2 11:57:18 2009 -0800
> >> >> >>
> >> >> >>     ACPI: Enable bit 11 in _PDC to advertise hw coord
> >> >> >>
> >> >> >>     Bit 11 in intel PDC definitions is meant for OS capability to handle
> >> >> >>     hardware coordination of P-states. In Linux we have always supported
> >> >> >>     hwardware coordination of P-states. Just let the BIOSes know that we
> >> >> >>     support it, by setting this bit.
> >> >> >>
> >> >> >>     Some BIOSes use this bit to choose between hardware or software coordination
> >> >> >>     and without this change below, BIOSes switch to software coordination, which
> >> >> >>     is not very optimal in terms of power consumption and extra
> >> >> >> wakeups from idle.
> >> >> >>
> >> >> >>     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> >> >> >>     Signed-off-by: Len Brown <len.brown@intel.com>

-- 
mattia
:wq!

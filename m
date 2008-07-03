Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYGCQWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYGCQWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 12:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbYGCQWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 12:22:43 -0400
Received: from xsmtp0.ethz.ch ([82.130.70.14]:1721 "EHLO XSMTP0.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYGCQWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:22:42 -0400
Message-ID: <486CFCD0.3080109@debian.org>
Date: Thu, 03 Jul 2008 18:22:40 +0200
From: "Giacomo A. Catenazzi" <cate@debian.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       linux-kernel@vger.kernel.org, Simon Trimmer <simon@urbanmyth.org>
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New	World
 Order firmware...
References: <4534.1215048758@turing-police.cc.vt.edu>	 <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet>	 <32146.1215066947@turing-police.cc.vt.edu>	 <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet>	 <486C9AD2.6020604@debian.org>  <20080703065630.2aefc930@infradead.org> <1215100465.10393.585.camel@pmac.infradead.org>
In-Reply-To: <1215100465.10393.585.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2008 16:22:40.0656 (UTC) FILETIME=[03C2E100:01C8DD29]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[recipient clean-up and adding Simon]

David Woodhouse wrote:
> On Thu, 2008-07-03 at 06:56 -0700, Arjan van de Ven wrote:
>> On Thu, 03 Jul 2008 11:24:34 +0200
>> "Giacomo A. Catenazzi" <cate@debian.org> wrote:

> Actually there are three:
> 
> 1. The text format 'microcode.dat', including updates for all CPUs.
> 2. The binary format output by microcode_ctl, still including all CPUs.
> 3. The smaller files with just the relevant subset of #2.

we are diverging :-(

The #2 is not on upstream microcode_ctl. BTW Debian/Ubuntu already
diverge a lot in respect of upstream.
Further, IIRC, Simon slowed/stopped developing microcode_ctl, because
he think (IIRC) that distributions used other solutions or going to
use #3.

So if we need #2, I really want Simon (or someone) that take care
of continuing microcode_ctl upstream and merging distribution
patches.

> The kernel (since 2006) can actually take either #2 or #3. The udev
> scripts I just posted will use microcode_ctl to feed it #2, when they
> find #1 on the file system.


#1 and #2 have some problem in Debian/Ubuntu:
- microcode_ctl is in /usr
- it require a module, so we load the module and we wait that
   the device is created (it is asynchronous)
- initram would require an additional program, to an early load
- split on architectures [32/64bit CPU] (but this is an internal
   autobuild / non-free Debian problem)

> 
> A small amount of extra work in the userspace tool would let those udev
> scripts feed #3 to the kernel, and then the code in the kernel to select
> the appropriate update could be removed.

I don't think Intel want this solution.
Earlier Intel preferred to give us two version of microcode
(new and old kernel) instead of let us to filter out one
short microcode, which trigged a kernel bug.

I'm ready to do such script (really I've already
a similar tool)


> 
>>> Actually Intel provides only the old methods.
>>> There was talks with Arjan and Intel about the distribution format
>>> for the new methods. But I don't have any new.
>>> I think that when the new format is fully specified (directory
>>> structure, tar, gzip,...) Intel will distribute the microcodes
>>> in the new form.
> 
> Doesn't the "new format" (#3) involve hard links too, since there are
> some cases where the same microcode update applies to more than one CPU
> revision?

no, I don't think. Intel documentation on BIOS writing, document
that microcode should be discarded if the header information don't
match with current CPU.  I didn't checked if some microcode
contains same data with different header (which anyway is not feeded
to the CPU)

> 
>> we hope to switch to the new form but there's the small case of
>> "installed base" using ancient kernels, and it's kind of not nice to
>> have to release 2 sets. At some point we will switch over though.
> 
> Do we really need to _ship_ it in a different form? It's not exactly
> hard to convert from the text form (#1) to either of the other two --
> either on the fly in udev scripts, or at installation time.

It was a personal interpretation of Intel wishes.

ciao
	cate

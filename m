Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbZFHIAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbZFHIAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZFHIAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:00:14 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:38192 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZFHIAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:00:13 -0400
Date: Mon, 8 Jun 2009 15:53:12 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: e_powersaver driver considered DANGEROUS (was Re: Linux 2.6.30-rc8
	[also: VIA Support])
Message-ID: <20090608075312.GK4106@prithivi.gnumonks.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090606132847.GB14088@prithivi.gnumonks.org> <200906060846.36303.lkml@morethan.org> <200906060856.15016.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906060856.15016.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Michael and others,

On Sat, Jun 06, 2009 at 08:56:12AM -0500, Michael S. Zick wrote:

> > > > The mainstream kernel, e_powersaver, is *under-clocking* my machine -
> > > > 
> > > > The cpuid instruction provides the minimum and maximum GSF values 
> > > > (Guaranteed Stable Frequency) for that processor mask run -
> > > > Passing that on as the lower and upper limits to e_powersaver should
> > > > stop that problem.  Will be testing this RSN.
> > > 
> > > It's really surprising to me that none of this seems to be handled correct so
> > > far, I'll talk to Centaur and try to find out how we could have ended up in
> > > this situation.
> > >
> > 
> > Ah, but we are talking here of the *second* NetBook ever produced.
> > If one is to believe the dmidecode output - it is using the VIA demo board
> > BIOS. 
> > 
> > I bet the demo board BIOS is intended to demo the features of the product -
> > not the correctness or completeness of the ACPI support.  ;)

So I've just been told the VIA reference BIOS has full support for the
processor p-state support.  I'd therefore suppose every production BIOS
contains that code, too.  The kernel should never use a native driver such as
e_powersaver on any C7 or Nano system, but use the ACPI provided
tables/methods, which are intel compatible.  A native driver would only be
needed on really old C3 systems. 

The e_powersaver.c driver neither respects the maximum/minimum frequency
constraints specified in the MSR's, nor does it take care of the inflection
ratio, parallax and other advanced stuff that C7 and Nano are doing in this
area.

I would consider the e_powersaver driver DANGEROUS on any C7 or Nano system,
i.e. on every system it supports.  It is bound to cause system instability,
as it will most likely operate the CPU out of spec on virtually every system.

I'll do some actual testing on getting the intel-compatible ACPI method
for p-states working on my c7 and nano demo boards, and submit any patches
(if required).

I'll also meanwhile submit a patch to mark e_powersaver as DANGEROUS and
EXPERIMENTAL.

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison

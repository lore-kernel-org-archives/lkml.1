Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbZFDSNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbZFDSNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbZFDSMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:12:47 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:53524 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbZFDSMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:12:46 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Thu, 4 Jun 2009 13:12:43 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906041121.30845.lkml@morethan.org> <20090604174059.GB9823@prithivi.gnumonks.org>
In-Reply-To: <20090604174059.GB9823@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041312.45847.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu June 4 2009, Harald Welte wrote:
> On Thu, Jun 04, 2009 at 11:21:28AM -0500, Michael S. Zick wrote:
> 
> > That is one of my pending questions - -
> > (It is included as a comment at the appropriate point in my patchset.)
> > 
> > The VIA processors have MCR's not MTRR's - -
> 
> AFAIK, that was true for processors like the Winhcip / C6, i.e. earlier than
> the C3.  The C3, C7 and later support 8 intel-style MTRR's.
> 

Super!  A specific breakage!

The c7 setup code is re-using the c6 setup code (MCR's) - -
Will "if 0" out the appropriate parts and arrange for the MTRR setup.

@Linus - -
The Debian/Ubuntu distribution kernels require irqpoll (2.6.28+) -
I took that out very early in my testing, when that problem got fixed -
I will also try putting that back in, it might be needed for
some of its side-effects on the processor/chipset.

> > The C7-M processor uses "in-order retirement" not "out-of-order" - -
> > I think the MCR's **should not** be set for "weak ordered writes" -
> 
> why would it matter on UP? as indicated, I'm not the expert here, but I thought
> memory ordering issues only arise in SMP systems [or possibly with regard to
> DMA, but as we already explored much earlier in this thread, drivers that access
> DMA buffers whil the hardware owns them are buggy and need to be fixed]
> 

I just recall the problems with the pa-risc port (not all machines have coherent I/O);
some have consistent I/O only.  I have one of those also, lucky me. ;)

Mike
> Regards,



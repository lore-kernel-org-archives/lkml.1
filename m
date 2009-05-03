Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbZECOwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbZECOwa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 10:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbZECOwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 10:52:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:59186 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbZECOwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 10:52:20 -0400
Date: Sun, 3 May 2009 07:53:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Willy Tarreau <w@1wt.eu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Specific support for Intel Atom architecture
Message-ID: <20090503075346.63fc7211@infradead.org>
In-Reply-To: <20090503053821.GI570@1wt.eu>
References: <200904301408.09370.tobias.doerffel@gmail.com>
	<20090430154051.GA3346@elte.hu>
	<49F9DB70.2050906@zytor.com>
	<20090503053821.GI570@1wt.eu>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 May 2009 07:38:23 +0200
Willy Tarreau <w@1wt.eu> wrote:

> On Thu, Apr 30, 2009 at 10:10:08AM -0700, H. Peter Anvin wrote:
> > Ingo Molnar wrote:
> > >> diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
> > >> index 80177ec..07a11b0 100644
> > >> --- a/arch/x86/Makefile_32.cpu
> > >> +++ b/arch/x86/Makefile_32.cpu
> > >> @@ -33,6 +33,7 @@ cflags-$(CONFIG_MCYRIXIII)	+= $(call
> > >> cc-option,-march=c3,-march=i486) $(align)-f
> > >> cflags-$(CONFIG_MVIAC3_2)	+= $(call
> > >> cc-option,-march=c3-2,-march=i686)
> > >> cflags-$(CONFIG_MVIAC7)		+= -march=i686
> > >> cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call
> > >> tune,core2) +cflags-$(CONFIG_MATOM)		+=
> > >> -march=atom $(call tune,atom) 
> > 
> > There should be a fallback option used here rather than requiring a
> > new gcc, e.g. something like:
> > 
> > $(call cc-option,-march=atom,-march=i686)
> 
> if it's an in-order architecture, wouldn't it be better to tune for
> i386 or i486 instead ?

-march isn't about tuning, it's about supported instructions.
The right line is
$(call cc-option,-march=atom,-march=core2)

For tuning, our experience is that currently -mtune=generic works best.
Not sure about the gcc's that have complete atom tuning support yet.

Please don't do something like "oh it's in order, so was the Pentium,
so lets use that"; it actually gives really really bad results.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

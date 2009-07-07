Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbZGGMiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbZGGMiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 08:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbZGGMhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 08:37:52 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:26917 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbZGGMhv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 08:37:51 -0400
X-IronPort-AV: E=Sophos;i="4.42,362,1243828800"; 
   d="scan'208";a="3534464"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: PREEMPT_ACTIVE too low error with all asm-generic headers for some arches
Date: Tue, 7 Jul 2009 08:41:14 -0400
User-Agent: KMail/1.9.5
CC: "Mike Frysinger" <vapier.adi@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <8bd0f97a0906231508s4c115d3dr2848626bc5a28c5e@mail.gmail.com> <8bd0f97a0906241521s23c0d3bes56398a3333d4ee57@mail.gmail.com> <8bd0f97a0907041543w5f173e11vf358d5b36c0659b3@mail.gmail.com>
In-Reply-To: <8bd0f97a0907041543w5f173e11vf358d5b36c0659b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <200907070841.15127.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 07 Jul 2009 12:37:54.0537 (UTC) FILETIME=[BFD62D90:01C9FEFF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 4 Jul 2009 18:43, Mike Frysinger pondered:
> On Wed, Jun 24, 2009 at 18:21, Mike Frysinger wrote:
> > On Wed, Jun 24, 2009 at 11:02, Mike Frysinger wrote:
> >> On Wed, Jun 24, 2009 at 10:02, Arnd Bergmann wrote:
> >>> --- a/include/linux/hardirq.h
> >>> +++ b/include/linux/hardirq.h
> >>> @@ -62,6 +62,12 @@
> >>>  #define HARDIRQ_OFFSET (1UL << HARDIRQ_SHIFT)
> >>>  #define NMI_OFFSET     (1UL << NMI_SHIFT)
> >>>
> >>> +#ifndef PREEMPT_ACTIVE
> >>> +#define PREEMPT_ACTIVE_BITS    1
> >>> +#define PREEMPT_ACTIVE_SHIFT   (NMI_SHIFT + NMI_BITS)
> >>> +#define PREEMPT_ACTIVE (__IRQ_MASK(PREEMPT_ACTIVE_BITS) << PREEMPT_SHIFT)
> >>
> >> i think you meant "<< PREEMPT_ACTIVE_SHIFT" there.  once i make that
> >> change, it builds fine.
> >
> > and like Ingo, with that fix, add my Acked-by
> >
> > thanks !
> 
> could you push this to Linus ?  or should i throw something into the
> Blackfin headers in the meantime ?

Yeah, this is causing build failures on Linux 2.6.31-rc2 for Blackfin.

In file included from include/linux/interrupt.h:12,
                 from include/linux/kernel_stat.h:8,
                 from arch/blackfin/kernel/asm-offsets.c:32:
include/linux/hardirq.h:66:2: error: #error PREEMPT_ACTIVE is too low!
make[1]: *** [arch/blackfin/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

Which the above patch makes go away...


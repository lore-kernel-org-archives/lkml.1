Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbZJTXCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbZJTXCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 19:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZJTXCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 19:02:38 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:2256 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbZJTXCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 19:02:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19166.16775.583244.140972@pilspetsen.it.uu.se>
Date: Wed, 21 Oct 2009 01:02:31 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
       Mikael Pettersson <mikpe@it.uu.se>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] Make MIPS dynamic clocksource/clockevent clock code generic v2
In-Reply-To: <1256078002-27919-1-git-send-email-linus.walleij@stericsson.com>
References: <1256078002-27919-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij writes:
 > This moves the clocksource_set_clock() and clockevent_set_clock()
 > from the MIPS timer code into clockchips and clocksource where
 > it belongs. The patch was triggered by code posted by Mikael
 > Pettersson duplicating this code for the IOP ARM system. The
 > function signatures where altered slightly to fit into their
 > destination header files, unsigned int changed to u32 and inlined.
 > 
 > Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
 > Cc: Thomas Gleixner <tglx@linutronix.de>
 > Tested-by: Mikael Pettersson <mikpe@it.uu.se>
 > Reviewed-by: Ralf Baechle <ralf@linux-mips.org>
 > ---
 > Changes v1->v2:
 > - Fixed Mikaels comments: spelling, terminology.
 > - Kept the functions inline: all uses and foreseen uses
 >   are once per kernel and all are in __init or __cpuinit sections.
 > - Unable to break out common code - the code is not common and
 >   implementing two execution paths will be more awkward.
 > - Hoping the tglx likes it anyway.

Very minor spelling nits below.

 > --- a/include/linux/clockchips.h
 > +++ b/include/linux/clockchips.h
 > @@ -115,6 +115,28 @@ static inline unsigned long div_sc(unsigned long ticks, unsigned long nsec,
 >  	return (unsigned long) tmp;
 >  }
 >  
 > +/**
 > + * clockevent_set_clock - calculates an appropriate shift
 > + *			  and mult values for a clockevent given a

can't have 'an' and a plural form, so s/an //

 > --- a/include/linux/clocksource.h
 > +++ b/include/linux/clocksource.h
 > @@ -257,6 +257,28 @@ static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
 >  }
 >  
 >  /**
 > + * clocksource_set_clock - calculates an appropriate shift
 > + *			   and mult values for a clocksource given a

ditto

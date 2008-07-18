Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbYGRWnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbYGRWnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756457AbYGRWn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:43:29 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:34415 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753909AbYGRWn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:43:29 -0400
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
From: Zachary Amsden <zach@vmware.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <Pine.LNX.4.55.0807182254270.12125@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0807161837080.30858@cliff.in.clinika.pl>
	 <20080718105259.GY6875@elte.hu>
	 <86802c440807180925t6fadfa58r6bf7740f8145482e@mail.gmail.com>
	 <86802c440807181001h4426c197vc474f81497a5b42@mail.gmail.com>
	 <20080718210348.GB24373@elte.hu>
	 <86802c440807181413n7e79e821l90afaae86b322de9@mail.gmail.com>
	 <Pine.LNX.4.55.0807182254270.12125@cliff.in.clinika.pl>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 15:42:17 -0700
Message-Id: <1216420937.30348.30.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 15:02 -0700, Maciej W. Rozycki wrote:
> On Fri, 18 Jul 2008, Yinghai Lu wrote:
> 
> >   CC      arch/x86/kernel/apic_64.o
> > arch/x86/kernel/apic_64.c:170: error: unknown field 'write_atomic'
> > specified in initializer
> > arch/x86/kernel/apic_64.c:170: error: 'native_apic_mem_write_atomic'
> > undeclared here (not in a function)
> > arch/x86/kernel/apic_64.c:209: error: unknown field 'write_atomic'
> > specified in initializer
> > arch/x86/kernel/apic_64.c:209: warning: initialization from
> > incompatible pointer type
> > make[1]: *** [arch/x86/kernel/apic_64.o] Error 1
> > make: *** [arch/x86/kernel] Error 2
> 
>  Just remove the offending initialisers.  They are not needed anymore as
> the .write method is now used universally including places where
> .write_atomic was.  I just could not stand watching the thing
> proliferate...

Thank you for cleaning this up Yinghai, but this really begs the
question - is having write_atomic REALLY worthwhile?

Intel themselves have not supported the affected processors since
October 17, 2000, and here we are writing code for it, when the last
processor with such a flaw (C2 or cB1 stepping Pentium) was stamped in
1995, over 13 years ago.  It might have been relevant when Linus was
developing SMP support in '96, but it isn't now.

In fact, anyone running a 120 Mhz or 133 Mhz Pentium processor that has
been obsoleted for 8 years should at this point be shot for wasting
energy with their poor megawatt/megaflop ratio, doubly so if they can
claim to be doing so in some kind of SMP scenario which even requires
using an APIC at all.

Seriously, please consider removing all of the flaming crap surrounding
apic_write_around entirely and forcing users who compile for less than
686 processors to just not have official support for local APIC at all,
or just default it off and let people turn it on at own risk.

Zach


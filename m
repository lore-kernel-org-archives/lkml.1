Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbYAICe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbYAICe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbYAICes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:34:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58828 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbYAICes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:34:48 -0500
Date: Wed, 9 Jan 2008 03:37:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Russell Leidich <rml@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       valdis.kletnieks@vt.edu, Tim Hockin <thockin@google.com>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Message-ID: <20080109023714.GK2117@one.firstfloor.org>
References: <3f1a065b0801021350x7fd065fbj9680ce1a4f3c6538@mail.gmail.com> <20080102215433.GB13784@one.firstfloor.org> <3f1a065b0801041333x579d0a8fs9c5535f95dd56015@mail.gmail.com> <20080104222637.GA19248@one.firstfloor.org> <3f1a065b0801041653y77c27a8cvce703cb7d13e10a0@mail.gmail.com> <20080105132402.GA705@one.firstfloor.org> <3f1a065b0801051208y7e832e8ctda61f28e6328dec3@mail.gmail.com> <3f1a065b0801081542p6cca6249g35e83f7e1f450fbd@mail.gmail.com> <20080108235212.GE2117@one.firstfloor.org> <3f1a065b0801081828y4b084a52g1db9bcb8821cb3da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f1a065b0801081828y4b084a52g1db9bcb8821cb3da@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 06:28:18PM -0800, Russell Leidich wrote:
> On Jan 8, 2008 3:52 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > >  ENTRY(thermal_interrupt)
> > > -     apicinterrupt THERMAL_APIC_VECTOR,smp_thermal_interrupt
> > > +     apicinterrupt THERMAL_APIC_VECTOR,smp_thermal_interrupt(%rip)
> >
> > Are you sure a * is not needed?  I would have thought it would jump
> > to the variable instead of through it. But if it works it's ok for me.
> 
> I will test to make sure it works.  I don't think stars mean anything
> in AT&T-style X86-64.

% cat t.s
        call foo
        call *foo
% as -o t.o t.s
% objdump -S t.o

t.o:     file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <.text>:
   0:   e8 00 00 00 00          callq  0x5
   5:   ff 14 25 00 00 00 00    callq  *0x0

-Andi

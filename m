Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbZBSQLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbZBSQLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 11:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZBSQL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 11:11:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:57146 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbZBSQL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 11:11:26 -0500
Subject: Re: Definition of BUG on x86
From: Petr Tesarik <ptesarik@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090219153544.GA31637@elte.hu>
References: <499C4786.5010504@goop.org>
	 <1235043648.15053.35.camel@nathan.suse.cz> <20090219121027.GB1703@elte.hu>
	 <1235045971.15053.42.camel@nathan.suse.cz> <20090219122211.GE1703@elte.hu>
	 <1235047082.15053.49.camel@nathan.suse.cz> <20090219124702.GC22044@elte.hu>
	 <1235048535.15053.52.camel@nathan.suse.cz> <20090219144902.GA8650@elte.hu>
	 <499D7B9D.7060001@goop.org>  <20090219153544.GA31637@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Thu, 19 Feb 2009 17:11:23 +0100
Message-Id: <1235059883.15053.68.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar píše v Čt 19. 02. 2009 v 16:35 +0100:
>[...]
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Ingo Molnar wrote:
> >> * Petr Tesarik <ptesarik@suse.cz> wrote:
> >>
> >>   
> >>> Ingo Molnar píše v Čt 19. 02. 2009 v 13:47 +0100:
> >>>     
> >>>> so GCC should be fixed and improved here, on several levels.
> >>>>       
> >>> Agree.
> >>>
> >>> But it takes some time, even if we start pushing right now. What's 
> >>> your suggestion for the meantime? Keep the dummy jmp? And in case 
> >>> anybody is concerned about saving every byte in the text section, 
> >>> they can apply my dirty patch?
> >>>
> >>> Actually, this doesn't sound too bad.
> >>>     
> >>
> >> yeah. Please forward the problem to the appropriate GCC list in any 
> >> case.
> >>
> >>   
> >
> > I think the official answer for this case is to use __builtin_trap.  But:
> >
> > -- Built-in Function: void __builtin_trap (void)
> >     This function causes the program to exit abnormally.  GCC
> >     implements this function by using a target-dependent mechanism
> >     (such as intentionally executing an illegal instruction) or by
> >     calling `abort'.  ***The mechanism used may vary from release to
> >     release so you should not rely on any particular implementation.***
> >
> > which in principle is hard for us to make use of.  In practice I think  
> > it has always been ud2a on x86.
> 
> could we just do:
> 
> 	__builtin_trap();
> 	for (;;);

I'm afraid that's not the point of the exercise. I'm trying to trim
BUG() to two bytes, while still making sure that the Illegal Opcode
exception is generated at the exact code point, so we can track it down
using the info in __bug_table. If __builtin_trap() ever translates to
anything else than ud2a in the above code snippet, there will be no BUG
reported. Instead, the CPU that encountered the BUG() will burn CPU
cycles forever without any apparent reason.

NAK,
Petr Tesarik


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYHVUz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYHVUz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYHVUzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:55:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37146 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYHVUzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:55:07 -0400
Date: Fri, 22 Aug 2008 16:55:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ftraced and suspend to ram
In-Reply-To: <200808222252.12547.rjw@sisk.pl>
Message-ID: <alpine.DEB.1.10.0808221651350.15941@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <20080822104610.GA3482@elf.ucw.cz> <alpine.DEB.1.10.0808221632410.14231@gandalf.stny.rr.com> <200808222252.12547.rjw@sisk.pl>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 22 Aug 2008, Rafael J. Wysocki wrote:
> > > tracing. Certainly all the assembly functions.
> > 
> > I'm looking into that now too. Are the functions in arch/x86/power/cpu*.c 
> > the suspend to ram code?
> 
> They contain code executed during suspend to RAM, but such code is also:
> - in all files under arch/x86/kernel/acpi/
> - in main.c, console.c under kernel/power
> - in all files under drivers/acpi/sleep
> - in drivers/acpi/hardware/hwsleep.c
> 
> Generally, ACPI is heavily involved and I'm not the right person to ask which
> of the ACPI functions should get the 'notrace' thing.  Also, I'm not sure about
> the device drivers' ->suspend() and ->resume() callbacks, especially for
> sysdevs and ->suspend_late(), ->resume_early() for platform devices and PCI.
> 
> Well, how exactly suspend to RAM is broken by ftrace?
> 

I know that the smp_processor_id may be defined in the %fs register, but 
if ftrace is called before the %fs is set up, it may crash because it 
uses smp_processor_id.

-- Steve


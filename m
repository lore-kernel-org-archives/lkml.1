Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbYHVUs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbYHVUs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYHVUst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:48:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46434 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbYHVUst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:48:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: ftraced and suspend to ram
Date: Fri, 22 Aug 2008 22:52:11 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <20080822104610.GA3482@elf.ucw.cz> <alpine.DEB.1.10.0808221632410.14231@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0808221632410.14231@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808222252.12547.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of August 2008, Steven Rostedt wrote:
> 
> On Fri, 22 Aug 2008, Pavel Machek wrote:
> > 
> > Does ftrace hook itself onto _all_ the functions? Or all .c functions?
> 
> It hooks into all .c functions that are not annotated with "notrace"
> or the files have not been marked in the Makefile like:
> 
>   CFLAGS_REMOVE_<file>.o = -pg
> 
> 
> > 
> > I guess low-level suspend code needs to be exempt from
> > tracing. Certainly all the assembly functions.
> 
> I'm looking into that now too. Are the functions in arch/x86/power/cpu*.c 
> the suspend to ram code?

They contain code executed during suspend to RAM, but such code is also:
- in all files under arch/x86/kernel/acpi/
- in main.c, console.c under kernel/power
- in all files under drivers/acpi/sleep
- in drivers/acpi/hardware/hwsleep.c

Generally, ACPI is heavily involved and I'm not the right person to ask which
of the ACPI functions should get the 'notrace' thing.  Also, I'm not sure about
the device drivers' ->suspend() and ->resume() callbacks, especially for
sysdevs and ->suspend_late(), ->resume_early() for platform devices and PCI.

Well, how exactly suspend to RAM is broken by ftrace?

Rafael

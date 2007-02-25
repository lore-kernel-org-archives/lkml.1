Return-Path: <linux-kernel-owner+w=401wt.eu-S965195AbXBYXEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965195AbXBYXEH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 18:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965196AbXBYXEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 18:04:06 -0500
Received: from aun.it.uu.se ([130.238.12.36]:41660 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965195AbXBYXEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 18:04:05 -0500
Date: Mon, 26 Feb 2007 00:03:40 +0100 (MET)
Message-Id: <200702252303.l1PN3eN1006022@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: ak@suse.de
Subject: Re: [PATCH 2.6.21-rc1] x86 signal number delivery fixes
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Feb 2007 23:39:48 +0100, Andi Kleen wrote:
> On Sunday 25 February 2007 12:47, Mikael Pettersson wrote:
> > The invokation of signal handlers on x86 has several bugs
> > in its treatment of the signal number parameter:
> > 
> > - the i386 kernel passes the raw not the translated signal number
> >   in EAX to non-SA_SIGINFO handlers compiled with -mregparm=3;
> >   the value passed on the stack is correct, and SA_SIGINFO handlers
> >   are also invoked correctly
> > - the x86-64 kernel's ia32 emulation for SA_SIGINFO handlers also
> >   passes the wrong (untranslated) signal number in EAX; the value
> >   on the stack is correct
> > - the x86-64 kernel's ia32 emulation for non-SA_SIGINFO handlers
> >   passes the wrong (untranslated) signal number both on the stack 
> >   and in EAX
> 
> 
> Nobody should be using that signal translation code anymore. Certainly
> nothing in tree. Perhaps it would be better to just rip it out.
> 
> If you have a user you should submit it.

The reason I noticed these issues was that I was studying the signal
delivery code for a virtualisation project, and these discrepancies
were immediately obvious just from reading the code.

I'm definitely not using that signal number translation feature; heck
I didn't even know it existed until a few days ago.

If it's dead as you say then it really ought to be removed. It currently
seems to make a mess in every arch's signal delivery code.

/Mikael

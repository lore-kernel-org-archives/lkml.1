Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbYBCWf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbYBCWf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYBCWfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:35:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41869 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbYBCWfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:35:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: wakeup code translated to .c
Date: Sun, 3 Feb 2008 23:33:02 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080130120111.GB22820@elf.ucw.cz> <200802031857.02422.rjw@sisk.pl> <20080203181648.GA1629@elf.ucw.cz>
In-Reply-To: <20080203181648.GA1629@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802032333.02821.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 3 of February 2008, Pavel Machek wrote:
> Hi!
> 
> > > This version works on 32-bit, and builds on 64-bit (but I'm pretty
> > > sure it does not work. 32-bit code probably needs to go into rm/....)
> > > 
> > 
> > Do you have an updated version or is this the latest one?
> 
> I'm glad you ask ;-). Here's reasonably-recent version (I have
> slightly cleaner one, but it got obscured by 2.6.24-git merge), I
> eventually got it to work on 64-bit, by reusing trampoline.S code.

I needed to rebase it against the current mainline (Makefile conflict).

Some remarks:

- It looks like arch/x86/kernel/acpi/wakeup.S is not necessary any more.

- These warnings:

/home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c: In function ‘acpi_save_state_mem’:
/home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:41: warning: initialization makes pointer from integer without a cast
/home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:50: warning: format ‘%d’ expects type ‘int’, but argument 2 has type ‘long unsigned int’
/home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:50: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long unsigned int’
/home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:70: warning: ISO C90 forbids mixed declarations and code
/home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:82: warning: assignment makes integer from pointer without a cast
/home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:83: warning: assignment makes integer from pointer without a cast
/home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:84: warning: ISO C90 forbids mixed declarations and code
/home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:87: warning: ISO C90 forbids mixed declarations and code
/home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:90: warning: assignment makes integer from pointer without a cast
/home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:91: warning: ISO C90 forbids mixed declarations and code

look pretty scary.

- Could the real mode directory be called just "real-mode" or something like
  this ("rm" is not very meaningful :-))?

Apart from the above and the _WAKEUP hacks mentioned elsewhere, it looks okay
(from a very high orbit).

Greetings,
Rafael

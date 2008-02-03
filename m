Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYBCX5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYBCX5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 18:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYBCX5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 18:57:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42096 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbYBCX5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:57:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: wakeup code translated to .c
Date: Mon, 4 Feb 2008 00:54:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080130120111.GB22820@elf.ucw.cz> <200802040020.14836.rjw@sisk.pl> <20080203233313.GF2799@elf.ucw.cz>
In-Reply-To: <20080203233313.GF2799@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802040054.43863.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 4 of February 2008, Pavel Machek wrote:
> On Mon 2008-02-04 00:20:14, Rafael J. Wysocki wrote:
> > On Sunday, 3 of February 2008, Rafael J. Wysocki wrote:
> > > On Sunday, 3 of February 2008, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > > > This version works on 32-bit, and builds on 64-bit (but I'm pretty
> > > > > > sure it does not work. 32-bit code probably needs to go into rm/....)
> > > > > > 
> > > > > 
> > > > > Do you have an updated version or is this the latest one?
> > > > 
> > > > I'm glad you ask ;-). Here's reasonably-recent version (I have
> > > > slightly cleaner one, but it got obscured by 2.6.24-git merge), I
> > > > eventually got it to work on 64-bit, by reusing trampoline.S code.
> > > 
> > > I needed to rebase it against the current mainline (Makefile conflict).
> > > 
> > > Some remarks:
> > > 
> > > - It looks like arch/x86/kernel/acpi/wakeup.S is not necessary any more.
> > > 
> > > - These warnings:
> > > 
> > > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c: In function ???acpi_save_state_mem???:
> > > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:41: warning: initialization makes pointer from integer without a cast
> > > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:50: warning: format ???%d??? expects type ???int???, but argument 2 has type ???long unsigned int???
> > > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:50: warning: format ???%d??? expects type ???int???, but argument 3 has type ???long unsigned int???
> > > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:70: warning: ISO C90 forbids mixed declarations and code
> > > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:82: warning: assignment makes integer from pointer without a cast
> > > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:83: warning: assignment makes integer from pointer without a cast
> > > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:84: warning: ISO C90 forbids mixed declarations and code
> > > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:87: warning: ISO C90 forbids mixed declarations and code
> > > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:90: warning: assignment makes integer from pointer without a cast
> > > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:91: warning: ISO C90 forbids mixed declarations and code
> > > 
> > > look pretty scary.
> > 
> > Below is the arch/x86/kernel/acpi/sleep.c part without the warnings (untested).
> > 
> > It still contains some hardcoded magic numbers and extern declarations, so
> > I guess the #include list is not complete or another header is necessary.
> > 
> > BTW:
> > 1) why exactly is acpi_wakeup_address not (void *)?
> 
> Well, it is physical address, not really a pointer.

But then it's converted to a pointer all over the place (same for
acpi_realmode).

Using (void *) will cause it to have the appropriate size and to be type
checked by the compiler in the C code.

> > 2) header->level3_ident_pgt and header->level3_ident_pgt could be
> (char *) IMO

OK

BTW, I don't like the way in which the 'struct wakeup_header' fields are
reproduced in rm/wakeup.S very much, because it makes the code fragile.
It might be better to define the offsets in asm-offsets*.c and refer to them
relative to wakeup_header (if possible).

Rafael

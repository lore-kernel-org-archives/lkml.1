Return-Path: <linux-kernel-owner+w=401wt.eu-S1762779AbYBSXn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762779AbYBSXn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbYBSXnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:43:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51959 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbYBSXnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:43:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: arch/x86/kernel/acpi/sleep_32.c not compiled ?
Date: Wed, 20 Feb 2008 00:41:46 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Thomas Petazzoni <thomas.petazzoni@enix.org>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <20080219165940.6e9348f6@crazy> <200802192202.53510.rjw@sisk.pl> <20080219222623.GA28786@elf.ucw.cz>
In-Reply-To: <20080219222623.GA28786@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802200041.47851.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 19 of February 2008, Pavel Machek wrote:
> On Tue 2008-02-19 22:02:52, Rafael J. Wysocki wrote:
> > On Tuesday, 19 of February 2008, Thomas Petazzoni wrote:
> > > Hi,
> > 
> > Hi,
> > 
> > > Maybe I'm missing something completely obvious, but I don't see where
> > > the arch/x86/kernel/acpi/sleep_32.c file gets compiled. The Makefile in
> > > that directory compiles sleep.o, but doesn't compile sleep_$(BITS).o:
> > > 
> > > obj-$(CONFIG_ACPI)              += boot.o
> > > obj-$(CONFIG_ACPI_SLEEP)        += sleep.o wakeup_$(BITS).o
> > > 
> > > ifneq ($(CONFIG_ACPI_PROCESSOR),)
> > > obj-y                           += cstate.o processor.o
> > > endif
> > 
> > No, the file is not build now.
> > 
> > Pavel, is this file really necessary?
> 
> sleep_32.c is obsolete. It tried to do s2ram whitelist in kernel, with
> just one entry ;-). Remove it. If Mirek Spousta (probably last
> remaining owner of whitelisted toshiba, he got it from me ;-)
> complains, I'll give him better machine or something.

Well, then perhaps we also should remove the S1 quirk for the same box from
drivers/acpi/sleep/main.c ?

Alternatively, put them both into the same file and simplify things (in which
case I'd vote for drivers/acpi/sleep/main.c)?

Rafael

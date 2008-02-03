Return-Path: <linux-kernel-owner+w=401wt.eu-S932942AbYBCMeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbYBCMeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 07:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYBCMd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 07:33:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39633 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbYBCMdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 07:33:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.24-git7: section mismatches woes
Date: Sun, 3 Feb 2008 13:32:01 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200801301950.44403.rjw@sisk.pl> <200802022347.29916.rjw@sisk.pl> <20080203101245.GB20810@uranus.ravnborg.org>
In-Reply-To: <20080203101245.GB20810@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802031332.01827.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 3 of February 2008, Sam Ravnborg wrote:
> On Sat, Feb 02, 2008 at 11:47:29PM +0100, Rafael J. Wysocki wrote:
> > On Saturday, 2 of February 2008, Sam Ravnborg wrote:
> > > On Wed, Jan 30, 2008 at 10:32:52PM +0100, Rafael J. Wysocki wrote:
> > > > On Wednesday, 30 of January 2008, Sam Ravnborg wrote:
> > > > > On Wed, Jan 30, 2008 at 07:50:43PM +0100, Rafael J. Wysocki wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > I get these messages, the majority of which seem to be false-positives:
> > > > > ...
> > > > > > modpost: Found 35 section mismatch(es).
> > > > > > To see additional details select "Enable full Section mismatch analysis"
> > > > > > in the Kernel Hacking menu (CONFIG_SECTION_MISMATCH).
> > > > > Looking in to these atm.
> > > > > 
> > > > > > 
> > > > > > and if I compile the kernel with CONFIG_SECTION_MISMATCH, it breaks resuming
> > > > > > from RAM.
> > > > > 
> > > > > The only functional difference when you enable CONFIG_SECTION_MISMATCH is the
> > > > > addition of the -fno-inline-functions-called-once to CFLAGS.
> > > > > So we have some code somewhere that breaks if it is not inlined by gcc.
> > > > > 
> > > > > It would be nice to sort out where.
> > > > > If you have a rough idea where to look
> > > > 
> > > > No, I don't.
> > > > 
> > > > It looks like there's somewhere in arch/x86, since I ruled out kernel/power and
> > > > drivers/acpi already.
> > > 
> > > Hi Rafael.
> > 
> > Hi,
> > 
> > > Do you plan to look closer into this or do you have an easy receipe so
> > > I can test myself (on a x86 64 bit box)?
> > 
> > Well, I really don't know how to approach this.  Do you have an x86-64 box with
> > suspend to RAM working?
> I dunno - never used it I'm afraid. And do not know how to do it either.

# echo mem > /sys/power/state

(better do it after a fresh boot for the first time in case it fails).

> Feel free to call me ignorant :-(
> 
> I have in latest kbuild.git made DEBUG_SECTION_MISMATCH so it cannot be selected,
> partly due to this regression but mostly due to the noise it creates.
> 
> The way to approach it is straightforward but boring.
> 
> You can add:
> ccflags-y += -fno-inline-functions-called-once
> to the Makefiles where you think this can have caused troubles until
> you find the problematic directory.
> kbuild will pick up that gcc options changed and rebuild
> all relevant files.
> 
> When the problematic directory is located then
> remove the ccflags-y assignment and do it file-by-file
> using the CFLAGS_xxx.o syntax:
> 
> CFLAGS_file.o := -fno-inline-functions-called-once

Do I have to pass any special options to "make"?

> This is probarly not the highest priority thing to look into
> but I am afraid that it could show up under other circumstances too.

Yes, probably.

Thanks,
Rafael

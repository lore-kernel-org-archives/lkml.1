Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbZDTBmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbZDTBmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 21:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZDTBmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 21:42:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54864 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZDTBmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 21:42:03 -0400
Date: Mon, 20 Apr 2009 02:41:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Paul Mundt <lethal@linux-sh.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT] kbuild
Message-ID: <20090420014158.GV26366@ZenIV.linux.org.uk>
References: <20090419092555.GA19213@uranus.ravnborg.org> <20090419223959.GB12054@linux-sh.org> <20090419234501.GA6475@uranus.ravnborg.org> <alpine.LFD.2.00.0904191745390.2199@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904191745390.2199@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 05:52:32PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 20 Apr 2009, Sam Ravnborg wrote:
> > 
> > You will soon see a path from me where I fix sh too.
> 
> Can we do a global 'sed s:asm/asm-offsets.h:generated/asm-offsets.h:g' 
> thing too? And then get rid of the include/asm symlink?
> 
> That asm-offsets.h mess is scary. I don't quite know why kvm on ia64 seems 
> to do it's own asm-offsets.h file, for example. And arch/blackfin/Makefile 
> mentions arch/$(ARCH)/include/asm/asm-offsets.h (but does it actually do 
> one?).

We'll need to update uml as well (contents of shared/kern_constants.h)

As for the arch/ia64/kvm/asm-offsets, AFAICS that could go straight into
arch/ia64/kernel/asm-offsets.c, under ifdef CONFIG_KVM.

I'm not sure about sed job, BTW - might be better to start with
arch/*/include/asm/asm-offsets.h containing just one include, then
do the transition you want piece by piece.  And then kill these
files as corresponding architectures lose the last unconverted includes.

Fewer merge conflicts with the stuff in architecture trees that way and the
final result will be exactly the same...

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbYA3TJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbYA3TJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764483AbYA3TIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:08:32 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:59333 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764457AbYA3TIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:08:31 -0500
Date: Wed, 30 Jan 2008 20:08:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git7: section mismatches woes
Message-ID: <20080130190829.GA25490@uranus.ravnborg.org>
References: <200801301950.44403.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801301950.44403.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 07:50:43PM +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> I get these messages, the majority of which seem to be false-positives:
...
> modpost: Found 35 section mismatch(es).
> To see additional details select "Enable full Section mismatch analysis"
> in the Kernel Hacking menu (CONFIG_SECTION_MISMATCH).
Looking in to these atm.

> 
> and if I compile the kernel with CONFIG_SECTION_MISMATCH, it breaks resuming
> from RAM.

The only functional difference when you enable CONFIG_SECTION_MISMATCH is the
addition of the -fno-inline-functions-called-once to CFLAGS.
So we have some code somewhere that breaks if it is not inlined by gcc.

It would be nice to sort out where.
If you have a rough idea where to look you could use the following trick.
Drop CONFIG_SECTION_MISMATCH and build a kernel.

Then for the file/directory where you think the no-inle makes
a difference do:

# To build the dir/file
rm dir/*.o
make KBUILD_NOCMDDEP=1 KCFLAGS=-fno-inline-functions-called-once dir/
# And then link the kernel
make KBUILD_NOCMDDEP=1

The KBUILD_NOCMDDEP=1 tell kbuild to ignore any commandline differences
so kbuild will not rebuild due to changed gcc flags.

Let me know if you need assistance with this.

	Sam

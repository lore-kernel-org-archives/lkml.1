Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbXKZWTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbXKZWTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757062AbXKZWSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:18:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44332 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755785AbXKZWSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:18:50 -0500
Date: Mon, 26 Nov 2007 14:17:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@elte.hu, riel@redhat.com, kamalesh@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com, linux-acpi@vger.kernel.org,
       tglx@linutronix.de, clameter@sgi.com
Subject: Re: 2.6.24-rc3-mm1 - Kernel Panic on IO-APIC
Message-Id: <20071126141713.3dcd492b.akpm@linux-foundation.org>
In-Reply-To: <474B43E1.9080407@gmail.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<4743CC0B.9000508@linux.vnet.ibm.com>
	<20071120221839.faab108e.akpm@linux-foundation.org>
	<20071126143943.0a01665b@cuia.boston.redhat.com>
	<20071126123319.7483e57f.akpm@linux-foundation.org>
	<20071126204540.GA19874@elte.hu>
	<474B43E1.9080407@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 23:08:33 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 11/26/2007 09:45 PM, Ingo Molnar wrote:
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> >> On Mon, 26 Nov 2007 14:39:43 -0500
> >> Rik van Riel <riel@redhat.com> wrote:
> >>
> >>> On Tue, 20 Nov 2007 22:18:39 -0800
> >>> Andrew Morton <akpm@linux-foundation.org> wrote:
> >>>
> >>>>> ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> >>>>> Kernel panic - not syncing: IO-APIC + timer doesn't work! Try using the 'noapic' kernel parameter
> >>>> ACPI or x86 breakage, I guess.
> >>>>
> >>>> Did 'noapic' work?
> >>> I got the same bug as above, 'noapic' gets past that point 
> >> We still don't know what caused this, afaik.
> > 
> > yes. Is it a regression? If yes, could someone try to bisect it so that 
> > we can fix it? If it's caused by x86.git then the 'mm' branch of the x86 
> > git tree can be used for bisection:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> 
> I did, but it's hard, if you don't know the BAD point. HEAD boots fine and 'x86:
> randomize brk' too (the top of git-x86.patch).

So the bug wasn't in git-x86 in 2.6.24-rc3-mm1.

But it might be in there now, as some patches got moved over.

Or it could be git-acpi.  Or lots of other things.

> Andrew, how do you pull it, git
> #mm doesn't fit to the ids from the patch.

The -mm git tree reimports the plain git-foo.patch files back into a new
git tree, so the commit IDs won't line up.

The way to find the culprit patch in 2.6.24-rc3-mm1 is
http://www.zip.com.au/~akpm/linux/patches/stuff/bisecting-mm-trees.txt.  It
will be quite quick.

> Maybe if you can emit a broken-out with the fresh pull to test?

http://userweb.kernel.org/~akpm/mmotm/ is current.  But it probably won't
compile.  I'd suggest bisecting 2.6.24-rc3-mm1 would be easier.  

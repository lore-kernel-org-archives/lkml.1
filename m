Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbZAITx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbZAITx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 14:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZAITxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 14:53:47 -0500
Received: from thunk.org ([69.25.196.29]:44980 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbZAITxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 14:53:45 -0500
Date: Fri, 9 Jan 2009 14:52:33 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Dirk Hohndel <hohndel@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       jim owens <jowens@hp.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
	impact
Message-ID: <20090109195232.GE23869@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Dirk Hohndel <hohndel@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
	Gregory Haskins <ghaskins@novell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
References: <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org> <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109094142.367012b6@infradead.org> <20090109180213.GH26290@one.firstfloor.org> <alpine.LFD.2.00.0901090954410.6528@localhost.localdomain> <20090109185509.GJ26290@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109185509.GJ26290@one.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 07:55:09PM +0100, Andi Kleen wrote:
> > But _users_ just get their oopses sent automatically. So it's not about 
> 
> If they send it from distro kernels the automated oops sender could
> just fetch the debuginfo rpm and decode it down to a line.
> My old automatic user segfault uploader I did originally
> for the core pipe code did that too.

Fetch a gigabyte's worth of data for the debuginfo RPM?  Um, I think
most users would not be happy with that, especially if they are behind
a slow network.  Including the necessary information so someone who
wants to investigate the oops, or having kerneloops.org pull apart the
oops makes more sense, I think, and is already done.

Something that would be **really** useful would be a web page where if
someone sends me an oops message from Fedora or Open SUSE kernel to
linux-kernel or linux-ext4, I could take the oops message, cut and
paste it into a web page, along with the kernel version information,
and the kernel developer could get back a decoded oops information
with line number information.

Kerneloops.org does this, so the code is mostly written; but it does
this in a blinded fashion, so it only makes sense for oops which are
very common and for which we don't need to ask the user, "so what were
you doing at the time".  In cases where the user has already stepped
up and reported the oops on a mailing list, it would be nice if
kerneloops.org had a way of decoding the oops via some web page.

Arjan, would something like this be doable, hopefully without too much
effort?

						- Ted

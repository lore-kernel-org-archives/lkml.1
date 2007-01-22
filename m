Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984AbXAVT5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbXAVT5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932432AbXAVT5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:57:12 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45617 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbXAVT5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:57:09 -0500
Date: Mon, 22 Jan 2007 11:56:50 -0800
From: Andrew Morton <akpm@osdl.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: tom@dbservice.com, bwalle@suse.de, linux-kernel@vger.kernel.org,
       alon.barlev@gmail.com
Subject: Re: [patch 03/26] Dynamic kernel command-line - arm
Message-Id: <20070122115650.d0be8bd3.akpm@osdl.org>
In-Reply-To: <20070118152326.GC31418@flint.arm.linux.org.uk>
References: <20070118125849.441998000@strauss.suse.de>
	<20070118130028.719472000@strauss.suse.de>
	<20070118141359.GB31418@flint.arm.linux.org.uk>
	<45AF92E7.50901@dbservice.com>
	<20070118152326.GC31418@flint.arm.linux.org.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 18 Jan 2007 15:23:26 +0000 Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> On Thu, Jan 18, 2007 at 04:31:51PM +0100, Tomas Carnecky wrote:
> > Russell King wrote:
> > > On Thu, Jan 18, 2007 at 01:58:52PM +0100, Bernhard Walle wrote: 
> > >> -static char command_line[COMMAND_LINE_SIZE];
> > >> +static char __initdata command_line[COMMAND_LINE_SIZE];
> > > 
> > > Uninitialised data is placed in the BSS.  Adding __initdata to BSS
> > > data causes grief.
> > > 
> > 
> > Static variables are implicitly initialized to zero. Does that also
> > count as initialization?
> 
> No.  As I say, they're placed in the BSS.  The BSS is zeroed as part of
> the C runtime initialisation.

I don't understand the objection.  With the above change, command_line[]
will end up consuming COMMAND_LINE_SIZE bytes of .data.init and will be
reliably initialized to all-zeros by the compiler (won't it?)

> If you want to place a variable in a specific section, it must be
> explicitly initialised.  Eg,
> 
> static char __initdata command_line[COMMAND_LINE_SIZE] = "";
> 
> However, there is a bigger question here: that is the tradeoff between
> making this variable part of the on-disk kernel image, but throw away
> the memory at runtime, or to leave it in the BSS where it will not be
> part of the on-disk kernel image, but will not be thrown away at
> runtime.

Yes, it'll take some space in vmlinux.  We could perhaps create a new
__initbss to prevent that, I assume.


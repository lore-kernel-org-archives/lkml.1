Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbXAVUBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbXAVUBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932436AbXAVUAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:00:54 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4312 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422AbXAVUAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:00:52 -0500
Date: Mon, 22 Jan 2007 20:00:39 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@osdl.org>
Cc: tom@dbservice.com, bwalle@suse.de, linux-kernel@vger.kernel.org,
       alon.barlev@gmail.com
Subject: Re: [patch 03/26] Dynamic kernel command-line - arm
Message-ID: <20070122200038.GA32085@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@osdl.org>, tom@dbservice.com,
	bwalle@suse.de, linux-kernel@vger.kernel.org, alon.barlev@gmail.com
References: <20070118125849.441998000@strauss.suse.de> <20070118130028.719472000@strauss.suse.de> <20070118141359.GB31418@flint.arm.linux.org.uk> <45AF92E7.50901@dbservice.com> <20070118152326.GC31418@flint.arm.linux.org.uk> <20070122115650.d0be8bd3.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070122115650.d0be8bd3.akpm@osdl.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 22, 2007 at 11:56:50AM -0800, Andrew Morton wrote:
> > On Thu, 18 Jan 2007 15:23:26 +0000 Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > On Thu, Jan 18, 2007 at 04:31:51PM +0100, Tomas Carnecky wrote:
> > > Russell King wrote:
> > > > On Thu, Jan 18, 2007 at 01:58:52PM +0100, Bernhard Walle wrote: 
> > > >> -static char command_line[COMMAND_LINE_SIZE];
> > > >> +static char __initdata command_line[COMMAND_LINE_SIZE];
> > > > 
> > > > Uninitialised data is placed in the BSS.  Adding __initdata to BSS
> > > > data causes grief.
> > > > 
> > > 
> > > Static variables are implicitly initialized to zero. Does that also
> > > count as initialization?
> > 
> > No.  As I say, they're placed in the BSS.  The BSS is zeroed as part of
> > the C runtime initialisation.
> 
> I don't understand the objection.  With the above change, command_line[]
> will end up consuming COMMAND_LINE_SIZE bytes of .data.init and will be
> reliably initialized to all-zeros by the compiler (won't it?)

You're reading into this something that was never there.  The mail you
are replying to is an explanatory one, not an objecting one.

My "objection" (if you want to call it that, it was more an observation)
was that merely adding an __initdata to an uninitialised variable has in
the past caused complaints from compilers about section mismatches and
the like.

Maybe compilers are now smarter though.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

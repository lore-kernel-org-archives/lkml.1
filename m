Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbZBFPLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbZBFPLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZBFPLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:11:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54688 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbZBFPLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:11:40 -0500
Date: Fri, 6 Feb 2009 15:10:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, hskinnemoen@atmel.com,
       cooloney@kernel.org, ralf@linux-mips.org, dhowells@redhat.com,
       matthew@wil.cx, chris@zankel.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
Message-ID: <20090206151027.GC13758@n2100.arm.linux.org.uk>
References: <12c511ca0902050955x1acb3907jdbfc1d0e6392cb91@mail.gmail.com> <alpine.LFD.2.00.0902051101040.3247@localhost.localdomain> <20090205191907.GA27422@elte.hu> <1233886017.3463.26.camel@localhost.localdomain> <20090206022025.GA8317@elte.hu> <1233929922.3209.6.camel@localhost.localdomain> <20090206142134.GA13758@n2100.arm.linux.org.uk> <1233930860.3209.13.camel@localhost.localdomain> <20090206145119.GB13758@n2100.arm.linux.org.uk> <1233932407.3209.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233932407.3209.18.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 08:30:07PM +0530, Jaswinder Singh Rajput wrote:
> On Fri, 2009-02-06 at 14:51 +0000, Russell King - ARM Linux wrote:
> > > > 
> > > > So no point including this file in assembly with this patch - the ifndef
> > > > disables the entire file.
> > > 
> > > Truth Table of linux/types.h :
> > > 
> > > If Assembly then N
> > > otherwise Y
> > > 
> > > what your table says.
> > 
> > If the entire file is not suitable for assembly, don't include the file
> > in assembly files.  Nice and simple, and no need to add additional ifdefs.
> 
> Ahh, so your truth table says:
> 
> If Assembly then make different header files
> If C then make another header files

No.  My point is exactly as I stated above, please don't twist my
statement into something that it isn't.

Taking this further, if you're including linux/types.h into another
header file, you're including it because you want some C type from
that or an included file.  Use of that type is also not ASM friendly,
so the use is going to have to be excluded by ifndef in that header.

So why not do as we *already* do and ensure that the linux/types.h
inclusion happens within that section.

Why change the rules?

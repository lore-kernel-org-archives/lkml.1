Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbZIITUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbZIITUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 15:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZIITUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 15:20:31 -0400
Received: from relay1.sgi.com ([192.48.179.29]:41482 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753090AbZIITUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 15:20:30 -0400
Date: Wed, 9 Sep 2009 14:20:30 -0500
From: Jack Steiner <steiner@sgi.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: SGU UV Add volatile to macros that access chipset registers
Message-ID: <20090909192030.GA10530@sgi.com>
References: <20090909154246.GA26716@sgi.com> <1252512600.14793.125.camel@desktop> <20090909180110.GA10311@sgi.com> <1252519885.14793.135.camel@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252519885.14793.135.camel@desktop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 11:11:25AM -0700, Daniel Walker wrote:
> On Wed, 2009-09-09 at 13:01 -0500, Jack Steiner wrote:
> > On Wed, Sep 09, 2009 at 09:10:00AM -0700, Daniel Walker wrote:
> > > On Wed, 2009-09-09 at 10:42 -0500, Jack Steiner wrote:
> > > > Add "volatile" to the SGI UV read/write macros that are used to access chipset
> > > > memory mapped registers.
> > > 
> > > There is a considerable document regarding the usage of volatile in the
> > > kernel (Documentation/volatile-considered-harmful.txt). Considering that
> > > document, can you give a more descriptive reason why your using
> > > "volatile" here ?
> > > 
> > 
> > I knew that "volatile" would catch someone's attention  :-)
> > 
> > 
> > Volatile is being added to the accessor functions that are used to
> > read/write memory-mapped I/O registers located within the UV chipset.
> > The use of volatile is hidden within the functions and is not exposed
> > to the users of the functions.
> > 
> > Note that the use is limited to the accessor functions in the header
> > file. No .c files are changed or need to know about volatile.
> > 
> > 
> > This seems to be consistent with other uses of volatile within the kernel.
> 
> The document that I cited specifically addresses memory accessors as not
> needing the volatile keyword .. So your still not addressing exactly why
> your code needs it .. Are your accessors special in some way? Is there
> some defect your seeing without the volatile keyword?

The code is not yet in the kernel but the function that exposed the bug
was one that had multiple access to the chipset RTC clock. This
is a free running clock that counts at nsec rate. The compiler optimized
the function so that a single read of the clock was done. This broken
the timing that was trying to measure elapsed time.

I scanned the standard header files and see numerous instances where inline
functions use volatile. The usage of volatile in the UV macros (at least to
me) seems consistent:

	mmio_config_xxx()
	native_apic_mem_xxx()
	readb(), etc.
	bit_ops functions
	etc...

What am I missing?

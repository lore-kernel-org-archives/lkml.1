Return-Path: <linux-kernel-owner+w=401wt.eu-S1751451AbXEXPBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbXEXPBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 11:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbXEXPBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 11:01:43 -0400
Received: from [81.2.110.250] ([81.2.110.250]:45747 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750776AbXEXPBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 11:01:42 -0400
Date: Thu, 24 May 2007 16:05:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [PATCH] $ARCH: Enable arbitary speed tty ioctls and split
 input/output speed
Message-ID: <20070524160559.54c2c639@the-village.bc.nu>
In-Reply-To: <1180014338.8303.95.camel@shinybook.infradead.org>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	<1180012135.8303.89.camel@shinybook.infradead.org>
	<20070524144109.7bd0f4d0@the-village.bc.nu>
	<1180014338.8303.95.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 09:45:37 -0400
David Woodhouse <dwmw2@infradead.org> wrote:

> On Thu, 2007-05-24 at 14:41 +0100, Alan Cox wrote:
> > Most people copied the x86 behaviour which makes it easy to transplant.
> > Some are just smoking something (see ioctls.h for sh-64 and weep), others
> > have slightly odd behaviour for historical compatibility reasons (Sparc)
> 
> Likewise, I assume the lack of IBSHIFT on PowerPC is because of AIX?

I assume nobody ever got around to it. CIBAUD is in the PowerPC System V
API supplement for example and is supported by other Power OS's.

> > When PPC wants to do arbitary baud rate it needs to resolve both of the
> > definitions together. IBSHIFT is simply the shift you apply to the baud
> > bits to get the input baud bits.
> 
> Why bother introducing new IBSHIFT stuff when it can be declared
> obsolete already -- if you want different input and output baud rates,
> just set BOTHER and have different values c_ispeed and c_ospeed.

BOTHER is for the output speed. BOTHER << IBSHIFT is for the input speed
if it different to the default (and you need B0 << IBSHIFT to know if an
input speed is being specifically set in the first place).

CIBAUD and IBSHIFT come from standards documents so it appears to make
sense at some level to support those standards. As everyone else in the
Power world supports it I don't see why Linux should be different.

Alan

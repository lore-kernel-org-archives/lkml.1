Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbXE1Er5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbXE1Er5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 00:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXE1Ert
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 00:47:49 -0400
Received: from ozlabs.org ([203.10.76.45]:49869 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbXE1Ers (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 00:47:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18010.24300.599531.828815@cargo.ozlabs.ibm.com>
Date: Mon, 28 May 2007 14:47:40 +1000
From: Paul Mackerras <paulus@samba.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] $ARCH: Enable arbitary speed tty ioctls and split
 input/output speed
In-Reply-To: <20070524160559.54c2c639@the-village.bc.nu>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	<1180012135.8303.89.camel@shinybook.infradead.org>
	<20070524144109.7bd0f4d0@the-village.bc.nu>
	<1180014338.8303.95.camel@shinybook.infradead.org>
	<20070524160559.54c2c639@the-village.bc.nu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox writes:

> On Thu, 24 May 2007 09:45:37 -0400
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Thu, 2007-05-24 at 14:41 +0100, Alan Cox wrote:
> > > Most people copied the x86 behaviour which makes it easy to transplant.
> > > Some are just smoking something (see ioctls.h for sh-64 and weep), others
> > > have slightly odd behaviour for historical compatibility reasons (Sparc)
> > 
> > Likewise, I assume the lack of IBSHIFT on PowerPC is because of AIX?
> 
> I assume nobody ever got around to it. CIBAUD is in the PowerPC System V
> API supplement for example and is supported by other Power OS's.

The guys that did the original ppc linux port (mainly Gary Thomas and
Cort Dougan, I believe) tended to follow the alpha and x86 linux ports
rather than the System V ABI.  There aren't any SysV-based OSes for
PowerPC still extant so it doesn't really matter.

And yes, nobody has got around to implementing CIBAUD/IBSHIFT.

> > Why bother introducing new IBSHIFT stuff when it can be declared
> > obsolete already -- if you want different input and output baud rates,
> > just set BOTHER and have different values c_ispeed and c_ospeed.
> 
> BOTHER is for the output speed. BOTHER << IBSHIFT is for the input speed
> if it different to the default (and you need B0 << IBSHIFT to know if an
> input speed is being specifically set in the first place).
> 
> CIBAUD and IBSHIFT come from standards documents so it appears to make
> sense at some level to support those standards. As everyone else in the
> Power world supports it I don't see why Linux should be different.

Sure, we can add them.  I suggest IBSHIFT = 16 and CIBAUD = 0xff0000
(or 077600000 if we are going to continue the peculiar convention of
using octal for the C* constants).

Paul.

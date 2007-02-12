Return-Path: <linux-kernel-owner+w=401wt.eu-S965424AbXBLVlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965424AbXBLVlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 16:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030185AbXBLVlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 16:41:40 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42160 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965425AbXBLVlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 16:41:39 -0500
Date: Mon, 12 Feb 2007 22:41:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       virtualization@lists.osdl.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [q] kbuild for private asm-offsets (Re: [PATCH 6/10] lguest code: the little linux hypervisor.)
Message-ID: <20070212214128.GA11955@uranus.ravnborg.org>
References: <1171012296.2718.26.camel@localhost.localdomain> <1171012761.2718.40.camel@localhost.localdomain> <1171012827.2718.42.camel@localhost.localdomain> <200702091109.20061.ak@muc.de> <1171024771.2718.129.camel@localhost.localdomain> <20070209141728.GA26749@uranus.ravnborg.org> <1171034599.2718.190.camel@localhost.localdomain> <E1HGbJz-0003Lc-6h@flower>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HGbJz-0003Lc-6h@flower>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> If you will have time for newbie, to explain in a few words, what is it need
> for (whole idea, or key detail), and, maybe, why it is generated so ... interestingly:
> 
>             asm-offsets.c -> *.s -> *.h
>  (but this looks like interconnecting C and assembler, obviously)

Correct - asm-offsets is used to transfer constants for .c to assembler,
which us especially convinient for constant that differ when a stuct
is changed.

> 
> I will glad to help providing solution maybe somewhat earlier (well, i'm
> trying to understand whole building process, if that matters).

Basically what is requested is to move the generic parts of asm-offsets
generation from top-level Kbuild file to a generic file somewhere.

Since this is not generic Kbuild functionality but more specific to the
kernel it should not be part of Kbuild generic files.
include/asm-generic/asm-offsets seems to be a fair place for it.

It would contain the sed-y parts as well as cmd_offsets definition.

I would be glad if you could give that a spin.

	Sam

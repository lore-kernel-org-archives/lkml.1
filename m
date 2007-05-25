Return-Path: <linux-kernel-owner+w=401wt.eu-S1764614AbXEYSlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764614AbXEYSlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 14:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763483AbXEYSky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 14:40:54 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51543 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbXEYSkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 14:40:53 -0400
Message-ID: <46572DAF.1000108@zytor.com>
Date: Fri, 25 May 2007 11:40:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] MIPS: Transform old-style macros to newer "__noreturn"
 standard.
References: <Pine.LNX.4.64.0705251418050.13623@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705251418050.13623@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> Convert old/obsolete NORET_TYPE and ATTRIB_NORET macros to use the
> newer standard of "__noreturn" as defined in compiler-gcc.h.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

> 1) in a function declaration, the "__noreturn" will go at the end of
> the declaration.
> 
> 2) in a definition, "__noreturn" will go between the return type and
> the function name
> 
> 3) in a function typedef, "__noreturn" will go immediately after the
> return type, just like with definitions.
> 
> 4) if a function definition already includes "__noreturn", there's no
> point in having any external references to it also say the same thing.
> (right?)

This is dumb, though.

"void __noreturn" is redundant.  It would be much cleaner to have a
macro which amounts to "void __attribute__((noreturn))" and use it
instead of giving a return type.

Even "void" as the return type is bogus -- the function never returns so
it doesn't *have* a return type...

	-hpa

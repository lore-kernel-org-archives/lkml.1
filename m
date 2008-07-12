Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbYGLXVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbYGLXVi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 19:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYGLXVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 19:21:31 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2529 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbYGLXVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 19:21:31 -0400
Date: Sun, 13 Jul 2008 01:21:08 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Milton Miller <miltonm@bga.com>
cc: ppcdev <linuxppc-dev@ozlabs.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Paul Mackerras <paulus@samba.org>, Sam Ravnborg <sam@ravnborg.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: linux-next: kbuild tree build failure
In-Reply-To: <7b8dd1f1421b1f52ebc76565986fd2a9@bga.com>
Message-ID: <Pine.LNX.4.64.0807130057490.6791@localhost.localdomain>
References: <7b8dd1f1421b1f52ebc76565986fd2a9@bga.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 12 Jul 2008, Milton Miller wrote:

> (1) #define PAGE_OFFSET    (ASM_CONST(CONFIG_PAGE_OFFSET) << 32)
> 
> It creates unreadable code, where two defines with almost the same name (the
> only difference being
> the CONFIG_ prefix, which is often ignored when scanning) contains radically
> different values.
> 
> (2)  #define PAGE_OFFSET    ASM_CONST(CONFIG_PAGE_OFFSET)

Giving it different names is not really difficult. Any objections to 
CONFIG_PAGE_HIGH_OFFSET?

> On a seperate note,
> > > > >  config PINT3_ASSIGN
> > > > >         hex "PINT3_ASSIGN"
> > > > >         depends on PINTx_REASSIGN
> > > > > -       default 0x02020303
> > > > > +       default 0x2020303
> 
> is harder to read.   The value is a list of 4 1 byte values, but you have
> hidden the first nibble making parsing the rest of the value hard.

Sam mentioned that already, but that's a situation where the warning can 
be relaxed.

> If you are worried about users tring to set values that are too high,
> then make the types be hex8, hex16, hex32, and hex64.

It's not this, I value consistency as much as you and the values are 
sometimes used as integers, so a working range is needed. Using simple 
integers keeps things much simpler and as the ASM_CONST example shows any 
bigger values are not necessarily directly usable anyway.

bye, Roman

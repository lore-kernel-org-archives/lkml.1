Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbXKZRM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbXKZRM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 12:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbXKZRMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 12:12:48 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:62742 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753756AbXKZRMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 12:12:48 -0500
Date: Mon, 26 Nov 2007 17:12:23 +0000
From: Ben Dooks <ben@fluff.org>
To: Heikki Orsila <shdl@zakalwe.fi>
Cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, kune@deine-taler.de, johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
Message-ID: <20071126171223.GB7855@fluff.org.uk>
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net> <20071123114329.GG7681@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071123114329.GG7681@zakalwe.fi>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2007 at 01:43:29PM +0200, Heikki Orsila wrote:
> On Fri, Nov 23, 2007 at 12:15:53AM +0000, Daniel Drake wrote:
> > Why unaligned access is bad
> > ===========================
> > 
> > Most architectures are unable to perform unaligned memory accesses. Any
> > unaligned access causes a processor exception.
> 
> "Some architectures are unable to perform unaligned memory accesses, 
> either an exception is generated, or the data 
> access is silently invalid. In architectures that allow unaligned 
> access, natural aligned accesses are usually faster than non-aligned."
> 
> > In summary: if your code causes unaligned memory accesses to happen, your code
> > will not work on some platforms, and will perform *very* badly on others.
> 
> *very* -> *slower*
> 
> > Natural alignment
> > =================
> 
> Please move this definition before "Why unaligned access is bad".
> 
> Also, it would be nice to have a table of ISAs:
> 
> ISA		Need		Need
> 		natural		alignment
> 		alignment	by x
> --------------------------------------------
> m68k		No		2
> powerpc/ppc	Yes		Word size
> x86		No		No
> x86_64		No		No
arm32		Yes		2 for 16bit data, 4 for 32bit

Note, if the unaligned handler is running, the alignment will be fixed
by the fault handler (at the cost of taking a fault). If the unaligned
handler is turned off, you get a "free" shift of the data instead.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'

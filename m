Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbYKOAKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbYKOAKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 19:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYKOAKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 19:10:22 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57341 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751664AbYKOAKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 19:10:22 -0500
Date: Fri, 14 Nov 2008 19:10:13 -0500
From: Theodore Tso <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] serial/8250.c: Use self-adjusting list for port poll
	order.
Message-ID: <20081115001013.GM25117@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org
References: <20081113150308.3590.qmail@science.horizon.com> <20081114053042.11532.qmail@science.horizon.com> <20081114053314.12093.qmail@science.horizon.com> <20081114213449.14960.qmail@science.horizon.com> <20081114214711.3c1d1473@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114214711.3c1d1473@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 09:47:11PM +0000, Alan Cox wrote:
> > This code does that by using the previous poll cycles as a hint.
> > If a port is idle, it will migrate to the end of the list and
> > only have to be checked once.
> > 
> > Part 1 changed the list to singly-linked to make the list shuffling easier.
> > 
> > Comments?  Please?
> 
> Is it really worth the complexity
> 
> - PCI ports are shared IRQ always
> - Legacy ports are almost never shared IRQ on the LPC bus (and are
> increasingly going away)

It's worth the complexity only *if* you have enough ports shared on a
single IRQ and simultaneously such that there a risk that if you don't
poll them quickly enough, characters will actually get dropped from
the UART's FIFO.  The question is whether that is likely to happen on
modern CPU's.  I worred about such things when I tried to make 16
115kbps serial ports work at full-speed using relatively primitive
16550A UART's with 16 character FIFO's on a 40 MHz 386.  But (a)
UART's generally have deeper FIFO's these days, and (b) CPU's have
gotten a wee bit faster since 1992.

So color me dubious that this is actually necessary....

							- Ted

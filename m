Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbYKPQuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbYKPQuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYKPQuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:50:08 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:53683 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751910AbYKPQuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:50:06 -0500
Date: Sun, 16 Nov 2008 11:49:54 -0500
From: Theodore Tso <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] serial/8250.c: Use self-adjusting list for port poll
	order.
Message-ID: <20081116164954.GE6958@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, alan@lxorguk.ukuu.org.uk,
	linux-kernel@vger.kernel.org
References: <20081113150308.3590.qmail@science.horizon.com> <20081114053042.11532.qmail@science.horizon.com> <20081114053314.12093.qmail@science.horizon.com> <20081114213449.14960.qmail@science.horizon.com> <20081114214711.3c1d1473@lxorguk.ukuu.org.uk> <20081115001013.GM25117@mit.edu> <20081116152352.20261.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081116152352.20261.qmail@science.horizon.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 10:23:52AM -0500, George Spelvin wrote:
> The goal is not fewer dropped characters (although there could be a small
> benefit in that direction), and it doesn't improve worst-case timing;
> the goal is to reduce the time spent in the interrupt handler _on average_
> and thereby make more CPU available for other work.

Have you actually measured how much CPU is currently being burned by
the interrupt handler?  And does it actually make a difference with
your optimization?  I did a lot of measurements of this back in the
day of the 40 MHz 386 and 16 serial ports running at 115kbps.  CPU's
have gotten *so* much faster, and as you have pointed the out, the PCI
bus accesses are also faster (and on the ISA bus, given edge-triggered
interrupts, you have to scan all of the ports any way) --- so it's not
obvious to me that it's actually worth it.

There were programs to measure CPU overhead; they normally worked by
doing a certain amount of work (i.e., seeing how many interations of
some mathematical calculation) in a given amount of clock time both
with and without the serial ports being busy.  It might be worthwhile
to see whether for your workload how measurrable the CPU reduction
really is, given modern hardware.  I'm not convinced given the number
of Moore's law doublings since 1992, that it's really going to be
worth it for a rational number of serial ports being serviced by a
modern Linux machine.

						- Ted

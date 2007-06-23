Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbXFWING@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbXFWING (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 04:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXFWIMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 04:12:54 -0400
Received: from phoenix.clifford.at ([88.198.7.52]:35448 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbXFWIMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 04:12:53 -0400
Date: Sat, 23 Jun 2007 10:16:15 +0200
From: Clifford Wolf <clifford@clifford.at>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Mem-2-Mem DMA - Generalized API (MPC8349E)
Message-ID: <20070623081615.GE5829@clifford.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm curently working on an embedded project using the Freescale MPC8349E
microcontroller (PPC e300 core + almost everything one needs for
communicating with the rest of the world on one ~100$ chip).

One feature of that microcontroller is a generic memory-2-memory four
channel dma controller. Unlike the PC 8237 DMA controller (which copies
data between the memory and dedicated DMA channels) the memory-2-memory
DMA controller of the MPC8349E can copy between any bus addresses and thus
can be used for copying data from one memory area to another, between
memory and periphery mapped on bus addresses as well as from one peripheral
device on the bus to another. The MPC8349E has four DMA channels which
(unlike the PC 8237 DMA) are not bound to be used exclusively for dma
transfers from or to a dedicated peripheral device.

I doubt that the MPC8349E is the only device out there with such a DMA
controller and so I was looking for a generalized kernel API for working
with such DMA controllers to add MPC8349E support to it (since grepping
the kernel for the register addresses didn't show up any usefull results
I assume that there is no existing implementaion).

Has anyone thought already about an API fur such a generic kernel
framework? I was thinking about a 'copy using DMA if possible' function
which is first sleeping until a DMA channel gets free, then reprograms
this channel and again sleeps until the DMA transfer has been finished.

The MPC8349E has scatter-gather features for source and destination and can
eighter increment the source/destination addresses during the transfer or
run in (8, 16 or 32 bit) fifo mode. So it is a bit more complicated than
a 'memcpy on bus addresses which may sleep'.

Extending the request_dma() - free_dma() API looks like the wrong way to go
on this issue. It is afaics designed for a compleatly diffrent kind of DMA
controller.

Any thoughts? Am I completely missing something?

yours,
 - clifford

-- 
For extra security, this message has been encrypted with double-ROT13.

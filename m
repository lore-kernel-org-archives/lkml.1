Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbYDHTec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbYDHTec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 15:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbYDHTeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 15:34:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56894 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbYDHTeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 15:34:21 -0400
Date: Tue, 8 Apr 2008 20:33:09 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, lethal@linux-sh.org,
       philipp.zabel@gmail.com, pavel@ucw.cz, tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 5/6] Clocklib: Use correct clock for IrDA on pxa
Message-ID: <20080408193309.GA18053@flint.arm.linux.org.uk>
References: <20080403132142.GA26882@doriath.ww600.siemens.net> <20080403132402.GA27008@doriath.ww600.siemens.net> <20080407160029.f1f9ce4f.akpm@linux-foundation.org> <20080407230434.GA525@flint.arm.linux.org.uk> <bc64b4640804080247s82ba84chd740c08b2fbb9b1a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640804080247s82ba84chd740c08b2fbb9b1a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 01:47:35PM +0400, Dmitry wrote:
> Yes, it works currently. But there are a few problems: we declare
> STUART's UARTCLK with dev=NULL (all other UARTCLKs are declared with
> proper devices).  Therefore,  I consider it as a hack and would like
> to remove it.

I don't consider it a hack at all - it's a work around for the fact
that the PXA FIR driver shares the UART, but the FIR driver doesn't
bind to the UART itself.

The _real_ issue is with IrDA itself, and is larger than just the
clock library.  Any serial port which supports IrDA, even on x86,
has to be shared between the serial driver and the IrDA driver -
there's no way for them to quietly co-exist and "just work" as
requested.

So, let's not work around the short comings of Serial/IrDA interactions
by adding additional complexity to random other layers which _shouldn't_
even be seeing the issue.

In addition, the point of the clock framework is that you ask for the
device plus clock NAME on _that_ device.  Inventing random other names
for the same physical clock on the same physical device is just nonsense -
even more so than the existing workaround.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

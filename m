Return-Path: <linux-kernel-owner+w=401wt.eu-S933650AbXHFNbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650AbXHFNbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbXHFN3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:29:34 -0400
Received: from 1wt.eu ([62.212.114.60]:1213 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933314AbXHFN3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:29:33 -0400
Date: Mon, 6 Aug 2007 15:26:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Axel Reinhold <axel@freakout.de>, linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in 2.4.35 when compiled gcc>=4.2.0 and -march=c3
Message-ID: <20070806132658.GE10999@1wt.eu>
References: <200708050856.l758u4ou031651@bongo.freakout.de> <20070805154337.GA4716@1wt.eu> <44e819389656d1465e70ce2e99fb7640@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44e819389656d1465e70ce2e99fb7640@kernel.crashing.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 03:05:29PM +0200, Segher Boessenkool wrote:
> >I still
> >suspect that because the behaviour is different between 4.1 and 4.2, it
> >might be a regression in 4.2,
> 
> The kernel code is wrong.  It might have accidentally worked
> with GCC-4.1, but that doesn't mean GCC-4.2 has regressed.
> Only supported features that stop working are regressions;
> invalid code that stops working is, well, in the worst case
> an improvement in diagnostics ;-)

Just to enlighten me on the subject, could you please explain me
what is wrong in the code ? Granted I found it awful, but even on
the GCC-4.2 page where -fno-toplevel-reorder is explained, it is
said that asm statements can be instantiated between functions
blocks, which is exactly what is used here.

Also, I could reproduce the problem with gcc 4.1 by simply declaring
the interrupts[] array before the asm statements. It looks like the
asm statements simply continue in the next section as the previously
instantiated block. Maybe ".section .text" should be explicitly noted
in each asm statement, but that seems strange to me.

Right now, I just removed -fno-unit-at-a-time which had been added
only for gcc-3.4, and it fixed gcc-4.2 (and even 4.1 produces cleaner
code after that).

Regards,
Willy


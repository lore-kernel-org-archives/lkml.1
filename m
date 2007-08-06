Return-Path: <linux-kernel-owner+w=401wt.eu-S1762927AbXHFRnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762927AbXHFRnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbXHFRmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:42:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40043 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbXHFRmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:42:52 -0400
Message-ID: <46B75CD0.7080408@zytor.com>
Date: Mon, 06 Aug 2007 10:39:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Segher Boessenkool <segher@kernel.crashing.org>,
       Axel Reinhold <axel@freakout.de>, linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in 2.4.35 when compiled gcc>=4.2.0 and -march=c3
References: <200708050856.l758u4ou031651@bongo.freakout.de> <20070805154337.GA4716@1wt.eu> <44e819389656d1465e70ce2e99fb7640@kernel.crashing.org> <20070806132658.GE10999@1wt.eu>
In-Reply-To: <20070806132658.GE10999@1wt.eu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> 
> Just to enlighten me on the subject, could you please explain me
> what is wrong in the code ? Granted I found it awful, but even on
> the GCC-4.2 page where -fno-toplevel-reorder is explained, it is
> said that asm statements can be instantiated between functions
> blocks, which is exactly what is used here.
> 

A stray semicolon:

__attribute__((regparm(0))) void call_do_IRQ(void); __asm__(...

... is actually a prototype followed by a top-level asm statement
(because of the semicolon), *not* a function with a single-statement
body (which is itself uglier than hell, use braces please...)

	-hpa

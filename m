Return-Path: <linux-kernel-owner+w=401wt.eu-S1764504AbXHFRsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764504AbXHFRsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbXHFRs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:48:26 -0400
Received: from 1wt.eu ([62.212.114.60]:1216 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbXHFRs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:48:26 -0400
Date: Mon, 6 Aug 2007 19:45:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Axel Reinhold <axel@freakout.de>, linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in 2.4.35 when compiled gcc>=4.2.0 and -march=c3
Message-ID: <20070806174536.GA12131@1wt.eu>
References: <200708050856.l758u4ou031651@bongo.freakout.de> <20070805154337.GA4716@1wt.eu> <44e819389656d1465e70ce2e99fb7640@kernel.crashing.org> <20070806132658.GE10999@1wt.eu> <46B75CD0.7080408@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B75CD0.7080408@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 10:39:28AM -0700, H. Peter Anvin wrote:
> Willy Tarreau wrote:
> > 
> > Just to enlighten me on the subject, could you please explain me
> > what is wrong in the code ? Granted I found it awful, but even on
> > the GCC-4.2 page where -fno-toplevel-reorder is explained, it is
> > said that asm statements can be instantiated between functions
> > blocks, which is exactly what is used here.
> > 
> 
> A stray semicolon:
> 
> __attribute__((regparm(0))) void call_do_IRQ(void); __asm__(...
> 
> ... is actually a prototype followed by a top-level asm statement
> (because of the semicolon), *not* a function with a single-statement
> body (which is itself uglier than hell, use braces please...)

I'm well aware of that, even in the example I wrote to reproduce the issue
and posted to gcc's bugzilla, I clearly have one function prototype and a
separate asm statement which contained a label with the function's name.

So in my opinion, the code above is not buggy. It's dirty (though I did
not find how to produce the equivalent in a different manner).

Willy


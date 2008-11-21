Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYKUK2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYKUK2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbYKUK1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:27:53 -0500
Received: from winston.telenet-ops.be ([195.130.137.75]:58836 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbYKUK1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:27:52 -0500
Date: Fri, 21 Nov 2008 11:27:48 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: David Daney <ddaney@caviumnetworks.com>,
       linux-mips <linux-mips@linux-mips.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Make BUG() __noreturn.
In-Reply-To: <20081121100035.3f5a640b@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0811211126420.26004@anakin>
References: <49260E4C.8080500@caviumnetworks.com> <20081121100035.3f5a640b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008, Alan Cox wrote:
> On Thu, 20 Nov 2008 17:26:36 -0800
> David Daney <ddaney@caviumnetworks.com> wrote:
> 
> > MIPS: Make BUG() __noreturn.
> > 
> > Often we do things like put BUG() in the default clause of a case
> > statement.  Since it was not declared __noreturn, this could sometimes
> > lead to bogus compiler warnings that variables were used
> > uninitialized.
> > 
> > There is a small problem in that we have to put a magic while(1); loop to
> > fool GCC into really thinking it is noreturn.  
> 
> That sounds like your __noreturn macro is wrong.
> 
> Try using __attribute__ ((__noreturn__))
> 
> if that works then fix up the __noreturn definitions for the MIPS and gcc
> you have.

Nope, gcc is too smart:

$ cat a.c

int f(void) __attribute__((__noreturn__));

int f(void)
{
}

$ gcc -c -Wall a.c
a.c: In function f:
a.c:6: warning: `noreturn' function does return
$ 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

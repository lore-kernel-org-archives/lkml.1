Return-Path: <linux-kernel-owner+w=401wt.eu-S1752339AbZIINT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbZIINT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 09:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZIINT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 09:19:57 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57559 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750910AbZIINT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 09:19:56 -0400
Date: Wed, 9 Sep 2009 15:20:00 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Roland McGrath <roland@redhat.com>
cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig CROSS_COMPILE option
In-Reply-To: <20090907183801.379228BF3F@magilla.sf.frob.com>
Message-ID: <alpine.LRH.2.00.0909091514460.3208@vixen.sonytel.be>
References: <20090905002947.A4C678BEB1@magilla.sf.frob.com> <20090907130402.GB1595@ucw.cz> <20090907183801.379228BF3F@magilla.sf.frob.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Roland McGrath wrote:
> > Yes that would be very nice. Editing Makefile every time I
> > crosscomppile for arm sucks.
> 
> The other trick I can recommend is to write a GNUmakefile containing:
> 
> ARCH=foo
> CROSS_COMPILE=foo-linux-
> include Makefile

Woow, that's shorter than mine :-)

--------------------------------------------------------------------------------

MAKEARGS = ARCH=powerpc CROSS_COMPILE=ppu- CC="ppu-gcc43 -m32 -mcpu=440"

MAKEFLAGS += --no-print-directory

.PHONY: all $(MAKECMDGOALS)

all	:= $(filter-out all Makefile,$(MAKECMDGOALS))

all:
	$(MAKE) $(MAKEARGS) $(all) -f Makefile

Makefile:;

$(all) %/: all
	@:

--------------------------------------------------------------------------------

Note that in this example I also have to override CC, as (1) ppu-gcc is gcc
version 4.1.1, i.e. too old and (2) ppu-gcc43 defaults to -m64 and -mcpu=cell.

> (GNU make reads GNUmakefile in preference to Makefile.)
> But this manual hackery is still not nearly as nice as the automagic way.

Indeed, putting everything in .config would be more convenient.

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010

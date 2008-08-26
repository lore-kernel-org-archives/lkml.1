Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYHZULh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYHZULh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbYHZUL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:11:28 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:56520 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbYHZUL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:11:28 -0400
Date: Tue, 26 Aug 2008 22:11:25 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-parisc@vger.kernel.org
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: __kernel_suseconds_t is int on PA-RISC (and SPARC64)?
Message-ID: <Pine.LNX.4.64.0808262207450.7910@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently __kernel_suseconds_t is `int' on PA-RISC (and on SPARC64),
while it's `long' on all other platforms.

Is there a specific reason for that?

This causes compiler warnings in the HP SDC Real Time Clock driver,
which is shared between PA-RISC and m68k:

drivers/input/misc/hp_sdc_rtc.c:461: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
drivers/input/misc/hp_sdc_rtc.c:461: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
drivers/input/misc/hp_sdc_rtc.c:468: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
drivers/input/misc/hp_sdc_rtc.c:468: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
drivers/input/misc/hp_sdc_rtc.c:475: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
drivers/input/misc/hp_sdc_rtc.c:475: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
drivers/input/misc/hp_sdc_rtc.c:482: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
drivers/input/misc/hp_sdc_rtc.c:482: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
drivers/input/misc/hp_sdc_rtc.c:489: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
drivers/input/misc/hp_sdc_rtc.c:489: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

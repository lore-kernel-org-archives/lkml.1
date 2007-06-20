Return-Path: <linux-kernel-owner+w=401wt.eu-S932070AbXFTHOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbXFTHOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 03:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759622AbXFTHNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 03:13:54 -0400
Received: from ananke.telenet-ops.be ([195.130.137.78]:33492 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860AbXFTHNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 03:13:54 -0400
Date: Wed, 20 Jun 2007 09:13:52 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Olaf Hering <olaf@aepfle.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: exported fb_find_logo references __initdata
In-Reply-To: <20070619201957.GA21306@aepfle.de>
Message-ID: <Pine.LNX.4.64.0706200913281.16573@anakin>
References: <20070619201957.GA21306@aepfle.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Olaf Hering wrote:
> fb_find_logo() refences a few structs marked as __initdata. The structs
> itself have a member ->data which is marked as __initdata as well.
> scripts/pnmtologo.c write_footer() and write_header() create those
> structs.
> 
> What is the correct fix, and why does it work at all?

commit 70802c60379fb843c485dfd4cab9e8f527d8fe81
Author: Antonino A. Daplas <adaplas@gmail.com>
Date:   Tue May 8 00:38:14 2007 -0700

    fbdev: don't show logo if driver or fbcon are modular
    
    It was always intended for the logo to be drawn only if both fbcon and the
    driver that is mapped to it are both compiled statically.  Currently, if fbc
    is loaded prior to the driver, the logo is not shown.  Reverse the order, an
    the code may attempt to draw the logo which is __initdata.  By accident, thi
    bug is rarely seen because this method of loading the modules is not common
    and secondly, a code in fb_prepare_logo() that checks the height of the logo
    (now a random value) rarely succeeds.
    
    Fix by drawing the logo only if both fbcon and the driver are statically
    compiled.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

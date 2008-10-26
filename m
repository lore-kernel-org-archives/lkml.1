Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbYJZSdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbYJZSdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 14:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYJZSc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 14:32:59 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:55842 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbYJZSc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 14:32:59 -0400
Date: Sun, 26 Oct 2008 19:32:54 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: discarded `.exit.text' debugging?
In-Reply-To: <Pine.LNX.4.64.0810202207140.23258@anakin>
Message-ID: <Pine.LNX.4.64.0810261522350.15317@anakin>
References: <Pine.LNX.4.64.0810202207140.23258@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008, Geert Uytterhoeven wrote:
> Last night I got these in my build logs:
> 
> | `.exit.text' referenced in section `.init.text' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
> | `.exit.text' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
> 
> i.e. not much context. Is there an easy way to find out who's the
> offender?

I also didn't get any section mismatch warnings about them with
CONFIG_DEBUG_SECTION_MISMATCH=y.

So I went the hard way (i.e. maual bisection on CONFIG symbols) and found 2
bogus __exit marks in drivers/rtc/rtc-ds3234.c and drivers/hwmon/w83781d.c.

Patches to fix them have been sent.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

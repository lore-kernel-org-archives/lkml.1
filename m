Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYLNQVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYLNQVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 11:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYLNQVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 11:21:21 -0500
Received: from winston.telenet-ops.be ([195.130.137.75]:55696 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbYLNQVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 11:21:20 -0500
Date: Sun, 14 Dec 2008 17:21:17 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Bombe <aeb@debian.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] amiflop: get rid of sleep_on calls
In-Reply-To: <20081210010219.GB5073@infernal.debian.net>
Message-ID: <Pine.LNX.4.64.0812141719300.5936@anakin>
References: <1228755578-26069-1-git-send-email-aeb@debian.org>
 <Pine.LNX.4.64.0812090927580.29640@anakin> <20081210010219.GB5073@infernal.debian.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008, Andreas Bombe wrote:
> Apart from sleep_on() calls that could be easily converted to
> wait_event() and completion calls amiflop also used a flag in ms_delay()
> and ms_isr() as a custom mutex for ms_delay() without a need for
> explicit unlocking.  I converted that to a standard mutex.
> 
> The replacement for the unconditional sleep_on() in fd_motor_on() is a
> complete_all() together with a INIT_COMPLETION() before the mod_timer()
> call.  It appears to me that fd_motor_on() might be called concurrently
> and fd_select() does not guarantee mutual exclusivity in the case the
> same drive gets selected again.
> 
> Signed-off-by: Andreas Bombe <aeb@debian.org>
> ---
> 
> This version changes the struct semaphore used as mutex into a struct
> mutex.  Still only compile tested.
> 
> I just tried out my Amiga and it appears to be in better shape than
> expected.  So I might get to actually test it when I find the time.  My
> Amiga has no Linux installation so I need to whip up a ramdisk or
> something else sufficient to test it.

I think the good old ELF ramdisk at
ftp://ftp.uni-erlangen.de/pub/unix/Linux/680x0/v2.0/filesys/filesys-ELF-2.0.x-1400K-2.gz
should be sufficient to give it a try...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

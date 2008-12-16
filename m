Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbYLPUZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbYLPUZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759640AbYLPUXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:23:05 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:54788 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759634AbYLPUXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:23:03 -0500
Date: Tue, 16 Dec 2008 21:23:00 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joerg Dorchain <joerg@dorchain.net>
cc: Andreas Bombe <aeb@debian.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amiflop: get rid of sleep_on calls
In-Reply-To: <20081209082608.GA10651@Redstar.dorchain.net>
Message-ID: <Pine.LNX.4.64.0812162119330.29433@anakin>
References: <1228755578-26069-1-git-send-email-aeb@debian.org>
 <20081209082608.GA10651@Redstar.dorchain.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2008, Joerg Dorchain wrote:
> On Mon, Dec 08, 2008 at 04:59:38PM +0000, Andreas Bombe wrote:
> > The replacement for the unconditional sleep_on() in fd_motor_on() is a
> > complete_all() together with a INIT_COMPLETION() before the mod_timer()
> > call.  It appears to me that fd_motor_on() might be called concurrently
> > and fd_select() does not guarantee mutual exclusivity in the case the
> > same drive gets selected again.
> 
> Selecting the same drive repeatly does not matter. The selected
> drive is the one the next command or transfer applies to.
> 
> It is possible to select one drive, start the motor, select the
> next one, start the motor, as long as as trasnfer is tried until
> the drive is up to speed (either by signal or the timeout)
> 
> At first glance, the patch looks ok.

Does that mean I can add your Acked-by?

Anyway, I've applied it to my git repository (to be pushed to kernel.org soon).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

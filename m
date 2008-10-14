Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYJNHYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYJNHYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757361AbYJNHXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:23:49 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:58976 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342AbYJNHXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:23:47 -0400
Date: Tue, 14 Oct 2008 09:23:42 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 17/18] net/rfkill/rfkill-input.c needs <linux/sched.h>
In-Reply-To: <20081013204559.GC28597@khazad-dum.debian.net>
Message-ID: <Pine.LNX.4.64.0810140920320.6220@anakin>
References: <20081013195846.674654386@mail.of.borg> <20081013195922.392078574@mail.of.borg>
 <20081013204559.GC28597@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008, Henrique de Moraes Holschuh wrote:
> On Mon, 13 Oct 2008, Geert Uytterhoeven wrote:
> > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > 
> > For some m68k configs, I get:
> > 
> > | net/rfkill/rfkill-input.c: In function 'rfkill_start':
> > | net/rfkill/rfkill-input.c:208: error: dereferencing pointer to incomplete type
> > 
> > As the incomplete type is `struct task_struct', including <linux/sched.h> fixes
> > it.
> 
> Line 208 is this (in latest Linus mainline and also v2.6.27):
> 
> spin_unlock_irq(&handle->dev->event_lock);
> 
> So we need to include sched.h to everything that uses spin_unlock_irq?  If
> only some variants of m68k need that, shouldn't it have been added on the
> header that defines spin_unlock_irq() on those arches, instead?

Unfortunately that's not possible, due to Include Hell(tm).
Therefore, including <linux/sched.h> is the way this has been fixed in
the past.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbYJWPaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbYJWPaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYJWPaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:30:05 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:53761 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbYJWPaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:30:04 -0400
X-Greylist: delayed 3175 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Oct 2008 11:30:04 EDT
Date: Thu, 23 Oct 2008 17:30:01 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: kernel/trace/trace.c:658: error:
In-Reply-To: <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810231727430.18978@anakin>
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
 <20081023121145.GB27984@x200.localdomain> <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com>
 <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com>
 <49008D12.5090204@gmail.com> <Pine.LNX.4.64.0810231635440.18978@anakin>
 <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808415-835255333-1224775801=:18978"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808415-835255333-1224775801=:18978
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 23 Oct 2008, Frédéric Weisbecker wrote:
> 2008/10/23 Geert Uytterhoeven <geert@linux-m68k.org>:
> > If kernel/trace/trace.c calls irqs_disabled_flags(), it should include
> > the include that defines irqs_disabled_flags(). You should not add it to
> > some other random include.
> >
> > It's also happening on m68k:
> > http://kisskb.ellerman.id.au/kisskb/buildresult/50641/
> 
> The fact is that other archs include this header into their
> asm/system.h. It seems that's because
> they need some non-traced irq_save/restore .
> I wanted to stay in the same approach because future use of
> raw_local_irq could be used elsewhere
> and seem to work perfectly whithout adding special headers on most
> arch. But there will be some
> bug report for each future use of these functions for alpha.... (and
> even m68k as it seems).
> 
> What do you think? Should I let this patch as is or send a new one
> (and one other for m68k).

kernel/trace/trace.c needs to include at least <linux/irqflags.h>, as
that's where irqs_disabled_flags() is defined.

If there are still other issues with the raw_local_irq(), IMHO they should be
fixed separately.

Hmm, what's this doing in <linux/irqflags.h>:
| #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
| ...
| #endif          /* CONFIG_X86 */
                     ^^^^^^^^^^

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808415-835255333-1224775801=:18978--

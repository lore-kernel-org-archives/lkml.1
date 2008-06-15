Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbYFOSnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbYFOSnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 14:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754913AbYFOSnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 14:43:08 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:42074 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbYFOSnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 14:43:06 -0400
Date: Sun, 15 Jun 2008 20:43:02 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>, Peter De Schrijver <p2@debian.org>
cc: Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: could the Apollo support possibly work?
In-Reply-To: <Pine.LNX.4.64.0806151425410.5736@anakin>
Message-ID: <Pine.LNX.4.64.0806152042410.5736@anakin>
References: <20080608190513.GE4048@cs181133002.pp.htv.fi>
 <Pine.LNX.4.64.0806090842490.25145@anakin> <Pine.LNX.4.64.0806151425410.5736@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jun 2008, Geert Uytterhoeven wrote:
> On Mon, 9 Jun 2008, Geert Uytterhoeven wrote:
> > On Sun, 8 Jun 2008, Adrian Bunk wrote:
> > > Nothing seems to set apollo_model (apollo_parse_bootinfo() has no caller).
> > > 
> > > Therefore trying to boot an Apollo machine seems to do:
> > >   arch/m68k/kernel/setup.c:setup_arch()
> > >     arch/m68k/apollo/config.c:config_apollo()
> > >       arch/m68k/apollo/config.c:dn_setup_model() 
> > >         panic()
> > > 
> > > Do I miss anything?
> > 
> > Obviously it should be called from m68k_parse_bootinfo(), but there's no
> > MACH_IS_APOLLO case there. Strange...

[second try, missed the prototype]

Subject: [PATCH] m68k/apollo: Add missing call to apollo_parse_bootinfo()

Add the missing call to apollo_parse_bootinfo(), which had been lost from a
big Apollo support patch by Peter De Schrijver in 1999.

Thanks to Adrian Bunk for noticing!

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/setup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -123,6 +123,7 @@ extern int bvme6000_parse_bootinfo(const
 extern int mvme16x_parse_bootinfo(const struct bi_record *);
 extern int mvme147_parse_bootinfo(const struct bi_record *);
 extern int hp300_parse_bootinfo(const struct bi_record *);
+extern int apollo_parse_bootinfo(const struct bi_record *);
 
 extern void config_amiga(void);
 extern void config_atari(void);
@@ -190,6 +191,8 @@ static void __init m68k_parse_bootinfo(c
 				unknown = mvme147_parse_bootinfo(record);
 			else if (MACH_IS_HP300)
 				unknown = hp300_parse_bootinfo(record);
+			else if (MACH_IS_APOLLO)
+				unknown = apollo_parse_bootinfo(record);
 			else
 				unknown = 1;
 		}

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

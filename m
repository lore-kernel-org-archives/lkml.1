Return-Path: <linux-kernel-owner+w=401wt.eu-S1758441AbXKUHwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441AbXKUHwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 02:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbXKUHwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 02:52:34 -0500
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:36074 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbXKUHwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 02:52:33 -0500
Date: Wed, 21 Nov 2007 08:52:27 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Alejandro Martinez Ruiz <alex@flawedcode.org>
Subject: Re: [patch 02/13] dio: ARRAY_SIZE() cleanup
In-Reply-To: <474355BE.8030409@student.ltu.se>
Message-ID: <Pine.LNX.4.64.0711210851050.5240@anakin>
References: <20071118101336.330321764@mail.of.borg> <20071118101446.793269838@mail.of.borg>
 <474355BE.8030409@student.ltu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Richard Knutsson wrote:
> Geert Uytterhoeven wrote:
> 
> > -#define NUMNAMES (sizeof(names) / sizeof(struct dioname))
> > +#define NUMNAMES ARRAY_SIZE(names)
> 
> Why not replace NUMNAMES?

Good idea! Updated patch below.

---

Subject: dio: ARRAY_SIZE() cleanup

From: Alejandro Martinez Ruiz <alex@flawedcode.org>

dio: ARRAY_SIZE() cleanup

[Geert: eliminate NUMNAMES, as suggested by Richard Knutsson ]

Signed-off-by: Alejandro Martinez Ruiz <alex@flawedcode.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/dio/dio.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/dio/dio.c
+++ b/drivers/dio/dio.c
@@ -88,8 +88,6 @@ static struct dioname names[] = 
 #undef DIONAME
 #undef DIOFBNAME
 
-#define NUMNAMES (sizeof(names) / sizeof(struct dioname))
-
 static const char *unknowndioname 
         = "unknown DIO board -- please email <linux-m68k@lists.linux-m68k.org>!";
 
@@ -97,7 +95,7 @@ static const char *dio_getname(int id)
 {
         /* return pointer to a constant string describing the board with given ID */
 	unsigned int i;
-        for (i = 0; i < NUMNAMES; i++)
+        for (i = 0; i < ARRAY_SIZE(names); i++)
                 if (names[i].id == id) 
                         return names[i].name;
 


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

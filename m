Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbYGQT3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbYGQT3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932428AbYGQTXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:23:10 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:53992 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbYGQTWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:51 -0400
Message-Id: <20080717191755.683570266@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:29 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 22/29] m68k/apollo: Add missing call to apollo_parse_bootinfo()
Content-Disposition: inline; filename=apollo-missing-bootinfo.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing call to apollo_parse_bootinfo(), which had been lost from a
big Apollo support patch by Peter De Schrijver in 1999.

Thanks to Adrian Bunk for noticing!

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/setup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -122,6 +122,7 @@ extern int bvme6000_parse_bootinfo(const
 extern int mvme16x_parse_bootinfo(const struct bi_record *);
 extern int mvme147_parse_bootinfo(const struct bi_record *);
 extern int hp300_parse_bootinfo(const struct bi_record *);
+extern int apollo_parse_bootinfo(const struct bi_record *);
 
 extern void config_amiga(void);
 extern void config_atari(void);
@@ -189,6 +190,8 @@ static void __init m68k_parse_bootinfo(c
 				unknown = mvme147_parse_bootinfo(record);
 			else if (MACH_IS_HP300)
 				unknown = hp300_parse_bootinfo(record);
+			else if (MACH_IS_APOLLO)
+				unknown = apollo_parse_bootinfo(record);
 			else
 				unknown = 1;
 		}

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


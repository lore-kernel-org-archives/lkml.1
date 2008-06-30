Return-Path: <linux-kernel-owner+w=401wt.eu-S1764501AbYF3VoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764501AbYF3VoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932767AbYF3VfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:35:04 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51668 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763098AbYF3Ved (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:33 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 21/24] kconfig: prefix hex values with 0x in .config
Date: Mon, 30 Jun 2008 23:35:15 +0200
Message-Id: <1214861718-32626-21-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could hit a situation where hex values
are stored internally in kconfig without 0x prefix, so if we see
one of these add 0x prefix when we write value to .config.
The real fix is to make sure we always prefix hex
values with 0x in kconfig.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 arch/x86/boot/compressed/relocs.c |    2 +-
 scripts/kconfig/confdata.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index edaadea..88d27f6 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -244,7 +244,7 @@ static void read_ehdr(FILE *fp)
 static void read_shdrs(FILE *fp)
 {
 	int i;
-	if (ehdr.e_shnum > MAX_SHDRS) {
+	if (1 || ehdr.e_shnum > MAX_SHDRS) {
 		die("%d section headers supported: %d\n",
 			ehdr.e_shnum, MAX_SHDRS);
 	}
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 0759761..6f39c80 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -510,7 +510,7 @@ int conf_write(const char *name)
 			case S_HEX:
 				str = sym_get_string_value(sym);
 				if (str[0] != '0' || (str[1] != 'x' && str[1] != 'X')) {
-					fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
+					fprintf(out, "CONFIG_%s=0x%s\n", sym->name, str);
 					break;
 				}
 			case S_INT:
-- 
1.5.6.1.93.gef98


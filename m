Return-Path: <linux-kernel-owner+w=401wt.eu-S933130AbYF3VkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130AbYF3VkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932911AbYF3Ves
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:48 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48263 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254AbYF3Vef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:35 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 23/24] kconfig: make oldconfig is now less chatty
Date: Mon, 30 Jun 2008 23:35:17 +0200
Message-Id: <1214861718-32626-23-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously when running "make oldconfig" we saw all the propmt lines
from kconfig and noone actully read this.

With this patch the user will only see output if there is new symbols.
This will be seen as "make oldconfig" runs which does not generate any output.

A typical run now looks like this:

$ make oldconfig
scripts/kconfig/conf -o arch/x86/Kconfig
$

If a new symbol is found then we restart the config process like this:
$ make oldconfig
scripts/kconfig/conf -o arch/x86/Kconfig
*
* Restart config...
*
*
* General setup
*
Prompt for development and/or incomplete code/drivers (EXPERIMENTAL) [Y/n/?] y
Local version - append to kernel release (LOCALVERSION) []
...

The bahaviour is similar to what we know when running the implicit
oldconfig target "make silentoldconfig".
"make silentoldconfig" are run as part of the kernel build process
if the configuration has changed.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 scripts/kconfig/conf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index bd2a27e..6cdaa0c 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -590,10 +590,10 @@ int main(int ac, char **av)
 		conf_set_all_new_symbols(def_random);
 		break;
 	case ask_silent:
+	case ask_new:
 		if (conf_silent_update())
 			exit(1);
 		break;
-	case ask_new:
 	case ask_all:
 	case set_default:
 		if (conf_update())
-- 
1.5.6.1.93.gef98


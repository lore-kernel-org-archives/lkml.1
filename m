Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbXLQEcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbXLQEcW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 23:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbXLQEcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 23:32:14 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:18800 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751785AbXLQEcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 23:32:12 -0500
Date: Mon, 17 Dec 2007 13:31:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: kconfig: Obey KCONFIG_ALLCONFIG choices with randconfig.
Message-ID: <20071217043147.GA15701@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	Roman Zippel <zippel@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when using KCONFIG_ALLCONFIG with randconfig the choice options
are clobbered. As recommended by Roman, this adds an is_new test to see
whether to select a new option or obey the existing one.

This is a resend of the earlier patch a couple of weeks ago, since there
was no reply. Original thread is at http://lkml.org/lkml/2007/11/28/94

It would be nice to have this for 2.6.24.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 scripts/kconfig/conf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index a38787a..8d6f174 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -374,7 +374,8 @@ static int conf_choice(struct menu *menu)
 				continue;
 			break;
 		case set_random:
-			def = (random() % cnt) + 1;
+			if (is_new)
+				def = (random() % cnt) + 1;
 		case set_default:
 		case set_yes:
 		case set_mod:

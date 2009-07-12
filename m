Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbZGLIMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbZGLIMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 04:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZGLIM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 04:12:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:53907 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbZGLIMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 04:12:24 -0400
From: Cheng Renquan <crq@kernel.org>
To: linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       crquan@gmail.com
Subject: [PATCH 1/6] add symbol value to help find the real depend
Date: Sun, 12 Jul 2009 16:11:43 +0800
Message-Id: <1247386308-19628-2-git-send-email-crq@kernel.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247386308-19628-1-git-send-email-crq@kernel.org>
References: <1247386308-19628-1-git-send-email-crq@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Jul 2009 08:11:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

kbuild-menuconfig-display-depend-value.patch

Sometimes when configuring need to disable some unused item, but the item is
selected by many other items, it's hard to find the real dependency which
selected it, This patch add every symbol's value accompanied to make it
possible to find the real dependency easily.

An example is CONFIG_RFKILL,

  ---------------------- RF switch subsystem support ----------------------
  | CONFIG_RFKILL:                                                        |
  |                                                                       |
  | Say Y here if you want to have control over RF switches               |
  | found on many WiFi and Bluetooth cards.                               |
  |                                                                       |
  | To compile this driver as a module, choose M here: the                |
  | module will be called rfkill.                                         |
  |                                                                       |
  | Symbol: RFKILL [=m]                                                   |
  | Prompt: RF switch subsystem support                                   |
  |   Defined at net/rfkill/Kconfig:4                                     |
  |   Depends on: NET [=y]                                                |
  |   Location:                                                           |
  |     -> Networking support (NET [=y])                                  |
  |   Selected by: IWLCORE [=n] && NETDEVICES [=y] && !S390 [=S390] && PC |
  |                                                                       |
  ----------------------------------------------------------------( 99%)---

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 scripts/kconfig/expr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/expr.c b/scripts/kconfig/expr.c
index 579ece4..cd8a2f0 100644
--- a/scripts/kconfig/expr.c
+++ b/scripts/kconfig/expr.c
@@ -1098,6 +1098,8 @@ void expr_fprint(struct expr *e, FILE *out)
 static void expr_print_gstr_helper(void *data, struct symbol *sym, const char *str)
 {
 	str_append((struct gstr*)data, str);
+	if (sym)
+		str_printf((struct gstr*)data, " [=%s]", sym_get_string_value(sym));
 }
 
 void expr_gstr_print(struct expr *e, struct gstr *gs)
-- 
1.6.3.3


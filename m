Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbXKHQhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbXKHQhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 11:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758748AbXKHQhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 11:37:40 -0500
Received: from web52011.mail.re2.yahoo.com ([206.190.48.27]:36908 "HELO
	web52011.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754642AbXKHQhk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 11:37:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=X7trsdNlCMFBD3MiKm1wWwr3w7sretZ31TuCptoErsIOjddIY0X7wSx5OJBZAwUMz7reFl1SafQ8HoXEB8do60zmSVpUg4st4Zqi+LbiuikzmJ6itJKtUXOhTipWI3FBz1N60qK8T+W1vo/NS49Hn0Wtj/R3Mj97DvlMsF76s/M=;
X-YMail-OSG: gZlx7Z4VM1lRjBLldsdT3sll0JRwIMZNm_x8EnTtwxPH4wBsSXZyRJtmd6iPqzTzhwGoV7BVf8cJoLrHjWw.lNtOKCgrrxs8GDcR2h7IYlj8BOQvx8iK2LdFreaGE1tE1N_4m.HAomoNgtXrPGWS.JmGxQ--
X-Mailer: YahooMailRC/818.15 YahooMailWebService/0.7.152
Date: Thu, 8 Nov 2007 08:37:38 -0800 (PST)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [PATCH] module: fix and elaborate comments
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <11879.6800.qm@web52011.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Fix and elaborate comments.

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
---

--- a/kernel/module.c    2007-11-08 18:21:18.762437500 +0200
+++ b/kernel/module.c    2007-11-08 18:25:57.961364500 +0200
@@ -81,7 +81,8 @@ int unregister_module_notifier(struct no
 }
 EXPORT_SYMBOL(unregister_module_notifier);
 
-/* We require a truly strong try_module_get() */
+/* We require a truly strong try_module_get(): 0 means failure due to
+   ongoing or failed initialization etc. */
 static inline int strong_try_module_get(struct module *mod)
 {
     if (mod && mod->state == MODULE_STATE_COMING)
@@ -952,7 +953,8 @@ static unsigned long resolve_symbol(Elf_
     ret = __find_symbol(name, &owner, &crc,
             !(mod->taints & TAINT_PROPRIETARY_MODULE));
     if (ret) {
-        /* use_module can fail due to OOM, or module unloading */
+        /* use_module can fail due to OOM,
+           or module initialization or unloading */
         if (!check_version(sechdrs, versindex, name, mod, crc) ||
             !use_module(mod, owner))
             ret = 0;
@@ -1369,7 +1371,7 @@ dup:
     return ret;
 }
 
-/* Change all symbols so that sh_value encodes the pointer directly. */
+/* Change all symbols so that st_value encodes the pointer directly. */
 static int simplify_symbols(Elf_Shdr *sechdrs,
                 unsigned int symindex,
                 const char *strtab,





       __________________________________  Ihre erste Baustelle? Wissenswertes für Bastler und Hobby Handwerker. www.yahoo.de/clever

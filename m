Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbXIALkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbXIALkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 07:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbXIALkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 07:40:39 -0400
Received: from web52005.mail.re2.yahoo.com ([206.190.49.252]:42056 "HELO
	web52005.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753351AbXIALki convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 07:40:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=OJlesUFq2GTsF89j4NvEKkY+6/r/2+kfe/ryWsFKZysqE5HL0J4DsXGMTbcI6/QidZpzhZMFAn0XQOkK3Y1iMyoyeThRJ2XNq87E0meEksOKarZuwg0u6TIvpudtaS8jzcqMvBZaL3zbeLMoFD0Oe1Rsvdf+xv6fnh8zK29+tGs=;
X-YMail-OSG: qWmPilwVM1nxY_SFFqujvJBgcGEv9AukcbkoRkmlwpP5FNnFn9sIS.e3XqDf7SR.v7QQGi7x1xRNfTuqaE3UeZqomBQkiRrBGMZuR2708cLYAlyyBlshavwYWl0jdKFylpDg7SQfZJKgjTOnrBdGPqcodA--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Sat, 1 Sep 2007 04:40:37 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [PATCH] [Bugme-new] [Bug 8957] New: Exported functions and variables
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, bugme-daemon@kernel-bugs.osdl.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <698763.85538.qm@web52005.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a kernel/module.c 
Linux 2.6.23-rc5 documentation patch that adds more explanation and corrects a spelling error.

--- kernel/module.c   2007-09-01 14:15:06.131101500 +0300
+++ patched-kernel/module.c 2007-09-01 14:15:27.502780500 +0300
@@ -80,7 +80,8 @@ int unregister_module_notifier(struct no
 }
 EXPORT_SYMBOL(unregister_module_notifier);
 
-/* We require a truly strong try_module_get() */
+/* We require a truly strong try_module_get(): 0 means failure due to 
+   ongoing or failed initialization etc. */
 static inline int strong_try_module_get(struct module *mod)
 {
     if (mod && mod->state == MODULE_STATE_COMING)
@@ -957,7 +958,8 @@ static unsigned long resolve_symbol(Elf_
     ret = __find_symbol(name, &owner, &crc,
             !(mod->taints & TAINT_PROPRIETARY_MODULE));
     if (ret) {
-        /* use_module can fail due to OOM, or module unloading */
+        /* use_module can fail due to OOM, or module
+           initialization or unloading */
         if (!check_version(sechdrs, versindex, name, mod, crc) ||
             !use_module(mod, owner))
             ret = 0;
@@ -1270,7 +1272,7 @@ dup:
     return ret;
 }
 
-/* Change all symbols so that sh_value encodes the pointer directly. */
+/* Change all symbols so that st_value encodes the pointer directly. */
 static int simplify_symbols(Elf_Shdr *sechdrs,
                 unsigned int symindex,
                 const char *strtab,


Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>




      Wissenswertes für Bastler und Hobby Handwerker. BE A BETTER HEIMWERKER! www.yahoo.de/clever

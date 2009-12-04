Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbZLDSne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbZLDSne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbZLDSne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:43:34 -0500
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:48268 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbZLDSnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:43:33 -0500
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Dec 2009 13:43:33 EST
Message-ID: <23753252.369201259951904278.JavaMail.defaultUser@defaultHost>
Date: Fri, 4 Dec 2009 19:38:24 +0100 (CET)
From: "matteo_cortese@fastwebnet.it" <matteo_cortese@fastwebnet.it>
Reply-To: "matteo_cortese@fastwebnet.it" <matteo_cortese@fastwebnet.it>
To: linux-kbuild@vger.kernel.org
Subject: [PATCH] make gconfig: fix the "(NEW)" string
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: 20.142.116.34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The string "(NEW)" is added to those options that are not present in the
 current config file, thus looking as new features. Alas, the logic seem
s to be inverted.
 

Signed-off-by: Matteo Cortese <matteo_cortese@fastwebnet.it>
------

diff -u linux-source-2.6.26-old/scripts/kconfig/gconf.c linux-source-2.6
.26/scripts/kconfig/gconf.c
--- linux-source-2.6.26-old/scripts/kconfig/gconf.c	2008-07-13 21:51:29.
000000000 +0000
+++ linux-source-2.6.26/scripts/kconfig/gconf.c	2009-01-03 00:52:57.0000
00000 +0000
@@ -1174,7 +1174,7 @@
 
 	row[COL_OPTION] =
 	    g_strdup_printf("%s %s", _(menu_get_prompt(menu)),
-			    sym && sym_has_value(sym) ? "(NEW)" : "");
+			    sym && !sym_has_value(sym) ? "(NEW)" : "");
 
 	if (show_all && !menu_is_visible(menu))
 		row[COL_COLOR] = g_strdup("DarkGray");


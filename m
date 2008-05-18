Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbYERVKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbYERVKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 17:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbYERVK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 17:10:27 -0400
Received: from smtp27.orange.fr ([80.12.242.95]:41082 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbYERVK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 17:10:26 -0400
X-ME-UUID: 20080518211024859.D1B751C00086@mwinf2714.orange.fr
Subject: [PATCH 1/1] kconfig: incorrect 'len' field initialisation ?
From: "Christophe Jaillet" <christophe.jaillet@wanadoo.fr>
To: "cj" <christophe.jaillet@wanadoo.fr>,
       "linux" <linux-kernel@vger.kernel.org>, <zippel@linux-m68k.org>,
       <linux-kbuild@vger.kernel.org>
Date: Sun, 18 May 2008 23:10:24 +0200
Content-Type: text/plain
X-Mailer: email v2.5.1 (CYGWIN_NT-5.0 1.5.25(0.156/4/2) i686 [http://email.cleancode.org])
X-Antivirus: avast! (VPS 080518-1, 18/05/2008), Outbound message
X-Antivirus-Status: Clean
Message-Id: <20080518211024.D1B751C00086@mwinf2714.orange.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Hi, here is a patch against /scripts/kconfig/util.c :
	
1) The field 'len' of the 'gstr' structure seems to track the size of the memory 
already allocated for the "growable string". So the value of this field should be
the same as the 'malloc()' just above, shouldn't it ?



Note: this patch is based on 'linux-2.6.25.tar.bz2'

Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

---

--- linux 2.6.25/scripts/kconfig/util.c	2008-04-17 04:49:44.000000000 +0200
+++ linux 2.6.25/scripts/kconfig/util.c.cj	2008-05-18 22:56:14.000000000 +0200
@@ -77,7 +77,7 @@ struct gstr str_new(void)
 {
 	struct gstr gs;
 	gs.s = malloc(sizeof(char) * 64);
-	gs.len = 16;
+	gs.len = 64;
 	strcpy(gs.s, "\0");
 	return gs;
 }



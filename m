Return-Path: <linux-kernel-owner+w=401wt.eu-S932749AbXAaJ1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbXAaJ1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 04:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932788AbXAaJ1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 04:27:11 -0500
Received: from raven.upol.cz ([158.194.120.4]:40666 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932749AbXAaJ1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 04:27:10 -0500
Date: Wed, 31 Jan 2007 09:35:42 +0000
To: LKML <linux-kernel@vger.kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Bastian Blank <bastian@waldi.eu.org>,
       Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@osdl.org>
Subject: [patch] update for (kbuild: correctly skip tilded backups in localversion files)
Message-ID: <20070131093542.GA3471@flower.upol.cz>
References: <20070131071103.GA3295@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131071103.GA3295@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild: finally correctly skip tilded backups in localversion files


Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
---

 Final addition. Why i want to maximize usage of shell, rather, than
 `make'? Just because i think, it's more portable, clear way.

 Thanks.

--- linux-2.6.20-rc6/Makefile~4tilde-backups~	2007-01-31 07:46:18.696404500 +0100
+++ linux-2.6.20-rc6/Makefile	2007-01-31 10:19:18.406100500 +0100
@@ -788,10 +788,10 @@ $(vmlinux-dirs): prepare scripts
 # scripts/setlocalversion and add the appropriate checks as needed.
 
-localversion = $(objtree)/localversion	    $(srctree)/localversion
-ext_versions = $(objtree)/localversion[^~]* $(srctree)/localversion[!~]*
-versions = $(localversion) $(ext_versions)
-localver = $(subst $(space),, \
-	   $(shell cat /dev/null $(sort $(wildcard $(versions)))) \
-	   $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
+pattern = ".*/localversion[^~]*"
+string  = $(shell cat /dev/null \
+	   `find $(objtree) $(srctree) -maxdepth 1 -regex $(pattern) | sort`)
+
+localver = $(subst $(space),, $(string) \
+			      $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
 
 # If CONFIG_LOCALVERSION_AUTO is set scripts/setlocalversion is called

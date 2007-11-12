Return-Path: <linux-kernel-owner+w=401wt.eu-S1760055AbXKLVBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055AbXKLVBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 16:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbXKLU7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 15:59:09 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39815 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbXKLU66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 15:58:58 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config targets
Date: Mon, 12 Nov 2007 22:00:34 +0100
Message-Id: <1194901236-22820-11-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1194901236-22820-10-git-send-email-sam@ravnborg.org>
References: <20071112205451.GA22528@uranus.ravnborg.org>
 <1194901236-22820-1-git-send-email-sam@ravnborg.org>
 <1194901236-22820-2-git-send-email-sam@ravnborg.org>
 <1194901236-22820-3-git-send-email-sam@ravnborg.org>
 <1194901236-22820-4-git-send-email-sam@ravnborg.org>
 <1194901236-22820-5-git-send-email-sam@ravnborg.org>
 <1194901236-22820-6-git-send-email-sam@ravnborg.org>
 <1194901236-22820-7-git-send-email-sam@ravnborg.org>
 <1194901236-22820-8-git-send-email-sam@ravnborg.org>
 <1194901236-22820-9-git-send-email-sam@ravnborg.org>
 <1194901236-22820-10-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The variable K64BIT can now be used to select the
value of CONFIG_64BIT.

This is for example useful for powerpc to generate
allmodconfig for both bit sizes - like this:
make ARCH=powerpc K64BIT=y
make ARCH=powerpc K64BIT=n

To use this the Kconfig file must use "64BIT" as the
config value to select between 32 and 64 bit.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 README                 |    2 ++
 scripts/kconfig/conf.c |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/README b/README
index 159912c..592f8a2 100644
--- a/README
+++ b/README
@@ -194,6 +194,8 @@ CONFIGURING the kernel:
    "make *config" checks for a file named "all{yes/mod/no/random}.config"
    for symbol values that are to be forced.  If this file is not found,
    it checks for a file named "all.config" to contain forced values.
+   Finally it checks the environment variable K64BIT and if found, sets
+   the config symbol "64BIT" to the value of the K64BIT variable.
    
 	NOTES on "make config":
 	- having unnecessary drivers will make the kernel bigger, and can
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index a38787a..c6bee85 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -591,6 +591,7 @@ int main(int ac, char **av)
 			conf_read_simple(name, S_DEF_USER);
 		else if (!stat("all.config", &tmpstat))
 			conf_read_simple("all.config", S_DEF_USER);
+		conf_set_env_sym("K64BIT", "64BIT", S_DEF_USER);
 		break;
 	default:
 		break;
-- 
1.5.3.4.1157.g0e74-dirty


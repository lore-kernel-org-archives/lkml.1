Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbZKUWL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbZKUWL4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 17:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZKUWLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 17:11:55 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49808 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699AbZKUWLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 17:11:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Sh5qXuTnoq6+y+rAujQ+kN7jsndXQCExOyevx7B7oTCToDoRRqrgQMbmuS2kLmoNle
         GkfKvGfChrLYlM8WhrdN+mqgUja5rMZbLxprhC3aYnfstQ7qamplhm7JCmiHrtMkiRAL
         kPlacv6IJYV1ZyRYdftuKV5YNdmhUV/PFpi1o=
Message-ID: <4B0868B4.6000605@gmail.com>
Date: Sat, 21 Nov 2009 23:24:52 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, paul@pwsan.com
Subject: [PATCH] OMAP: return PTR_ERR rather than IS_ERR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IS_ERR returns only 1 or 0, and the functions return a negative
error in other cases anyways.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/arm/mach-omap2/powerdomain.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

Inspired by a patch from Julia Lawall
Can be found with `git grep -n -E "return IS_ERR\([^?]*$"'

diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
index f00289a..a5a2811 100644
--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -480,7 +480,7 @@ int pwrdm_add_wkdep(struct powerdomain *pwrdm1, struct powerdomain *pwrdm2)
 	if (IS_ERR(p)) {
 		pr_debug("powerdomain: hardware cannot set/clear wake up of "
 			 "%s when %s wakes up\n", pwrdm1->name, pwrdm2->name);
-		return IS_ERR(p);
+		return PTR_ERR(p);
 	}
 
 	pr_debug("powerdomain: hardware will wake up %s when %s wakes up\n",
@@ -513,7 +513,7 @@ int pwrdm_del_wkdep(struct powerdomain *pwrdm1, struct powerdomain *pwrdm2)
 	if (IS_ERR(p)) {
 		pr_debug("powerdomain: hardware cannot set/clear wake up of "
 			 "%s when %s wakes up\n", pwrdm1->name, pwrdm2->name);
-		return IS_ERR(p);
+		return PTR_ERR(p);
 	}
 
 	pr_debug("powerdomain: hardware will no longer wake up %s after %s "
@@ -550,7 +550,7 @@ int pwrdm_read_wkdep(struct powerdomain *pwrdm1, struct powerdomain *pwrdm2)
 	if (IS_ERR(p)) {
 		pr_debug("powerdomain: hardware cannot set/clear wake up of "
 			 "%s when %s wakes up\n", pwrdm1->name, pwrdm2->name);
-		return IS_ERR(p);
+		return PTR_ERR(p);
 	}
 
 	return prm_read_mod_bits_shift(pwrdm1->prcm_offs, PM_WKDEP,
@@ -584,7 +584,7 @@ int pwrdm_add_sleepdep(struct powerdomain *pwrdm1, struct powerdomain *pwrdm2)
 		pr_debug("powerdomain: hardware cannot set/clear sleep "
 			 "dependency affecting %s from %s\n", pwrdm1->name,
 			 pwrdm2->name);
-		return IS_ERR(p);
+		return PTR_ERR(p);
 	}
 
 	pr_debug("powerdomain: will prevent %s from sleeping if %s is active\n",
@@ -623,7 +623,7 @@ int pwrdm_del_sleepdep(struct powerdomain *pwrdm1, struct powerdomain *pwrdm2)
 		pr_debug("powerdomain: hardware cannot set/clear sleep "
 			 "dependency affecting %s from %s\n", pwrdm1->name,
 			 pwrdm2->name);
-		return IS_ERR(p);
+		return PTR_ERR(p);
 	}
 
 	pr_debug("powerdomain: will no longer prevent %s from sleeping if "
@@ -666,7 +666,7 @@ int pwrdm_read_sleepdep(struct powerdomain *pwrdm1, struct powerdomain *pwrdm2)
 		pr_debug("powerdomain: hardware cannot set/clear sleep "
 			 "dependency affecting %s from %s\n", pwrdm1->name,
 			 pwrdm2->name);
-		return IS_ERR(p);
+		return PTR_ERR(p);
 	}
 
 	return prm_read_mod_bits_shift(pwrdm1->prcm_offs, OMAP3430_CM_SLEEPDEP,

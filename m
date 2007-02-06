Return-Path: <linux-kernel-owner+w=401wt.eu-S965110AbXBFQJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965110AbXBFQJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965041AbXBFQJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:09:56 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:59552 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964934AbXBFQJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:09:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=JuopHSHKTu5JzdmKVSrmZHtZqX3CiQeOUvWX7OCTDLXMtHIa+JsGGz+MiMeXkdz+pzFroxQolfgJkPaFFblTH7nhqr1g5UVBPXcfGJuFN71ADY9CpZkgdzQsqueYsAmthrlUrbbebE80jbg2tRT9Tj81M+/xVW93R1hf7jujE8M=
Date: Tue, 6 Feb 2007 18:09:33 +0200
To: johnpol@2ka.mipt.ru
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20] w1: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206160933.GP8991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206160204.GA8991@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index b022fff..732db47 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -141,7 +141,7 @@ static inline int w1_convert_temp(u8 rom[9], u8 fid)
 {
 	int i;
 
-	for (i=0; i<sizeof(w1_therm_families)/sizeof(w1_therm_families[0]); ++i)
+	for (i = 0; i < ARRAY_SIZE(w1_therm_families); ++i)
 		if (w1_therm_families[i].f->fid == fid)
 			return w1_therm_families[i].convert(rom);
 
@@ -238,7 +238,7 @@ static int __init w1_therm_init(void)
 {
 	int err, i;
 
-	for (i=0; i<sizeof(w1_therm_families)/sizeof(w1_therm_families[0]); ++i) {
+	for (i = 0; i < ARRAY_SIZE(w1_therm_families); ++i) {
 		err = w1_register_family(w1_therm_families[i].f);
 		if (err)
 			w1_therm_families[i].broken = 1;
@@ -251,7 +251,7 @@ static void __exit w1_therm_fini(void)
 {
 	int i;
 
-	for (i=0; i<sizeof(w1_therm_families)/sizeof(w1_therm_families[0]); ++i)
+	for (i = 0; i < ARRAY_SIZE(w1_therm_families); ++i)
 		if (!w1_therm_families[i].broken)
 			w1_unregister_family(w1_therm_families[i].f);
 }


-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com

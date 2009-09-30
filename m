Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbZI3MNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbZI3MNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbZI3MNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:13:50 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34561 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbZI3MNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:13:49 -0400
Message-ID: <4AC34B83.6090402@canonical.com>
Date: Wed, 30 Sep 2009 14:13:55 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Peter Feuerer <peter@piie.net>
CC: Borislav Petkov <petkovbb@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] acerhdf: Limit modalias matching to supported boards
Content-Type: multipart/mixed;
 boundary="------------000407040001020406000104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000407040001020406000104
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

We got reports of acerhdf issuing warnings on Acer laptops other than Aspire 
Ones. Looking at the dmi match this sounds a bit to generic. IOW the module 
gets loaded on any Acer laptop. After the following patch the module gets still 
loaded on my Aspire One but not on the reported other laptop.
The same change might be helpful for the other two dmi matches, but I had no 
way of testing.

-Stefan


--------------000407040001020406000104
Content-Type: text/x-diff;
 name="0001-acerhdf-Limit-modalias-matching-to-supporte.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-acerhdf-Limit-modalias-matching-to-supporte.patch"

>From 389f61f7e66ce615dc6418cb856e167edaa74b42 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Mon, 28 Sep 2009 17:11:29 +0000
Subject: [PATCH] UBUNTU: acerhdf: Limit modalias matching to supported boards

BugLink: https://bugs.launchpad.net/ubuntu/+bug/435958

The module alias currently matches any Acer computer but when loaded the
BIOS checks will only succeed on Aspire One models. This causes a invalid
BIOS warning for all other models (seen on Aspire 4810T).
This is not fatal but worries users that see this message. Limiting the
moule alias to models starting with AOA. Probably the same change should be
made for the two other entries.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/platform/x86/acerhdf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index aa298d6..763f233 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -629,7 +629,7 @@ static void __exit acerhdf_exit(void)
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Peter Feuerer");
 MODULE_DESCRIPTION("Aspire One temperature and fan driver");
-MODULE_ALIAS("dmi:*:*Acer*:*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
 MODULE_ALIAS("dmi:*:*Gateway*:*:");
 MODULE_ALIAS("dmi:*:*Packard Bell*:*:");
 
-- 
1.5.4.5


--------------000407040001020406000104--

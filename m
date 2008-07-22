Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYGVVPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYGVVPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbYGVVOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:14:25 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:36945 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbYGVVOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=KlbiyfjNXeJqM5ZOqf0xIgJkHK5hAIhBq/mDdYfROj4hocbrrBidfCjjwYywYXgqGc
         WqkW4fz/NQ4LIuuxNbzli715eB3dR52VXpJl58wlbNm8pB46xoOK2NL67YskkQJnec0m
         AKsWgRQa3fOPbJMhqKHb4w5DJwDhjiA2nD2JI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jul 2008 23:12:13 +0200
Message-Id: <20080722211213.20478.17317.sendpatchset@localhost.localdomain>
In-Reply-To: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
References: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/10] ide: fix ide_fix_driveid()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix byte-swapping for id->words161_175[], id->words206_254[]
and id->words206_254[].

[ Luckily all words previously left in LE byte-order are marked as
  reserved so this fix shouldn't affect user-space applications. ]

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -484,11 +484,11 @@ void ide_fix_driveid (struct hd_driveid 
 	for (i = 0; i < 3; i++)
 		id->words157_159[i] = __le16_to_cpu(id->words157_159[i]);
 	id->cfa_power      = __le16_to_cpu(id->cfa_power);
-	for (i = 0; i < 14; i++)
+	for (i = 0; i < 15; i++)
 		id->words161_175[i] = __le16_to_cpu(id->words161_175[i]);
-	for (i = 0; i < 31; i++)
+	for (i = 0; i < 30; i++)
 		id->words176_205[i] = __le16_to_cpu(id->words176_205[i]);
-	for (i = 0; i < 48; i++)
+	for (i = 0; i < 49; i++)
 		id->words206_254[i] = __le16_to_cpu(id->words206_254[i]);
 	id->integrity_word  = __le16_to_cpu(id->integrity_word);
 # else

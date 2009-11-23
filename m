Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbZKWSyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbZKWSyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZKWSyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:54:02 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50856 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZKWSyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:54:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=h1W3VocXpZHH/x6WZ+JboXFoJTq9Jc6hqpcSNczhoAlDxgqs1bR5kPJ8ghMlK2L5/O
         yrmtjGvX1jlI9dtPxKnitGCjwvAiAccUJNv4tb/ejmvZp6zl0iLiNfwvDqcgfHP0H7Qf
         n6eL4nZvI2vSJ2f6dvo+POtwG21fMpy0DyWRY=
MIME-Version: 1.0
Date: Mon, 23 Nov 2009 18:54:06 +0000
Message-ID: <6278d2220911231054r15891be8k8f8130fd47cddca2@mail.gmail.com>
Subject: [patch] twl4030: fix ELF section mismatch...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since twl4030_probe is only called from functions in the init ELF
section, annotate it so.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

---
diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index a1c47ee..2fe514d 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -763,7 +763,7 @@ static int twl4030_remove(struct i2c_client *client)
 }

 /* NOTE:  this driver only handles a single twl4030/tps659x0 chip */
-static int
+static int __init
 twl4030_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	int				status;
-- 
Daniel J Blueman

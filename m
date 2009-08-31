Return-Path: <linux-kernel-owner+w=401wt.eu-S1752431AbZHaI0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbZHaI0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbZHaI0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:26:39 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:42682 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbZHaI0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:26:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=mxTa+IXfRILXbaXshHTA9dnqWtgBf0f52TpMlUtmKvgQ3Yrx3DnpKNuAuglvfziMPq
         xQkmzbddcCDZ9/8w0cSoYDd3oRUj/cdm8nmfKCMVVCKq6zAvAbWfo9YHLaPYSjnVP3sc
         gHd7g5fFb0V/P9x4vZPMba9XGJu7AK6ywT/gg=
Message-ID: <4A9B8A8F.5020600@gmail.com>
Date: Mon, 31 Aug 2009 10:32:15 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] gru: allocation may fail in quicktest1()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The allocation may fail.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
index 79689b1..766e21e 100644
--- a/drivers/misc/sgi-gru/grukservices.c
+++ b/drivers/misc/sgi-gru/grukservices.c
@@ -937,6 +937,8 @@ static int quicktest1(unsigned long arg)
 
 	/* Need  1K cacheline aligned that does not cross page boundary */
 	p = kmalloc(4096, 0);
+	if (p == NULL)
+		return -ENOMEM;
 	mq = ALIGNUP(p, 1024);
 	memset(mes, 0xee, sizeof(mes));
 	dw = mq;

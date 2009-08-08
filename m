Return-Path: <linux-kernel-owner+w=401wt.eu-S1751643AbZHHPJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbZHHPJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbZHHPJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:09:53 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:43525 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZHHPJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=nYDPnuL4Lzk1Sdo5z5Rk0tGC87MUC4IBKaci7ZYfPEnIagY/3mDAyYfFcw1vrShNRh
         CvJVmwX36EGc5e6f2Srt1aDQRDMGYRKn4hTcofHFiyROLPQBLFQa9rWLCcLTioZT+46z
         L7rXHkX37eFyDIJGN9F82iU7IBxk5rFX02Nw4=
Message-ID: <4A7D961A.1020303@gmail.com>
Date: Sat, 08 Aug 2009 17:13:30 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] applicom: Prevent unsigned wrap in ac_interrupt()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned i wraps if this occurs in the first iteration.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Or do we know this can't happen?

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 73a0765..0df3e12 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -670,7 +670,7 @@ static irqreturn_t ac_interrupt(int vec, void *dev_instance)
 			}
 			Dummy = readb(apbs[i].RamIO + VERS);
 
-			if(readb(apbs[i].RamIO + RAM_IT_TO_PC)) {
+			if(i && readb(apbs[i].RamIO + RAM_IT_TO_PC)) {
 				/* There's another int waiting on this card */
 				spin_unlock(&apbs[i].mutex);
 				i--;

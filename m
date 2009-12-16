Return-Path: <linux-kernel-owner+w=401wt.eu-S933993AbZLPNmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993AbZLPNmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 08:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933931AbZLPNmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 08:42:23 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:38359 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904AbZLPNmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 08:42:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZllRMX+XZQVnfEMvaw5yz+ln+1tDPtPif7xGw+2x0fomQpvcMGeXn5q9hmLEH+WdhL
         4OKljskFD7r4aU12+Sqh0b0EiiXrg0UjKzPQa3rfyOjHksWYSzPaKYdoDFe91A+20TBf
         imXCk50otiywVUGQvqdyukxIOadqDPxtQDXGE=
Message-ID: <4B28E42F.9000209@gmail.com>
Date: Wed, 16 Dec 2009 14:44:15 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, amit.kucheria@verdurent.com
Subject: Re: [PATCH] mfd: Fix test of unsigned in twl4030_configure_resource()
References: <4B28E3A4.1010601@gmail.com>
In-Reply-To: <4B28E3A4.1010601@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devgroup is unsigned so the test did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

see
vi arch/arm/mach-omap2/board-rx51-peripherals.c +512

Oops, missed some in previous patch.

Roel

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index d423e0c..cc984a5 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -335,7 +335,7 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
 		return err;
 	}
 
-	if (rconfig->devgroup >= 0) {
+	if (rconfig->devgroup != -1) {
 		grp &= ~DEVGROUP_MASK;
 		grp |= rconfig->devgroup << DEVGROUP_SHIFT;
 		err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
@@ -355,12 +355,12 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
 		return err;
 	}
 
-	if (rconfig->type >= 0) {
+	if (rconfig->type != -1) {
 		type &= ~TYPE_MASK;
 		type |= rconfig->type << TYPE_SHIFT;
 	}
 
-	if (rconfig->type2 >= 0) {
+	if (rconfig->type2 != -1) {
 		type &= ~TYPE2_MASK;
 		type |= rconfig->type2 << TYPE2_SHIFT;
 	}

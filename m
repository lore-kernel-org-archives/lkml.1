Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbZBIVmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbZBIVmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZBIVmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:42:31 -0500
Received: from kandzendo.ru ([195.178.208.66]:34281 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbZBIVma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:42:30 -0500
Date: Tue, 10 Feb 2009 00:42:17 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ian Dall <ian@beware.dropbear.id.au>
Subject: [1/1] w1: w1 temp calculation overflow fix.
Message-ID: <20090209214217.GA14958@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Dall <ian@beware.dropbear.id.au>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 2c8dff9..1ed3d55 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -115,7 +115,7 @@ static struct w1_therm_family_converter w1_therm_families[] = {
 
 static inline int w1_DS18B20_convert_temp(u8 rom[9])
 {
-	s16 t = (rom[1] << 8) | rom[0];
+	int t = ((s16)rom[1] << 8) | rom[0];
 	t = t*1000/16;
 	return t;
 }


-- 
	Evgeniy Polyakov

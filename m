Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbXJXAex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbXJXAex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 20:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbXJXAeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 20:34:46 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:44545 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbXJXAep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 20:34:45 -0400
Message-ID: <471E9322.1030408@tiscali.nl>
Date: Wed, 24 Oct 2007 02:34:42 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/?] Unlock when sn_oemdata can't be extended
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Unlock when sn_oemdata can't be extended
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/ia64/sn/kernel/mca.c b/arch/ia64/sn/kernel/mca.c
index 3db62f2..868c9aa 100644
--- a/arch/ia64/sn/kernel/mca.c
+++ b/arch/ia64/sn/kernel/mca.c
@@ -98,6 +98,7 @@ sn_platform_plat_specific_err_print(const u8 * sect_header, u8 ** oemdata,
 	while (*sn_oemdata_size > sn_oemdata_bufsize) {
 		u8 *newbuf = vmalloc(*sn_oemdata_size);
 		if (!newbuf) {
+			mutex_unlock(&sn_oemdata_mutex);
 			printk(KERN_ERR "%s: unable to extend sn_oemdata\n",
 			       __FUNCTION__);
 			return 1;

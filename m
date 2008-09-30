Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbYI3Qti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbYI3Qti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYI3Qta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:49:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:45595 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbYI3Qt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:49:29 -0400
Message-ID: <48E25831.4030505@kernel.org>
Date: Wed, 01 Oct 2008 01:47:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita> <48DA0A2C.8010008@kernel.org> <20080924105943.GB2094@anita> <20080925081848.GB2305@anita> <48DEA40D.40709@kernel.org> <20080930081257.GB18961@anita.doom> <48E232FC.1090902@kernel.org> <20080930151622.GC18961@anita.doom>
In-Reply-To: <20080930151622.GC18961@anita.doom>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------070406050001020902090805"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Sep 2008 16:49:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070406050001020902090805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Please apply the attached patch and see whether the problem goes away.
Also, can you test whether hotplug works with the patch applied?
CK804 had problems with hotplug w/ HRST removed.  I wanna make sure
nf2/3 doesn't have the same problem.

Thanks.

-- 
tejun

--------------070406050001020902090805
Content-Type: text/x-patch;
 name="nf2-no-hrst.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nf2-no-hrst.patch"

diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 14601dc..18f81d2 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -433,6 +433,7 @@ static struct ata_port_operations nv_nf2_ops = {
 	.inherits		= &nv_common_ops,
 	.freeze			= nv_nf2_freeze,
 	.thaw			= nv_nf2_thaw,
+	.hardreset		= ATA_OP_NULL,
 };
 
 static struct ata_port_operations nv_ck804_ops = {

--------------070406050001020902090805--

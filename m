Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbXH1OVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbXH1OVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 10:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbXH1OUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 10:20:39 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:32400 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541AbXH1OUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 10:20:12 -0400
Date: Tue, 28 Aug 2007 16:20:11 +0200
From: Christian Krafft <krafft@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: kou.ishizaki@toshiba.co.jp, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, cbe-oss-dev@ozlabs.org, jk@ozlabs.org,
       krafft@de.ibm.com
Subject: Re: [Cbe-oss-dev] [patch 1/5] spu_manage: use newer physical-id
Message-ID: <20070828162011.5356afaa@localhost>
In-Reply-To: <200708231812.20493.arnd@arndb.de>
References: <20070823.180152.-1300528381.kouish@swc.toshiba.co.jp>
	<200708231812.20493.arnd@arndb.de>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 18:12:19 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Thursday 23 August 2007, kou.ishizaki@toshiba.co.jp wrote:
> > Please check "unit-id" if "physical-id" doesn't exist. Because Celleb
> > uses "unit-id" to provide spe_id.

Sorry for the late answer, wasn't on cc
and had to receive all mails of the last 6 month once again :-(

Can you check if the patch below is working with celleb device tree ?

------
Subject: spu_manage: fix spu_unit_number for celleb device tree

From: Christian Krafft <krafft@de.ibm.com>

New device trees provide "physical-id".
Celleb device tree provide the "unit-id".
Legacy device tree used the reg property for the physical id of an spe.
This patch fixes find_spu_unit_number to look for the spu id in that order.
The length is checked to avoid misinterpretation in case the attributes
unit-id or reg do not contain the id.

Signed-off-by: Christian Krafft <krafft@de.ibm.com>

Index: linux/arch/powerpc/platforms/cell/spu_manage.c
===================================================================
--- linux.orig/arch/powerpc/platforms/cell/spu_manage.c
+++ linux/arch/powerpc/platforms/cell/spu_manage.c
@@ -48,10 +48,18 @@ static u64 __init find_spu_unit_number(s
 {
 	const unsigned int *prop;
 	int proplen;
+
+	/* new device trees should provide the physical-id attribute */
 	prop = of_get_property(spe, "physical-id", &proplen);
 	if (proplen == 4)
 		return (u64)*prop;
 
+	/* celleb device tree provides the unit-id */
+	prop = of_get_property(spe, "unit-id", &proplen);
+	if (proplen == 4)
+		return (u64)*prop;
+
+	/* legacy device trees provide the id in the reg attribute */
 	prop = of_get_property(spe, "reg", &proplen);
 	if (proplen == 4)
 		return (u64)*prop;


-- 
Mit freundlichen Grüssen,
kind regards,

Christian Krafft
IBM Systems & Technology Group, 
Linux Kernel Development
IT Specialist

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761399AbZE1FPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761399AbZE1FPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 01:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760203AbZE1FOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 01:14:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:32734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758949AbZE1FOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 01:14:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ArtYo6NIadaRi9j2Ye9UNT/+EAb+A1JyO6hifV+n0ioeVA3GurX7l72h4KTfGKPbgi
         GtMTXl23u04M2zUREoMyS0phN4nz6RybR72bbxGIHcfKkIhd33zsrBQV7L18KJx6RMmx
         b2vyBWkSIkOU6O9gxk3SPsMCXym5sNgudq0qE=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Eric Miao <eric.miao@marvell.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 4/5] pxa/mioa701: add V3 gain configuration for Maxim 1586 voltage regulator
Date: Thu, 28 May 2009 07:15:17 +0200
Message-Id: <1243487718-5423-3-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <878wkibmv9.fsf@free.fr>
References: <878wkibmv9.fsf@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim 1586 V3 gain can be configured by external resistors
(R24, R25) connected to the FB3 pin. To avoid accidental
overvoltage, it now requires this gain to be configured
explicitly.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 arch/arm/mach-pxa/mioa701.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index 54c91db..d805218 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -746,6 +746,7 @@ static struct max1586_subdev_data max1586_subdevs[] = {
 static struct max1586_platform_data max1586_info = {
 	.subdevs = max1586_subdevs,
 	.num_subdevs = ARRAY_SIZE(max1586_subdevs),
+	.v3_gain = MAX1586_GAIN_NO_R24, /* 700..1475 mV */
 };
 
 /*
-- 
1.6.3.1


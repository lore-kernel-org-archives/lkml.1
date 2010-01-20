Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246Ab0ATAVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0ATAVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174Ab0ATAVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:21:00 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51352 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab0ATAU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:20:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ZrWN3F0RoxBj6pK4pQ+WRZyey0P9zoa98GZRcEa8xIVOwoBG+fjQRs6IVcjFATcons
         jzMUMh4A7gamPtvbg1H2vD4lTeaUQjb4CX4kSVKeuSQfoqjB+0cWe/rWoqkbZ2YeFLFX
         4bZDXq2fCMqmRmb690/LBeNx3hMwtJtaUYl/w=
Message-ID: <4B564D94.3080804@gmail.com>
Date: Wed, 20 Jan 2010 01:25:56 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] dma: cases IPU_PIX_FMT_BGRA32, BGR32 and ABGR32 are the same
 in ipu_ch_param_set_size()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In these cases the same statements are executed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
But was this intended? if not, what should differ? bpp?

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 9a5bc1a..1c518f1 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -348,6 +348,7 @@ static void ipu_ch_param_set_size(union chan_param_mem *params,
 		break;
 	case IPU_PIX_FMT_BGRA32:
 	case IPU_PIX_FMT_BGR32:
+	case IPU_PIX_FMT_ABGR32:
 		params->ip.bpp	= 0;
 		params->ip.pfs	= 4;
 		params->ip.npb	= 7;
@@ -376,20 +377,6 @@ static void ipu_ch_param_set_size(union chan_param_mem *params,
 		params->ip.wid2	= 7;		/* Blue bit width - 1 */
 		params->ip.wid3	= 7;		/* Alpha bit width - 1 */
 		break;
-	case IPU_PIX_FMT_ABGR32:
-		params->ip.bpp	= 0;
-		params->ip.pfs	= 4;
-		params->ip.npb	= 7;
-		params->ip.sat	= 2;		/* SAT = 32-bit access */
-		params->ip.ofs0	= 8;		/* Red bit offset */
-		params->ip.ofs1	= 16;		/* Green bit offset */
-		params->ip.ofs2	= 24;		/* Blue bit offset */
-		params->ip.ofs3	= 0;		/* Alpha bit offset */
-		params->ip.wid0	= 7;		/* Red bit width - 1 */
-		params->ip.wid1	= 7;		/* Green bit width - 1 */
-		params->ip.wid2	= 7;		/* Blue bit width - 1 */
-		params->ip.wid3	= 7;		/* Alpha bit width - 1 */
-		break;
 	case IPU_PIX_FMT_UYVY:
 		params->ip.bpp	= 2;
 		params->ip.pfs	= 6;

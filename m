Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbZJLMr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbZJLMr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbZJLMr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:47:27 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:34418 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbZJLMr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:47:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=HXR8XruFN7bNGTvaDyf/fjIIWzgA22g9cPS15VcUSnD1LOZ6xq4VXfcVO3z6LdYrPk
         LA4x/yUyln0aJrF1UrVSUzV3nOsqpgiOfHaU2SoSMNN4yirF1BVS1UpqrjZU/CZui/pS
         SD68G3w+hJ0ZigTO76Iavq4OcsDjUfN1WX+L8=
Message-ID: <4AD32765.4010206@gmail.com>
Date: Mon, 12 Oct 2009 14:56:05 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cryptocop: Fix assertion in create_output_descriptors()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

size_t desc_len cannot be less than 0, test before the subtraction.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
index fd529a0..b70fb34 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -628,9 +628,9 @@ static int create_output_descriptors(struct cryptocop_operation *operation, int
 		cdesc->dma_descr->buf = (char*)virt_to_phys(operation->tfrm_op.indata[*iniov_ix].iov_base + *iniov_offset);
 		cdesc->dma_descr->after = cdesc->dma_descr->buf + dlength;
 
+		assert(desc_len >= dlength);
 		desc_len -= dlength;
 		*iniov_offset += dlength;
-		assert(desc_len >= 0);
 		if (*iniov_offset >= operation->tfrm_op.indata[*iniov_ix].iov_len) {
 			*iniov_offset = 0;
 			++(*iniov_ix);

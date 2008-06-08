Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbYFHWPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbYFHWPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 18:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbYFHWPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 18:15:09 -0400
Received: from main.gmane.org ([80.91.229.2]:59621 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbYFHWPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 18:15:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: JAILLET Christophe <jaillet.christophe@wanadoo.fr>
Subject: [PATCH 1/1] drivers/media/video/videobuf-dma-sg.c: avoid to clear
 memory twice
Date: Mon, 09 Jun 2008 00:08:00 +0200
Message-ID: <g2hl81$btp$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: aorleans-157-1-30-46.w90-8.abo.wanadoo.fr
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Jaillet <jaillet.﻿christophe@wanadoo.fr>

Hi, here is a patch against linux/drivers/usb/atm/cxacru.c which :

1) Remove a useless initialisation of 'i'
2) Avoid to clear the memory allocated twice (once in 'kcalloc', once in 
﻿'sg_init_table')
3) Remove a test that can never trigger. The function returns NULL in 
such a case, so we know that at this point '﻿pages[0]' != NULL


Signed-off-by: Christophe Jaillet <jaillet.﻿christophe@wanadoo.fr>

---

diff --git a/drivers/media/video/videobuf-dma-sg.c
b/drivers/media/video/videobuf-dma-sg.c
index 03a7b94..8ed6082 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -80,17 +80,15 @@ struct scatterlist*
  videobuf_pages_to_sg(struct page **pages, int nr_pages, int offset)
  {
         struct scatterlist *sglist;
-       int i = 0;
+       int i;

         if (NULL == pages[0])
                 return NULL;
-       sglist = kcalloc(nr_pages, sizeof(*sglist), GFP_KERNEL);
+       sglist = kmalloc(nr_pages * sizeof(*sglist), GFP_KERNEL);
         if (NULL == sglist)
                 return NULL;
         sg_init_table(sglist, nr_pages);

-       if (NULL == pages[0])
-               goto nopage;
         if (PageHighMem(pages[0]))
                 /* DMA to highmem pages might not work */
                 goto highmem;


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbZARWgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbZARWgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 17:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZARWg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 17:36:29 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:33634 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZARWg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 17:36:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=aBpPIOKC2HZDQ10thneWR7KY/yaxlU9r6qKgaO/TD4gperY3GjqnX7vDshTEwhp2cL
         9iHWn+JMfIpRR4LnqT0nAHTDK7K3em0RAWkuYF/OGIUvhqfTlcQMllnN1olGy54hLsGk
         J6+jEzojLWL7Oxopgmy8eniq3/FYN5N2TD3PQ=
Message-ID: <4973AEEC.70504@gmail.com>
Date: Sun, 18 Jan 2009 23:36:28 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: garyhade@us.ibm.com, Ingo Molnar <mingo@elte.hu>
CC: lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH] mm: get_nid_for_pfn() returns int
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_nid_for_pfn() returns int

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
vi drivers/base/node.c +256
static int get_nid_for_pfn(unsigned long pfn)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 43fa90b..f8f578a 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -303,7 +303,7 @@ int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
 	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
 	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
-		unsigned int nid;
+		int nid;
 
 		nid = get_nid_for_pfn(pfn);
 		if (nid < 0)

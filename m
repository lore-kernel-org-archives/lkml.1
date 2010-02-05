Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab0BEJUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:20:07 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:53339 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab0BEJUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:20:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=E4iy0NF/rCbENhUlEHS7wGTP2r9tqcC0A4gJknu/ksVIe3W4FkLSImVprpmB7S21l5
         rKvhuwkzJY7P6dnkYnPqp/kTymMT0Vs0JAycLsOPb6hR7+H2xpXpMrIIEpc3GIS45YrO
         RAdF25R+GgEsq7XJ15H4n2Ot/csT4Rx8Rhx/c=
Message-ID: <4B6BE443.5000307@gmail.com>
Date: Fri, 05 Feb 2010 10:26:27 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>,
       tao.ma@oracle.com, ocfs2-devel@oss.oracle.com,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ocfs2: Fix contiguousness check in ocfs2_try_to_merge_extent_map()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wrong member was compared in the continguousness check.

Acked-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
>>         } else if ((ins->ei_phys + ins->ei_clusters) == emi->ei_phys &&
>>                    (ins->ei_cpos + ins->ei_clusters) == emi->ei_phys &&

>> should that 2nd emi->ei_phys be emi->ei_cpos?
> oh, yes, you are right. Do you want to provide a patch?

Here, I added your ack.

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index d35a27f..5328529 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -192,7 +192,7 @@ static int ocfs2_try_to_merge_extent_map(struct ocfs2_extent_map_item *emi,
 		emi->ei_clusters += ins->ei_clusters;
 		return 1;
 	} else if ((ins->ei_phys + ins->ei_clusters) == emi->ei_phys &&
-		   (ins->ei_cpos + ins->ei_clusters) == emi->ei_phys &&
+		   (ins->ei_cpos + ins->ei_clusters) == emi->ei_cpos &&
 		   ins->ei_flags == emi->ei_flags) {
 		emi->ei_phys = ins->ei_phys;
 		emi->ei_cpos = ins->ei_cpos;

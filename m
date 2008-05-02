Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbYEBFbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbYEBFbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 01:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYEBFbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 01:31:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:59340 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYEBFbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 01:31:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lp9scFpqK55jkN/QffX9MNMd/V61HhwivT2zhK6OX9dtQv15GPQkEP3HqZrrFhO1sEAMTvZn5fMqhDOJxog4CELQD/hZkYt25B/lhJFl1kNFMMFsYGcz10kjBL5aQP5zjriMLRdBD/zwi0UV4aXhpiI9kFLfY8dLvxfdPskMAcI=
Subject: Re: [PATCH 1/9] lib: add ascii hex helper functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1209683134.24729.203.camel@brick>
References: <1209683134.24729.203.camel@brick>
Content-Type: text/plain
Date: Thu, 01 May 2008 22:31:57 -0700
Message-Id: <1209706317.22362.46.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Missed one spot in 1/9 that breaks the build.  I've checked the
rest of the tree and this was the only place that slipped through.

 drivers/pnp/support.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pnp/support.c b/drivers/pnp/support.c
index 3eba85e..95b076c 100644
--- a/drivers/pnp/support.c
+++ b/drivers/pnp/support.c
@@ -45,10 +45,10 @@ void pnp_eisa_id_to_string(u32 id, char *str)
 	str[0] = 'A' + ((id >> 26) & 0x3f) - 1;
 	str[1] = 'A' + ((id >> 21) & 0x1f) - 1;
 	str[2] = 'A' + ((id >> 16) & 0x1f) - 1;
-	str[3] = hex_asc((id >> 12) & 0xf);
-	str[4] = hex_asc((id >>  8) & 0xf);
-	str[5] = hex_asc((id >>  4) & 0xf);
-	str[6] = hex_asc((id >>  0) & 0xf);
+	str[3] = hex_asc_hi(id >> 8);
+	str[4] = hex_asc_lo(id >> 8);
+	str[5] = hex_asc_hi(id);
+	str[6] = hex_asc_lo(id);
 	str[7] = '\0';
 }
 
-- 
1.5.5.1.350.gbbbf




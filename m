Return-Path: <linux-kernel-owner+w=401wt.eu-S1761155AbZLQEj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761155AbZLQEj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936661AbZLQEio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:38:44 -0500
Received: from kroah.org ([198.145.64.141]:55420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763957AbZLQEED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:03 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:47 2009
Message-Id: <20091217035647.865130289@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Cliff Wickman <cpw@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: [038/151] x86: SGI UV: Fix BAU initialization
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Cliff Wickman <cpw@sgi.com>

commit e38e2af1c57c3eb5211331a5b4fcaae0c4a2a918 upstream.

A memory mapped register that affects the SGI UV Broadcast
Assist Unit's interrupt handling may sometimes be unintialized.

Remove the condition on its initialization, as that condition
can be randomly satisfied by a hardware reset.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
LKML-Reference: <E1NBGB9-0005nU-Dp@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/tlb_uv.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -817,10 +817,8 @@ static int __init uv_init_blade(int blad
 	 */
 	apicid = blade_to_first_apicid(blade);
 	pa = uv_read_global_mmr64(pnode, UVH_BAU_DATA_CONFIG);
-	if ((pa & 0xff) != UV_BAU_MESSAGE) {
-		uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
+	uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
 				      ((apicid << 32) | UV_BAU_MESSAGE));
-	}
 	return 0;
 }
 



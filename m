Return-Path: <linux-kernel-owner+w=401wt.eu-S1763693AbZLQBU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763693AbZLQBU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763638AbZLQBUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:20:35 -0500
Received: from kroah.org ([198.145.64.141]:47969 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763624AbZLQBU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:26 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:03 2009
Message-Id: <20091217011603.224089240@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [41/90] powerpc: Fix usage of 64-bit instruction in 32-bit altivec code
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit e090aa80321b64c3b793f3b047e31ecf1af9538d upstream.

e821ea70f3b4873b50056a1e0f74befed1014c09 introduced a bug by copying
some 64-bit originated code as-is to be used by both 32 and 64-bit
but this code contains a 64-bit ony "cmpdi" instruction.

This changes it to cmpwi, which is fine since VRSAVE can only contains
a 32-bit value anyway.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/vector.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/vector.S
+++ b/arch/powerpc/kernel/vector.S
@@ -58,7 +58,7 @@ _GLOBAL(load_up_altivec)
 	 * all 1's
 	 */
 	mfspr	r4,SPRN_VRSAVE
-	cmpdi	0,r4,0
+	cmpwi	0,r4,0
 	bne+	1f
 	li	r4,-1
 	mtspr	SPRN_VRSAVE,r4



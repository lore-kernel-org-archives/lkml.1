Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbYJVKs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbYJVKs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYJVKss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:48:48 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:35610 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751727AbYJVKsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:48:47 -0400
Date: Wed, 22 Oct 2008 19:48:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/profile: Fix profile_init() section mismatch.
Message-ID: <20081022104823.GA14199@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

profile_init() calls in to alloc_bootmem() on early initialization.
While alloc_bootmem() is __init, the reference itself is safe in
that it is tucked below a !slab_is_available() check. So, flag
profile_init() as __ref.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 kernel/profile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index a9e422d..9830a03 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -102,7 +102,7 @@ int profile_setup(char *str)
 __setup("profile=", profile_setup);
 
 
-int profile_init(void)
+int __ref profile_init(void)
 {
 	int buffer_bytes;
 	if (!prof_on)

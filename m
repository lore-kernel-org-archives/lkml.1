Return-Path: <linux-kernel-owner+w=401wt.eu-S932535AbZDINHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbZDINHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760186AbZDINHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:07:40 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:44364
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760723AbZDINHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:07:39 -0400
X-BigFish: VPS-6(z34a4jz936eQzz1202hzzz32i6bh65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KHU4GH-02-NRU-01
Date: Thu, 9 Apr 2009 15:07:29 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mark Langsdorf <mark.langsdorf@amd.com>
Subject: [PATCH 4/8] x86: cacheinfo: correct return value when
	cache_disable feature is not active
Message-ID: <20090409130729.GH31527@alberich.amd.com>
References: <20090409125659.GD31527@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090409125659.GD31527@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Apr 2009 13:07:29.0813 (UTC) FILETIME=[23380C50:01C9B914]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bug fix

If user writes to "cache_disable" attribute on a CPU that does not support
this feature, the process hangs due to an invalid return value in
store_cache_disable().

CC: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 3973506..9dac235 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -771,7 +771,7 @@ store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
 	unsigned int ret, index, val;
 
 	if (!this_leaf->can_disable)
-		return 0;
+		return -EINVAL;
 
 	if (strlen(buf) > 15)
 		return -EINVAL;
-- 
1.6.2




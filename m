Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbYAUGwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbYAUGwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 01:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757100AbYAUGvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 01:51:37 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63081 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbYAUGve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 01:51:34 -0500
Date: Sun, 20 Jan 2008 22:57:46 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: check if Tom2 is enabled
In-reply-to: <200801210658.04030.ak@suse.de>
To: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200801202257.47195.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
 <200801202140.57829.yinghai.lu@sun.com> <200801210658.04030.ak@suse.de>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: check if Tom2 is enabled

need to applied after andi's amd special tom2 wb check patch

in amd_special_default_mtrr need to check if TOM2 is enabled

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 289ba1a..26eed57 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -641,6 +641,7 @@ early_param("disable_mtrr_trim", disable_mtrr_trim_setup);
  * Note this won't check if the MTRRs < 4GB where the magic bit doesn't
  * apply to are wrong, but so far we don't know of any such case in the wild.
  */
+#define Tom2Enabled (1U << 21)
 #define Tom2ForceMemTypeWB (1U << 22)
 
 static __init int amd_special_default_mtrr(void)
@@ -661,7 +662,8 @@ static __init int amd_special_default_mtrr(void)
 	 * Memory between 4GB and top of mem is forced WB by this magic bit.
 	 * Reserved before K8RevF, but should be zero there.
 	 */
-	if (l & Tom2ForceMemTypeWB)
+	if ((l & (Tom2Enabled | Tom2ForceMemTypeWB)) ==
+		 (Tom2Enabled | Tom2ForceMemTypeWB))
 		return 1;
 	return 0;
 }

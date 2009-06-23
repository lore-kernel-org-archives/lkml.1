Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZFWRU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZFWRU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZFWRUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:20:16 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:6412 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZFWRUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:20:14 -0400
X-IronPort-AV: E=Sophos;i="4.42,276,1243814400"; 
   d="scan'208";a="179549628"
From: Roland Dreier <rdreier@cisco.com>
To: Huang Ying <ying.huang@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: aes-ni - Don't print message with KERN_ERR on old system
X-Message-Flag: Warning: May contain useful information
Date: Tue, 23 Jun 2009 10:20:16 -0700
Message-ID: <adaprcuq33j.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Jun 2009 17:20:17.0033 (UTC) FILETIME=[E0916790:01C9F426]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the aes-intel module is loaded on a system that does not have the
AES instructions, it prints

    Intel AES-NI instructions are not detected.

at level KERN_ERR.  Since aes-intel is aliased to "aes" it will be tried
whenever anything uses AES and spam the console.  This doesn't match
existing practice for how to handle "no hardware" when initializing a
module, so downgrade the message to KERN_INFO.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 arch/x86/crypto/aesni-intel_glue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index c580c5e..d3ec8d5 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -636,7 +636,7 @@ static int __init aesni_init(void)
 	int err;
 
 	if (!cpu_has_aes) {
-		printk(KERN_ERR "Intel AES-NI instructions are not detected.\n");
+		printk(KERN_INFO "Intel AES-NI instructions are not detected.\n");
 		return -ENODEV;
 	}
 	if ((err = crypto_register_alg(&aesni_alg)))

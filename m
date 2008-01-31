Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbYAaDwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbYAaDwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 22:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYAaDwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 22:52:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:50677 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbYAaDwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 22:52:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=n4m1nS9ke+hH1aOSNKACsq2YGPOqfZME5d2w8Fxm7e/KcGs0fKSlbrS076wk1UbBQ0LXW6tCXsi+0TD3fUeVRw1emxLR8JJKK9VPJq0eki7E5swoyXqh9agWhwFDQ+t3pNnlrFMZYKUwCIhpFCNBeXq1ynUadIxT7d1/SFaGOsI=
Subject: [PATCH] x86: fix small sparse warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 19:52:09 -0800
Message-Id: <1201751530.23523.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/ds.c:226:9: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/ds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 1c5ca4d..dcd918c 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -223,7 +223,7 @@ int ds_free(void **dsp)
 	if (*dsp)
 		kfree((void *)get_bts_buffer_base(*dsp));
 	kfree(*dsp);
-	*dsp = 0;
+	*dsp = NULL;
 
 	return 0;
 }
-- 
1.5.4.rc4.1142.gf5a97




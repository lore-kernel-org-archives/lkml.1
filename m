Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZK3Kci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZK3Kci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZK3Kci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:32:38 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:49465 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZK3Kch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:32:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=WQz2F+G4bvGBOpEx0h05xUKHm1sKrsjmwvR+WjWF3hQ0OTYJLXL0nTNEX0FBs6tYAm
         8QyMXMlp5prS4Xt+CSAkoc+Kjy5YLzyWSgEd8WsQ73qYyGSLjT8hRiS4lMOU6wr1xTIu
         4ydYBW/zpz/4ZD/d2GTdOftTI5GGSVhI80AaA=
Message-ID: <4B139F8F.4000907@gmail.com>
Date: Mon, 30 Nov 2009 18:33:51 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Subject: [PATCH 1/2] fix a Section mismatch in arch/x86/kernel/setup.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_edd() should be __init.
warning msg:
WARNING: vmlinux.o(.text+0x7759): Section mismatch in reference from the 
function copy_edd() to the variable .init.data:boot_params
The function copy_edd() references
the variable __initdata boot_params.
This is often because copy_edd lacks a __initdata
annotation or the annotation of boot_params is wrong.

Signed-off-by: ZhenwenXu <helight.xu@gmail.com>
---
 arch/x86/kernel/setup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2a34f9c..24e50d6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -247,7 +247,7 @@ EXPORT_SYMBOL(edd);
  *              from boot_params into a safe place.
  *
  */
-static inline void copy_edd(void)
+static inline void __init copy_edd(void)
 {
      memcpy(edd.mbr_signature, boot_params.edd_mbr_sig_buffer,
            sizeof(edd.mbr_signature));
@@ -256,7 +256,7 @@ static inline void copy_edd(void)
      edd.edd_info_nr = boot_params.eddbuf_entries;
 }
 #else
-static inline void copy_edd(void)
+static inline void __init copy_edd(void)
 {
 }
 #endif
-- 
1.6.5.3

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org


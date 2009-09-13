Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbZIMTji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbZIMTji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 15:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbZIMTjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 15:39:37 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55396 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbZIMTjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 15:39:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=u4Vk2Fj73hqcVZj26wh716sXLUmoQDVp1wLEyQE/4mXFn4hEIeuxnY3p5r1kvmT4cc
         JNMlAG3PiJEDGl8JOacGC0tBM4Gxix+df9uyU0TgJ1k9Qfqr6sauQdq1e42OHWf1LvFM
         8mSlwfuYGVbM2ocmJQF3fOygZFh8TeNAwYX+E=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>, Len Brown <lenb@kernel.org>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org
Subject: [PATCH 4/5] acpi: fix trivial warning
Date: Sun, 13 Sep 2009 22:38:26 +0300
Message-Id: <1252870707-4824-5-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1252870707-4824-4-git-send-email-felipe.contreras@gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
 <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com>
 <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
 <1252870707-4824-4-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/acpi/acpica/tbfadt.c: In function ‘acpi_tb_create_local_fadt’:
arch/x86/include/asm/string_32.h:74: warning: array subscript is above array bounds

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 include/acpi/actypes.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 37ba576..e312be7 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -438,8 +438,8 @@ typedef unsigned long long acpi_integer;
 
 #define ACPI_SET_BIT(target,bit)        ((target) |= (bit))
 #define ACPI_CLEAR_BIT(target,bit)      ((target) &= ~(bit))
-#define ACPI_MIN(a,b)                   (((a)<(b))?(a):(b))
-#define ACPI_MAX(a,b)                   (((a)>(b))?(a):(b))
+#define ACPI_MIN(a,b)                   min(a, b)
+#define ACPI_MAX(a,b)                   max(a, b)
 
 /* Size calculation */
 
-- 
1.6.5.rc1


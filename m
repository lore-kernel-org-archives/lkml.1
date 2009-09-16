Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbZIPVkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbZIPVkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760139AbZIPVki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:40:38 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:65443 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760110AbZIPVkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:40:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=lLuQu+JsNSTnLk3H12DXC7BgJ567i0s6tcB6gyhuR9ZaLSmLqhakp3KOGxS2YN73dQ
         n5oUzg6zOHt2YtW2GfT9lj81qWqWgiGj9+iubzjt0qt2k0Em9N02V0gIQGsNfycL7SqO
         51DohJe+q0hIHzmkr5Kn/QWsZ1kgngmzsMVb4=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>, Len Brown <lenb@kernel.org>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org
Subject: [PATCH v2 5/6] acpi: fix trivial warning
Date: Thu, 17 Sep 2009 00:38:42 +0300
Message-Id: <1253137123-18047-6-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253137123-18047-5-git-send-email-felipe.contreras@gmail.com>
References: <1253137123-18047-1-git-send-email-felipe.contreras@gmail.com>
 <1253137123-18047-2-git-send-email-felipe.contreras@gmail.com>
 <1253137123-18047-3-git-send-email-felipe.contreras@gmail.com>
 <1253137123-18047-4-git-send-email-felipe.contreras@gmail.com>
 <1253137123-18047-5-git-send-email-felipe.contreras@gmail.com>
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
index 2d500fa..2ebd3b0 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -438,8 +438,8 @@ typedef unsigned long long acpi_integer;
 
 #define ACPI_SET_BIT(target,bit)        ((target) |= (bit))
 #define ACPI_CLEAR_BIT(target,bit)      ((target) &= ~(bit))
-#define ACPI_MIN(a, b)                  (((a)<(b))?(a):(b))
-#define ACPI_MAX(a, b)                  (((a)>(b))?(a):(b))
+#define ACPI_MIN(a, b)                  min(a, b)
+#define ACPI_MAX(a, b)                  max(a, b)
 
 /* Size calculation */
 
-- 
1.6.5.rc1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZJRW6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZJRW6G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbZJRW6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:58:03 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:35800 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbZJRW6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:58:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=R8uGLsKiyvg/B/SH272PT6okU8EmPKEhLv7CJFp8oozwlxs5WMc9cRr+osYezhz1hA
         x3nBCNgalzib518JxlNifW65EYyioghVFhIdYPmOMLsA19bscu1UgKWTnk0OhDBSTxAa
         ryqWc2UZwgEmygwd0PlMeSWAQbiWlm7wQanqU=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Len Brown <lenb@kernel.org>, Bob Moore <robert.moore@intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-acpi@vger.kernel.org
Subject: [PATCH 6/7] acpi: fix trivial warning
Date: Mon, 19 Oct 2009 01:54:33 +0300
Message-Id: <1255906474-25091-7-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
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
index c1a0eb4..7d989f1 100644
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
1.6.5.1


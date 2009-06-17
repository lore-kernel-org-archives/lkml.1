Return-Path: <linux-kernel-owner+w=401wt.eu-S1765742AbZFQOZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765742AbZFQOZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758117AbZFQOZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:25:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:12993 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200AbZFQOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=O+50J7uOyBcfxMSBLmJ6sf+IV0CV1fbUifpmZfQRanSaYPj7LmPHcVSTmm2Tz/QWuO
         KJJQz7sa4pHdLk7ijXZq2eoANo5qlLuPp4NP3uKA0wgN0ezUVmSmSQOaiqZE2zsD60My
         LSsMOUqUwat9fnYGNw8+gDE7bVNvRBAFOoEy8=
Subject: [PATCH]io_apic.c: fix compile warning
From: "Figo.zhang" <figo1802@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Jun 2009 22:25:20 +0800
Message-Id: <1245248720.3312.27.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix compile warning:
arch/x86/kernel/apic/io_apic.c: In function ‘ioapic_write_entry’:
arch/x86/kernel/apic/io_apic.c:466: warning: ‘eu’ is used uninitialized in this function
arch/x86/kernel/apic/io_apic.c:465: note: ‘eu’ was declared here

Signed-off-by: Figo.zhang <figo1802@gmail.com>
--- 

 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ef8d929..e9ca066 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -462,7 +462,7 @@ static struct IO_APIC_route_entry ioapic_read_entry(int apic, int pin)
 static void
 __ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 {
-	union entry_union eu;
+	union entry_union eu = {{0,0}};
 	eu.entry = e;
 	io_apic_write(apic, 0x11 + 2*pin, eu.w2);
 	io_apic_write(apic, 0x10 + 2*pin, eu.w1);



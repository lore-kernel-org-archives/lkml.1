Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbYHJHij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbYHJHij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbYHJHh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:37:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:7020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbYHJHh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:37:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q2HXoFOUdes0XI9RVxZUOyPXZnH3DJ2TPrQNqujuCBzkYt9REvIM9c/pCxtacTEIkw
         G4o0xInIV4JeWw+qwHuTAFbXPyNacxl5A0wOV0jG0IkoiFD7L90YqngtsEGJZMTtu/jt
         GA5JpuTCSJifLvAJ1MgP/r8n3JRC+5+EuGePc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 03/43] x86: add after_bootmem for 32bit
Date: Sun, 10 Aug 2008 00:35:52 -0700
Message-Id: <1218353792-3355-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-3-git-send-email-yhlu.kernel@gmail.com>
References: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-2-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-3-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to prepare to use dyn_array support etc.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/mm/init_32.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 4974e97..b5c1751 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -65,6 +65,7 @@ static unsigned long __meminitdata table_end;
 static unsigned long __meminitdata table_top;
 
 static int __initdata after_init_bootmem;
+int after_bootmem;
 
 static __init void *alloc_low_page(unsigned long *phys)
 {
@@ -924,6 +925,8 @@ void __init mem_init(void)
 
 	set_highmem_pages_init();
 
+	after_bootmem = 1;
+
 	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
-- 
1.5.4.5


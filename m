Return-Path: <linux-kernel-owner+w=401wt.eu-S1762187AbYHHVys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762187AbYHHVys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761706AbYHHVxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:53:40 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:29776 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761638AbYHHVxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:53:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hVl0FxOOp+j0tlVwpyBEPLMJ/IwB21oTJ2kroP0jozP5Sj5DJTGeW5ii0ipRt7NGGf
         c+FiFFDC0nlN9M6Dm5g74CIKF3jsqL0Km/lsgE4i7MJSVGEJcpRrirR++g5G3ngeKj/S
         Rt7ZDiGKjI2/GHrKSTKfI9NvkevZGxKR/FEsI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 02/42] x86: add after_bootmem for 32bit
Date: Fri,  8 Aug 2008 14:52:08 -0700
Message-Id: <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
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


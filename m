Return-Path: <linux-kernel-owner+w=401wt.eu-S933067AbXIUWqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067AbXIUWqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763985AbXIUWcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:45 -0400
Received: from ns2.suse.de ([195.135.220.15]:40503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762338AbXIUWcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:39 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: abh@cray.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [38/50] x86_64: fix off-by-one in find_next_zero_string
Message-Id: <20070921223238.450611479D@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrew Hastings <abh@cray.com>
Fix an off-by-one error in find_next_zero_string which prevents
allocating the last bit.

Signed-off-by: Andrew Hastings <abh@cray.com> on behalf of Cray Inc.
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/lib/bitstr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/lib/bitstr.c
===================================================================
--- linux.orig/arch/x86_64/lib/bitstr.c
+++ linux/arch/x86_64/lib/bitstr.c
@@ -14,7 +14,7 @@ find_next_zero_string(unsigned long *bit
 	
 	/* could test bitsliced, but it's hardly worth it */
 	end = n+len;
-	if (end >= nbits) 
+	if (end > nbits)
 		return -1; 
 	for (i = n+1; i < end; i++) { 
 		if (test_bit(i, bitmap)) {  

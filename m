Return-Path: <linux-kernel-owner+w=401wt.eu-S934299AbXHNVih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934299AbXHNVih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbXHNVXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:23:42 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38462 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756886AbXHNVXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:23:38 -0400
Date: Tue, 14 Aug 2007 23:23:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [-mm patch] AFLAGS: fix the -g setting
Message-ID: <20070814212329.GQ18945@stusta.de>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070809224254.11f42716.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's -gdwarf-2, not -gdwarf2. With this fix it can actually work.

And since even gcc 3.2 supports -gdwarf-2 there's no reason for checking 
with as-option.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
6ab1091b06e762635430b452f82a474890bda230 
diff --git a/Makefile b/Makefile
index 5b0d58c..accfdc4 100644
--- a/Makefile
+++ b/Makefile
@@ -504,7 +504,7 @@ endif
 
 ifdef CONFIG_DEBUG_INFO
 CFLAGS		+= -g
-AFLAGS		+= $(call as-option, -gdwarf2)
+AFLAGS		+= -gdwarf-2
 endif
 
 # Force gcc to behave correct even for buggy distributions


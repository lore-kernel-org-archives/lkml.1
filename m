Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbXDLU3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbXDLU3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 16:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbXDLU3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 16:29:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:15510 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbXDLU3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 16:29:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=kb2/hanVTUF4MMweVy0LfbyDVnAiEmf487tJ+re5sNHsIxoFlNceqdmc9ptwZbHM8reArYd5yNHCRyM/uwOQx742Dkjd2yRfTPNGVkdEiQG8kzZnGkrtFft2F00pJpz/J6eTdJq38dkjfhHvIZvMgItm/Y9BfJQ9jkDzA6c3a/o=
Date: Fri, 13 Apr 2007 02:01:13 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org, linux-ia64@vger.kernel.org,
       discuss@x86-64.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tony.luck@intel.com, ak@suse.de
Subject: [KJ][PATCH 01/03]ROUND_UP|DOWN macro cleanup in arch/ia64,x86_64
Message-ID: <20070412203113.GA9353@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add ALIGN_DOWN and round_down macros to kernel.h

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 kernel.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 9ddf25c..f8648b2 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -34,11 +34,13 @@ extern const char linux_proc_banner[];
 
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
+#define ALIGN_DOWN(x,a)         ((x)&~((typeof(x))(a)-1))
+#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
+#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
+#define round_down(x, y) (((x) / (y)) * (y))
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
-#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
-#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
 
 #define	KERN_EMERG	"<0>"	/* system is unusable			*/
 #define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/

-- 
Milind Arun Choudhary

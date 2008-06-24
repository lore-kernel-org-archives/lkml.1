Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYFXSl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYFXSl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 14:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYFXSlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 14:41:20 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49374 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbYFXSlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 14:41:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org,
       WANG Cong <xiyou.wangcong@gmail.com>
References: <20080624164240.GF10512@hack.voiplan.pt>
Date: Tue, 24 Jun 2008 11:40:46 -0700
In-Reply-To: <20080624164240.GF10512@hack.voiplan.pt> (WANG Cong's message of
	"Tue, 24 Jun 2008 17:42:40 +0100")
Message-ID: <m14p7iy8up.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  2.2 XMSubMetaSxObfu_01 Obfuscated Sexy Adjective
Subject: Re: [Patch] kernel/kexec.c: make 'kimage_terminate' void
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>

Since kimage_terminate() always returns 0, make it void.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

---
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 1c5fcac..6db42ff 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -589,14 +589,12 @@ static void kimage_free_extra_pages(struct kimage *image)
 	kimage_free_page_list(&image->unuseable_pages);
 
 }
-static int kimage_terminate(struct kimage *image)
+static void kimage_terminate(struct kimage *image)
 {
 	if (*image->entry != 0)
 		image->entry++;
 
 	*image->entry = IND_DONE;
-
-	return 0;
 }
 
 #define for_each_kimage_entry(image, ptr, entry) \
@@ -997,9 +995,7 @@ asmlinkage long sys_kexec_load(unsigned long entry, unsigned long nr_segments,
 			if (result)
 				goto out;
 		}
-		result = kimage_terminate(image);
-		if (result)
-			goto out;
+		kimage_terminate(image);
 	}
 	/* Install the new kernel, and  Uninstall the old */
 	image = xchg(dest_image, image);

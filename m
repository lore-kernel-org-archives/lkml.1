Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbZG1X4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbZG1X4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbZG1X4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:56:39 -0400
Received: from kroah.org ([198.145.64.141]:35844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbZG1XuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:58 2009
Message-Id: <20090728234157.866093220@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Uros Bizjak <ubizjak@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 43/71] x86: Fix movq immediate operand constraints in uaccess_64.h
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=x86-fix-movq-immediate-operand-constraints-in-uaccess_64.h.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

commit 155b73529583c38f30fd394d692b15a893960782 upstream.

arch/x86/include/asm/uaccess_64.h uses wrong asm operand constraint
("ir") for movq insn. Since movq sign-extends its immediate operand,
"er" constraint should be used instead.

Attached patch changes all uses of __put_user_asm in uaccess_64.h to use
"er" when "q" insn suffix is involved.

Patch was compile tested on x86_64 with defconfig.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/uaccess_64.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -88,11 +88,11 @@ int __copy_to_user(void __user *dst, con
 			      ret, "l", "k", "ir", 4);
 		return ret;
 	case 8:__put_user_asm(*(u64 *)src, (u64 __user *)dst,
-			      ret, "q", "", "ir", 8);
+			      ret, "q", "", "er", 8);
 		return ret;
 	case 10:
 		__put_user_asm(*(u64 *)src, (u64 __user *)dst,
-			       ret, "q", "", "ir", 10);
+			       ret, "q", "", "er", 10);
 		if (unlikely(ret))
 			return ret;
 		asm("":::"memory");
@@ -101,12 +101,12 @@ int __copy_to_user(void __user *dst, con
 		return ret;
 	case 16:
 		__put_user_asm(*(u64 *)src, (u64 __user *)dst,
-			       ret, "q", "", "ir", 16);
+			       ret, "q", "", "er", 16);
 		if (unlikely(ret))
 			return ret;
 		asm("":::"memory");
 		__put_user_asm(1[(u64 *)src], 1 + (u64 __user *)dst,
-			       ret, "q", "", "ir", 8);
+			       ret, "q", "", "er", 8);
 		return ret;
 	default:
 		return copy_user_generic((__force void *)dst, src, size);
@@ -157,7 +157,7 @@ int __copy_in_user(void __user *dst, con
 			       ret, "q", "", "=r", 8);
 		if (likely(!ret))
 			__put_user_asm(tmp, (u64 __user *)dst,
-				       ret, "q", "", "ir", 8);
+				       ret, "q", "", "er", 8);
 		return ret;
 	}
 	default:



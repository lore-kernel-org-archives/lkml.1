Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbZGTUPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbZGTUPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbZGTUPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:15:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:40881 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbZGTUPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:15:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=ZrKjrGeAZX2VH95e1qXcaEwqIbBLtNzecMamxWLAph3ThuuLHgS4Js7xV4lwiFUrs9
         1HMUyK9+2YMJbAPS+2hv+Nrzl9o/NU7L9y6c9QnyivOUV7+cZZUayOREk1WRCPSPbBFa
         3LQM2JdgiqzaihxfsJPI4NwC5jl1fopZhZ6As=
Message-ID: <4A64D06D.3040109@gmail.com>
Date: Mon, 20 Jul 2009 22:15:41 +0200
From: Uros Bizjak <ubizjak@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: x86@kernel.org
Subject: Re: [PATCH, x86]: Fix movq immediate operand constraints in uaccess_64.h
References: <4A63448B.1050208@gmail.com>
In-Reply-To: <4A63448B.1050208@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050103040008040204050607"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050103040008040204050607
Content-Type: text/plain; charset=windows-1250; format=flowed
Content-Transfer-Encoding: 7bit

On 07/19/2009 06:06 PM, Uros Bizjak wrote:
> Hello!
>
> arch/x86/include/asm/uaccess_64.h uses wrong asm operand constraint 
> ("ir") for movq insn. Since movq sign-extends its immediate operand, 
> "er" constraint should be used instead.
>
> Attached patch changes all uses of __put_user_asm in uaccess_64.h to 
> use "er" when "q" insn suffix is involved.
>
> Patch was compile tested on x86_64 with defconfig.
>
> Uros.

Uh, missed signed-off line and Cc, so:

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>



--------------050103040008040204050607
Content-Type: text/plain;
 name="p.diff.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="p.diff.txt"

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 8cc6873..db24b21 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -88,11 +88,11 @@ int __copy_to_user(void __user *dst, const void *src, unsigned size)
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
@@ -101,12 +101,12 @@ int __copy_to_user(void __user *dst, const void *src, unsigned size)
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
@@ -157,7 +157,7 @@ int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
 			       ret, "q", "", "=r", 8);
 		if (likely(!ret))
 			__put_user_asm(tmp, (u64 __user *)dst,
-				       ret, "q", "", "ir", 8);
+				       ret, "q", "", "er", 8);
 		return ret;
 	}
 	default:

--------------050103040008040204050607--

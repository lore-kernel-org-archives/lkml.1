Return-Path: <linux-kernel-owner+w=401wt.eu-S1761289AbYCGLJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761289AbYCGLJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 06:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbYCGLJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 06:09:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:59919 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715AbYCGLJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 06:09:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=syMtTswyu4N8L/8zHZPX2CQlaVa6rjcuioUW08wkhicSCP3/mRpaRo+8dv9OjCSNeNo/BFeFVTgNJCEac6HJUfI2hXwLzGq9A8BWZVXBK9HOajq9oMs5JDP5T8zGoCeuYknBUaPfcDQMoj+yblVQ/r4iuzYQ6NH2yHsRLqfalTY=
Message-ID: <af3ea28a0803070309g46c29385jdc611786db9925f8@mail.gmail.com>
Date: Fri, 7 Mar 2008 19:09:22 +0800
From: "ye janboe" <janboe.ye@gmail.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] fix signal return code when enable CONFIG_OABI_COMPAT
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20080306153337.GM3283@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <af3ea28a0803060714s523ede0cr27b12979865f6faf@mail.gmail.com>
	 <20080306153337.GM3283@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell

I resubmit my patch, please review it.
Thanks

commit 31644e57359644d3f376f293f1a45b7c181175b6
Author: janboe <janboe@gmail.com>
Date:   Thu Mar 6 23:00:23 2008 +0800

    fix signal return code when enable CONFIG_OABI_COMPAT
    Signed-off-by: Janboe Ye <janboe.ye@gmail.com>

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 54cdf1a..ef2f86a 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -26,8 +26,8 @@
 /*
  * For ARM syscalls, we encode the syscall number into the instruction.
  */
-#define SWI_SYS_SIGRETURN      (0xef000000|(__NR_sigreturn))
-#define SWI_SYS_RT_SIGRETURN   (0xef000000|(__NR_rt_sigreturn))
+#define SWI_SYS_SIGRETURN
(0xef000000|(__NR_sigreturn)|(__NR_OABI_SYSCALL_BASE))
+#define SWI_SYS_RT_SIGRETURN
(0xef000000|(__NR_rt_sigreturn)|(__NR_OABI_SYSCALL_BASE))

 /*
  * With EABI, the syscall number has to be loaded into r7.


2008/3/6, Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Thu, Mar 06, 2008 at 11:14:50PM +0800, ye janboe wrote:
>  > commit b4e8bde513a9a477c30c8769073ced7b59676d48
>  > Author: janboe <janboe.ye@gmail.com>
>  > Date:   Thu Mar 6 23:00:23 2008 +0800
>  >
>  >     fix signal return code when enable CONFIG_OABI_COMPAT.
>  >     because this will make kernel report this syscall obsolete.
>  >     Signed-off-by: Janboe Ye <janboe.ye@gmail.com>
>
>
> This is all horribly broken for OABI compat anyway (because __NR_* don't
>  contain the right prefix).  So this patch doesn't actually fix the real
>  problem.
>

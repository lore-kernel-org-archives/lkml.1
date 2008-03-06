Return-Path: <linux-kernel-owner+w=401wt.eu-S932778AbYCFPPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbYCFPPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759747AbYCFPPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:15:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:37202 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763699AbYCFPOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:14:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BEN3M1mbbCurX0TlHbhpTMSaJwfpW43QPJFIYPG4tZ6sw4ROZwHjzg8KuZAlyOt7nZ9/ewhPCPx1KYLjAzvrvZZvsp0vaxkpGIjIYxBHk8ramC1HMfyq8RP4NPu+wMqorcxtHPhITmIvQOJHe8x1AseN0ozWt5XHyCiqWNa0W8w=
Message-ID: <af3ea28a0803060714s523ede0cr27b12979865f6faf@mail.gmail.com>
Date: Thu, 6 Mar 2008 23:14:50 +0800
From: "ye janboe" <janboe.ye@gmail.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: [PATCH] fix signal return code when enable CONFIG_OABI_COMPAT
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b4e8bde513a9a477c30c8769073ced7b59676d48
Author: janboe <janboe.ye@gmail.com>
Date:   Thu Mar 6 23:00:23 2008 +0800

    fix signal return code when enable CONFIG_OABI_COMPAT.
    because this will make kernel report this syscall obsolete.
    Signed-off-by: Janboe Ye <janboe.ye@gmail.com>

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 54cdf1a..b863255 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -26,8 +26,13 @@
 /*
  * For ARM syscalls, we encode the syscall number into the instruction.
  */
+#ifndef CONFIG_AEABI
 #define SWI_SYS_SIGRETURN      (0xef000000|(__NR_sigreturn))
 #define SWI_SYS_RT_SIGRETURN   (0xef000000|(__NR_rt_sigreturn))
+#else
+#define SWI_SYS_SIGRETURN       (0xef000000)
+#define SWI_SYS_RT_SIGRETURN    (0xef000000)
+#endif

 /*
  * With EABI, the syscall number has to be loaded into r7.

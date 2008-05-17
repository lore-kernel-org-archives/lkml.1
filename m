Return-Path: <linux-kernel-owner+w=401wt.eu-S1752509AbYEQELW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbYEQELW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 00:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYEQELN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 00:11:13 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:17742 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbYEQELM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 00:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tUKEdx7lUjXwbgMlQEK5d4v/5H+cGaCFruxMmrF7Jt5ow3f8lvMqYuiakg8Y0HKaa2tQvSmMavFd+V8qM/QXeahtl1Ryy5cDmfCxVBVHOq7lh8dwPy691SqlgvVZkMfSPBNSreackjWxP4qqFxhtz+nkkpa8izYPI2Kh+INmDI0=
Message-ID: <ea11fea30805162111v42f86555i816ec6915a89da3e@mail.gmail.com>
Date: Sat, 17 May 2008 09:41:10 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, trivial@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] Remove "unused variable" warning in arch/x86/xen/setup.c on UP systems.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On UP systems cpu_data is defined as boot_cpu_data, due to which we
get the below error while compiling xen.

CC      arch/x86/xen/setup.o
arch/x86/xen/setup.c: In function 'xen_enable_sysenter':
arch/x86/xen/setup.c:74: warning: unused variable 'cpu'

The below patch defines the variable only when SMP is defined.


Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>

diff -Nur a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
--- a/arch/x86/xen/setup.c       2008-04-26 20:36:15.000000000 +0530
+++ b/arch/x86/xen/setup.c        2008-05-17 09:30:12.000000000 +0530
@@ -71,7 +71,9 @@

 void xen_enable_sysenter(void)
 {
+#ifdef CONFIG_SMP
        int cpu = smp_processor_id();
+#endif
        extern void xen_sysenter_target(void);
        /* Mask events on entry, even though they get enabled immediately */
        static struct callback_register sysenter = {


-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************

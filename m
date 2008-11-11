Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbYKKEPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbYKKEPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 23:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbYKKEPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 23:15:18 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:5266 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbYKKEPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 23:15:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Iye2FmxJpH3atQveGr73+2CBvvMWd67H+cgB5Yyj3pMiE6ljya5gXHjJTEYnk1SGRh
         ts8YCkI7vEHBZAQc5uC07Zdy+JdoPGUWMpveDuF+waQ9Vt1MChDS5VcSSMlF5ZBYVnGd
         Z15pesOeI81F5R5sPKN9n0+7Vs0GPHuRsp/0k=
Message-ID: <b9df5fa10811102015i3a9e7e5u858f9cf49735fec0@mail.gmail.com>
Date: Tue, 11 Nov 2008 10:15:15 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86: Fixing improper annotation.
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       tglx@linutronix.de, hpa@zytor.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro __init used in function 'init_thread_xstate' is not
appropriate. It should be __cpuinit , because it's been called from
__cpuinit functions several times ( I myself found twice, once from
'cpu_init' and other is from 'fpu_init'). Thus produces the following
warning:

WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x2237): Section
mismatch in reference from the function cpu_init() to the function
.init.text:init_thread_xstate()
The function __cpuinit cpu_init() references
a function __init init_thread_xstate().
If init_thread_xstate is only used by cpu_init then
annotate init_thread_xstate with a matching annotation.

This patch fixes the above warning. If anything else please notice.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/arch/x86/kernel/i387.c	2008-11-10 13:28:17.000000000 +0600
+++ linux-2.6/arch/x86/kernel/i387.c	2008-11-10 23:35:09.000000000 +0600
@@ -58,7 +58,7 @@ void __cpuinit mxcsr_feature_mask_init(v
 	stts();
 }

-void __init init_thread_xstate(void)
+void __cpuinit init_thread_xstate(void)
 {
 	if (!HAVE_HWFP) {
 		xstate_size = sizeof(struct i387_soft_struct);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYJMFuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYJMFuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 01:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYJMFug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 01:50:36 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:16324 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYJMFug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 01:50:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=UAMPmevF3ipFy2dvtuN77xseDJtK1w8DmJPDNySSJ6GxZEewFgbHmMKc7Yj1BKhTjv
         PUqtq72IJhJStj3RbD6nq+PtA94QVC+b5cUZ5Ks6f6iL71EUV/YYT0z/pfAGCDTQT6lu
         yT3H+iK13kgXldDN1Cwsay6MojFW56zidlmHc=
Message-ID: <b9df5fa10810122250j1dd9c0eaq8c708c7b8e10a249@mail.gmail.com>
Date: Mon, 13 Oct 2008 11:50:33 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH -mm] ftrace : Fix section mismatch warning.
Cc: rostedt@goodmis.com, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: arch/x86/kernel/built-in.o(.text+0x11b41): Section mismatch
in reference from the variable ftrace_test_p6nop to the function
.init.text:ftrace_dyn_arch_init()
The function ftrace_test_p6nop() references
the function __init ftrace_dyn_arch_init().
This is often because ftrace_test_p6nop lacks a __init
annotation or the annotation of ftrace_dyn_arch_init is wrong.

WARNING: arch/x86/kernel/built-in.o(.text+0x11b4b): Section mismatch
in reference from the variable ftrace_test_nop5 to the function
.init.text:ftrace_dyn_arch_init()
The function ftrace_test_nop5() references
the function __init ftrace_dyn_arch_init().
This is often because ftrace_test_nop5 lacks a __init
annotation or the annotation of ftrace_dyn_arch_init is wrong.

This patch fixes the above warnings. Introduced by
'linux-next.patch'(2.6.27-rc5-mm1-broken-out).
Thanks.

Signed-off-by: Md.Rakib H. Mullick(rakib.mullick@gmail.com)

--- linux-2.6-mm.orig/arch/x86/kernel/ftrace.c	2008-10-11
18:55:52.000000000 +0600
+++ linux-2.6-mm/arch/x86/kernel/ftrace.c	2008-10-12 18:59:38.000000000 +0600
@@ -105,7 +105,7 @@ notrace int ftrace_mcount_set(unsigned l
 	return 0;
 }

-int __init ftrace_dyn_arch_init(void *data)
+int ftrace_dyn_arch_init(void *data)
 {
 	extern const unsigned char ftrace_test_p6nop[];
 	extern const unsigned char ftrace_test_nop5[];

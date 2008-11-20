Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbYKTNI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbYKTNI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 08:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbYKTNIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 08:08:49 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:43279 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYKTNIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 08:08:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Qk9n8w+YlUeApeaZ/JxoJUpAhSic4IoYjiopCJzV/CZ2KhNALLYIJCkzpe3GNehp/Y
         YJQYOPGp4VwnQab/v/v3GC1TKEquLEmVCRn86GjzPwhT5lr5BYWOYL+Kl/iX5XYxEPAc
         l/pC1+vl+mlyfVojFMGoXaBz/dqFM1BK5Hbkk=
Message-ID: <b9df5fa10811200508h6dc8ec60p1934ece2dde2b426@mail.gmail.com>
Date: Thu, 20 Nov 2008 19:08:45 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86: Fixing __cpuinit/__init tangle.
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact:	 Fixing __cpuinit/__init tangle.

This patch removes the following section mismatch warning. A patch set
was send previously (http://lkml.org/lkml/2008/11/10/407). But
introduce some other problem, reported by Rufus
(http://lkml.org/lkml/2008/11/11/46). Then Ingo Molnar suggest that,
it's best to remove __init from xsave_cntxt_init(void). Which is the
second patch in this series. Now, this one removes the following
warning.

WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x2237): Section
mismatch in reference from the function cpu_init() to the function
.init.text:init_thread_xstate()
The function __cpuinit cpu_init() references
a function __init init_thread_xstate().
If init_thread_xstate is only used by cpu_init then
annotate init_thread_xstate with a matching annotation.

Thanks.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/arch/x86/kernel/i387.c	2008-11-17 20:30:12.000000000 +0600
+++ linux-2.6/arch/x86/kernel/i387.c	2008-11-19 05:44:48.000000000 +0600
@@ -58,7 +58,7 @@ void __cpuinit mxcsr_feature_mask_init(v
 	stts();
 }

-void __init init_thread_xstate(void)
+void __cpuinit init_thread_xstate(void)
 {
 	if (!HAVE_HWFP) {
 		xstate_size = sizeof(struct i387_soft_struct);

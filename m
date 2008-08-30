Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYH3CCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYH3CCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 22:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYH3CCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 22:02:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:28795 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYH3CCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 22:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pBpjzVqj1icwMx5ATrXcjxehXyHTSnXWRcyKeXu5HQ+czBXzEe3fGxHT3EoiPZd3uQ
         cbVzMr2M233LpnR2nxAdtSQbsdyYJ+BYStneCcrvJCMmZ74oxHZ9PEeARRtDeKqPCAhM
         bzul7oNfB7RiI5sALGRka3O4yw8MM9SKgkSpw=
Date: Sat, 30 Aug 2008 06:03:34 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -next] x86: make setup_xstate_init() __init
Message-ID: <20080830020334.GA22978@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.text+0x22453): Section mismatch in reference from the function setup_xstate_init() to the function .init.text:__alloc_bootmem()
The function setup_xstate_init() references the function __init __alloc_bootmem().
This is often because setup_xstate_init lacks a __init annotation or the annotation of __alloc_bootmem is wrong.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86/kernel/xsave.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -272,7 +272,7 @@ void __cpuinit xsave_init(void)
 /*
  * setup the xstate image representing the init state
  */
-void setup_xstate_init(void)
+static void __init setup_xstate_init(void)
 {
 	init_xstate_buf = alloc_bootmem(xstate_size);
 	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;


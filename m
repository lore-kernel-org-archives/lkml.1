Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbZAWTqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbZAWTqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbZAWTqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:46:07 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:36033 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbZAWTqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:46:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CiJGoQMzD5pCU93XpKzfoOHASa8/St1EeZeT4tlwgHcSkL7CFghgtnQ7J1z1tQTRRM
         bA7NTN9Rwf5CPyS1bpAj5t81oStCThLiUhcPpeqc3fT8Z91CpsErLGiGUcyTsvWUSMxQ
         RHuD1VJzT60pI1zdbbkEqS+GFMWH8jQKFFQoQ=
MIME-Version: 1.0
Date: Sat, 24 Jan 2009 01:46:03 +0600
Message-ID: <b9df5fa10901231146k89cd1adoee590b6743bb349f@mail.gmail.com>
Subject: [PATCH] x86: Fix setion mismatch warning.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Fix section mismatch warning.

Here function vmi_activate calls a init function activate_vmi , which
causes the following section mismatch warnings. This patch fixes it.

  LD      arch/x86/kernel/built-in.o
WARNING: arch/x86/kernel/built-in.o(.text+0x13ba9): Section mismatch
in reference from the function vmi_activate() to the function
.init.text:vmi_time_init()
The function vmi_activate() references
the function __init vmi_time_init().
This is often because vmi_activate lacks a __init
annotation or the annotation of vmi_time_init is wrong.

WARNING: arch/x86/kernel/built-in.o(.text+0x13bd1): Section mismatch
in reference from the function vmi_activate() to the function
.devinit.text:vmi_time_bsp_init()
The function vmi_activate() references
the function __devinit vmi_time_bsp_init().
This is often because vmi_activate lacks a __devinit
annotation or the annotation of vmi_time_bsp_init is wrong.

WARNING: arch/x86/kernel/built-in.o(.text+0x13bdb): Section mismatch
in reference from the function vmi_activate() to the function
.devinit.text:vmi_time_ap_init()
The function vmi_activate() references
the function __devinit vmi_time_ap_init().
This is often because vmi_activate lacks a __devinit
annotation or the annotation of vmi_time_ap_init is wrong.


Thanks.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/arch/x86/kernel/vmi_32.c	2009-01-23 18:28:05.000000000 +0600
+++ linux-2.6/arch/x86/kernel/vmi_32.c	2009-01-24 00:10:53.000000000 +0600
@@ -858,7 +858,7 @@ void __init vmi_init(void)
 #endif
 }

-void vmi_activate(void)
+void __init vmi_activate(void)
 {
 	unsigned long flags;

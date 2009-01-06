Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbZAFXAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbZAFXAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbZAFXAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:00:07 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:51951 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZAFXAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:00:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc
         :disposition-notification-to:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=ceuQ4v4I+toF+MmyM1D4exUJ/JAQMpes54kfe6I1WR35LG0hEubwluh90GKCNwTEl1
         viAUkP8C0os4OXEplHDyldIravlkjfjzqfgAKJVCa1xd/J8Q6beshi6khD6K5YWSyGVp
         9kePsZEBuFA/BT65qcJCH2iJ8IUMvfFDm3lr8=
From: Leonardo Potenza <lpotenza@inwind.it>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH] x86: fix section mismatch warnings in mcheck/mce_amd_64.c
Date: Tue, 6 Jan 2009 23:58:29 +0100
User-Agent: KMail/1.9.9
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901062358.29954.lpotenza@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonardo Potenza <lpotenza@inwind.it>

The function local_allocate_threshold_blocks() has been marked __cpuinit, in order to remove the following section mismatch messages:

WARNING: arch/x86/kernel/cpu/mcheck/built-in.o(.text+0x1363): Section mismatch in reference from the function local_allocate_threshold_blocks() to the function .cpuinit.text:allocate_threshold_blocks()
The function local_allocate_threshold_blocks() references
the function __cpuinit allocate_threshold_blocks().
This is often because local_allocate_threshold_blocks lacks a __cpuinit 
annotation or the annotation of allocate_threshold_blocks is wrong.

WARNING: arch/x86/kernel/cpu/built-in.o(.text+0x1def): Section mismatch in reference from the function local_allocate_threshold_blocks() to the function .cpuinit.text:allocate_threshold_blocks()
The function local_allocate_threshold_blocks() references
the function __cpuinit allocate_threshold_blocks().
This is often because local_allocate_threshold_blocks lacks a __cpuinit 
annotation or the annotation of allocate_threshold_blocks is wrong.

WARNING: arch/x86/kernel/built-in.o(.text+0xef2b): Section mismatch in reference from the function local_allocate_threshold_blocks() to the function .cpuinit.text:allocate_threshold_blocks()
The function local_allocate_threshold_blocks() references
the function __cpuinit allocate_threshold_blocks().
This is often because local_allocate_threshold_blocks lacks a __cpuinit 
annotation or the annotation of allocate_threshold_blocks is wrong.

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
---
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c	2009-01-06 23:03:19.000000000 +0100
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_amd_64.c	2009-01-06 23:07:00.000000000 +0100
@@ -462,7 +462,7 @@ out_free:
 	return err;
 }
 
-static long local_allocate_threshold_blocks(void *_bank)
+static __cpuinit long local_allocate_threshold_blocks(void *_bank)
 {
 	unsigned int *bank = _bank;
 

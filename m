Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZARWGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZARWGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 17:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZARWGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 17:06:10 -0500
Received: from mail-fx0-f26.google.com ([209.85.220.26]:54438 "EHLO
	mail-fx0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbZARWGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 17:06:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:disposition-notification-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=TlEQW97O1lBah1/Xl0rxTEM/uMCY5lkXXgecXoJdCAYnxQvW7lIdhdl+C9YNuD396L
         9XZIh/CgVhpNQxwD9UcAPLmr4pFzzjqj6QSiUIHt5WzIzEve67tw4dz7PJ8G6DwzaE3z
         PnEoPQF0odvnmPyjjxcaC7s5HnuPPqN1gxsyE=
From: Leonardo Potenza <leo.potenza@gmail.com>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH] x86: fix section mismatch warnings in kernel/setup_percpu.c
Date: Sun, 18 Jan 2009 23:03:56 +0100
User-Agent: KMail/1.9.9
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901182303.56911.lpotenza@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonardo Potenza <lpotenza@inwind.it>

The function setup_cpu_local_masks() has been marked __init, in order to remove the following section mismatch messages:

WARNING: vmlinux.o(.text+0x3c2c7): Section mismatch in reference from the function setup_cpu_local_masks() to the function .init.text:alloc_bootmem_cpumask_var()
The function setup_cpu_local_masks() references
the function __init alloc_bootmem_cpumask_var().
This is often because setup_cpu_local_masks lacks a __init 
annotation or the annotation of alloc_bootmem_cpumask_var is wrong.

WARNING: vmlinux.o(.text+0x3c2d3): Section mismatch in reference from the function setup_cpu_local_masks() to the function .init.text:alloc_bootmem_cpumask_var()
The function setup_cpu_local_masks() references
the function __init alloc_bootmem_cpumask_var().
This is often because setup_cpu_local_masks lacks a __init 
annotation or the annotation of alloc_bootmem_cpumask_var is wrong.

WARNING: vmlinux.o(.text+0x3c2df): Section mismatch in reference from the function setup_cpu_local_masks() to the function .init.text:alloc_bootmem_cpumask_var()
The function setup_cpu_local_masks() references
the function __init alloc_bootmem_cpumask_var().
This is often because setup_cpu_local_masks lacks a __init 
annotation or the annotation of alloc_bootmem_cpumask_var is wrong.

WARNING: vmlinux.o(.text+0x3c2eb): Section mismatch in reference from the function setup_cpu_local_masks() to the function .init.text:alloc_bootmem_cpumask_var()
The function setup_cpu_local_masks() references
the function __init alloc_bootmem_cpumask_var().
This is often because setup_cpu_local_masks lacks a __init 
annotation or the annotation of alloc_bootmem_cpumask_var is wrong.

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
---
Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c	2009-01-18 22:20:13.000000000 +0100
+++ linux-2.6/arch/x86/kernel/setup_percpu.c	2009-01-18 22:21:19.000000000 +0100
@@ -136,7 +136,7 @@ static void __init setup_cpu_pda_map(voi
 #ifdef CONFIG_X86_64
 
 /* correctly size the local cpu masks */
-static void setup_cpu_local_masks(void)
+static void __init setup_cpu_local_masks(void)
 {
 	alloc_bootmem_cpumask_var(&cpu_initialized_mask);
 	alloc_bootmem_cpumask_var(&cpu_callin_mask);

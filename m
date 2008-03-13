Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbYCMQph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbYCMQph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYCMQpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:45:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:34200 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYCMQp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:45:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=fvlAtQgGQe3UwXRAez+gsn1dXQhhfX/szJGbEsuwTJMdsDORiCI6UHK5O0+AtP11Akdt9JYtPOYYcN1hPaUZrVsEL1a4ygZ9guw2Ypy84GAw1h0KVNxQZcG4sRPaJQ+RpeEt0I/jnxkL/qgsDxe+djGAIBfQtugDhbXBV9XdYRM=
Date: Thu, 13 Mar 2008 19:44:56 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: parocessor.h - use PAGE_SIZE instead of numeric value
	v2
Message-ID: <20080313164456.GA7560@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces numeric constant with an appropriate macro

Also 0x800000000000UL is changed to bit shifting which is complement
to the code comment (thanks hpa for notice)

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/include/asm-x86/processor.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/processor.h	2008-03-12 23:17:25.000000000 +0300
+++ linux-2.6.git/include/asm-x86/processor.h	2008-03-13 18:35:13.000000000 +0300
@@ -786,7 +786,7 @@ extern unsigned long thread_saved_pc(str
 /*
  * User space process size. 47bits minus one guard page.
  */
-#define TASK_SIZE64	(0x800000000000UL - 4096)
+#define TASK_SIZE64	((1UL << 47) - PAGE_SIZE)
 
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.

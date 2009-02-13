Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZBMVzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZBMVzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbZBMVyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:54:15 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:27999 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbZBMVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:54:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=Xx6z1U2fprTraywngmnOLrhaGONBuqpQpUz27Ug2qFiqn/slrV7HUbaHHvYQqn4Xxh
         OZmTEUsacGGI7aFpsC1Z4SO6BZdjt7gYFiYJN2pXVA5BLA/H3gx2ETbO4jHHUY5OzT8h
         0CHVUwKPdhB1YwsYafe+rTIslRkgsxbUTrC/c=
Message-Id: <20090213215404.710987358@gmail.com>
User-Agent: quilt/0.47-1
Date: Sat, 14 Feb 2009 00:50:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, heukelum@fastmail.fm
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC 5/6] x86: compressed head_64 - use ENTRY,ENDPROC macros
References: <20090213215017.959278111@gmail.com>
Content-Disposition: inline; filename=x86-compressed-head-64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: clenaup

Linker script will put startup_32 at predefined
address so using ENTRY will not bloat the code
size.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/boot/compressed/head_64.S |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6.git/arch/x86/boot/compressed/head_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/boot/compressed/head_64.S
+++ linux-2.6.git/arch/x86/boot/compressed/head_64.S
@@ -35,9 +35,7 @@
 
 .section ".text.head"
 	.code32
-	.globl startup_32
-
-startup_32:
+ENTRY(startup_32)
 	cld
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
 	 * us to not reload segments */
@@ -176,6 +174,7 @@ startup_32:
 
 	/* Jump from 32bit compatibility mode into 64bit mode. */
 	lret
+ENDPROC(startup_32)
 
 no_longmode:
 	/* This isn't an x86-64 CPU so hang */
@@ -295,7 +294,6 @@ relocated:
 	call	decompress_kernel
 	popq	%rsi
 
-
 /*
  * Jump to the decompressed kernel.
  */


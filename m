Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbYKREPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbYKREPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 23:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYKREP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 23:15:28 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:43002 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYKREP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 23:15:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=I5omN883Va0xqxRJFEmgFU55wIS7xTN82qVOaS7FBAYHcdJ5lFshC3ozf5y6NMJ8mb
         ptuAI9cNPycNiO3bHm5FVDXCR1Ch5ZA0zyiks69EtLLhgFufMTj8gxj3DQy0dhEIKlrw
         m0IIrTNuGD53vmEznk+d7erdunpmxwhGTl1hQ=
Message-ID: <b9df5fa10811172015w3dfb955bq115180d9d0808d82@mail.gmail.com>
Date: Tue, 18 Nov 2008 10:15:24 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/profile.c: Fix section mismatch warning.
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Fix section mismatch warning in kernel/profile.c

Here, profile_nop function has been called from a non-init function
create_hash_tables(void). Which generetes a section mismatch warning.
Previously, create_hash_tables(void) was a init function. So, removing
__init from create_hash_tables(void) requires profile_nop to be
non-init. This patch makes profile_nop function inline and fixes the
following warning:

WARNING: vmlinux.o(.text+0x6ebb6): Section mismatch in reference from
the function create_hash_tables() to the function
.init.text:profile_nop()
The function create_hash_tables() references
the function __init profile_nop().
This is often because create_hash_tables lacks a __init
annotation or the annotation of profile_nop is wrong.


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/kernel/profile.c	2008-11-17 20:30:42.000000000 +0600
+++ linux-2.6/kernel/profile.c	2008-11-18 09:39:58.000000000 +0600
@@ -544,7 +544,7 @@ static const struct file_operations proc
 };

 #ifdef CONFIG_SMP
-static void __init profile_nop(void *unused)
+static inline void profile_nop(void *unused)
 {
 }

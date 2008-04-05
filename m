Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbYDENu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbYDENu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 09:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbYDENuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 09:50:18 -0400
Received: from hs-out-0708.google.com ([64.233.178.243]:46570 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYDENuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=pzN8Uy8weBuc/p+tDsavlWpMTR3VUSiQ91K2XABkumiELg0LiQ98aWV4mwDAFggBoBH8Q5qwTbOXIFC7YxfhwbXj9eYM5awBWPYnZNrIGvmUxuGRfhNWyc9qhUDWNCa28+7urfplXWTQbVrEQGSorc2exIdmM1GEhT9HHmz8EVE=
References: <20080405133903.770639386@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 05 Apr 2008 22:39:06 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 3/9] x86: remove unnecessary memset()
Content-Disposition: inline; filename=x86-io-apic-noneed-memset-zero.patch
Message-ID: <47f78397.1aad7e0a.12c1.24a5@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to clear the memory allocated by alloc_bootmem().
It is already filled with zero.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |    1 -
 1 file changed, 1 deletion(-)

Index: 2.6-git/arch/x86/kernel/io_apic_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/io_apic_64.c
+++ 2.6-git/arch/x86/kernel/io_apic_64.c
@@ -2304,7 +2304,6 @@ static struct resource * __init ioapic_s
 	res = (void *)mem;
 
 	if (mem != NULL) {
-		memset(mem, 0, n);
 		mem += sizeof(struct resource) * nr_ioapics;
 
 		for (i = 0; i < nr_ioapics; i++) {

-- 

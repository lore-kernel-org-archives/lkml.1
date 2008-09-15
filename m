Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYIOPFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYIOPFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 11:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbYIOPFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 11:05:04 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:61977 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbYIOPFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 11:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PAOFOUKB+yT+ArRnun5OmORd6JZxT1n1HR6j0Xpv8S8VYK6l7qR5DaYmh25ZFT+xFU
         RSEZPj9zph5yQCI3OJYTw3zn7RH3U8NF6Tu1P7MxRoWWkNPfZyKrLxyUJtJ5orBa7Eam
         4vdcatHJoq8gi9cq987HGudfXs8PYJ5OiCKBE=
Date: Mon, 15 Sep 2008 19:05:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: do_boot_cpu - check for ESR apic register presence
	before touching
Message-ID: <20080915150518.GA23798@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should check first if there is ESR register before read/write it.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Please review and test if possible. Thanks.

Index: linux-2.6.git/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/smpboot.c	2008-09-14 21:49:36.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/smpboot.c	2008-09-15 18:30:37.000000000 +0400
@@ -893,8 +893,10 @@ do_rest:
 		/*
 		 * Be paranoid about clearing APIC errors.
 	 	*/
-		apic_write(APIC_ESR, 0);
-		apic_read(APIC_ESR);
+		if (APIC_INTEGRATED(apic_version[phys_apicid])) {
+			apic_write(APIC_ESR, 0);
+			apic_read(APIC_ESR);
+		}
 	}
 
 	/*

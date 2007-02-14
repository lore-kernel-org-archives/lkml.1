Return-Path: <linux-kernel-owner+w=401wt.eu-S932171AbXBNHnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbXBNHnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 02:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932174AbXBNHnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 02:43:14 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:50303
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932171AbXBNHnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 02:43:13 -0500
Message-Id: <45D2CBEF.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Wed, 14 Feb 2007 07:44:31 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: mtrr range check correction
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Whether a region is below 1Mb is determined by its start rather than
its end.

This hunk got erroneously dropped from a previous patch.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

--- linux-2.6.20/arch/i386/kernel/cpu/mtrr/generic.c	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20-x86-mtrr-range-check/arch/i386/kernel/cpu/mtrr/generic.c	2007-02-09 10:17:26.000000000 +0100
@@ -428,7 +428,7 @@ int generic_validate_add_page(unsigned l
 		}
 	}
 
-	if (base + size < 0x100) {
+	if (base < 0x100) {
 		printk(KERN_WARNING "mtrr: cannot set region below 1 MiB (0x%lx000,0x%lx000)\n",
 		       base, size);
 		return -EINVAL;



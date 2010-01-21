Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517Ab0AUW0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0AUW0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 17:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143Ab0AUW03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 17:26:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37585 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab0AUW02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 17:26:28 -0500
Date: Thu, 21 Jan 2010 23:26:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, robert.richter@amd.com,
       oprofile-list@lists.sf.net
Subject: [PATCH] Add Xeon 7500 series support to oprofile
Message-ID: <20100121222627.GA22897@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Xeon 7500 series support to oprofile

Straight forward: it's the same as Core i7, so just detect
the model number. No user space changes needed.

Very simple patch, so it could be still merged for .33?

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/oprofile/nmi_int.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86/oprofile/nmi_int.c
===================================================================
--- linux.orig/arch/x86/oprofile/nmi_int.c
+++ linux/arch/x86/oprofile/nmi_int.c
@@ -598,6 +598,7 @@ static int __init ppro_init(char **cpu_t
 	case 15: case 23:
 		*cpu_type = "i386/core_2";
 		break;
+	case 0x2e:
 	case 26:
 		spec = &op_arch_perfmon_spec;
 		*cpu_type = "i386/core_i7";

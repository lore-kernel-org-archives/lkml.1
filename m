Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbYJIRPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbYJIRPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYJIRPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:15:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43484 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbYJIRPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:15:00 -0400
Date: Thu, 9 Oct 2008 13:14:53 -0400
From: Dave Jones <davej@redhat.com>
To: x86@kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Update cacheline size on X86_GENERIC
Message-ID: <20081009171453.GA15321@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just noticed that configuring a kernel to use CONFIG_X86_GENERIC
(as is typical for a distro kernel) configures it to use a 128 byte cacheline size.
This made sense when that was commonplace (P4 era) but current
Intel, AMD and VIA cpus use 64 byte cachelines.

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.26.noarch/arch/x86/Kconfig.cpu~	2008-10-09 12:59:56.000000000 -0400
+++ linux-2.6.26.noarch/arch/x86/Kconfig.cpu	2008-10-09 13:11:32.000000000 -0400
@@ -301,8 +301,8 @@ config X86_CPU
 # Define implied options from the CPU selection here
 config X86_L1_CACHE_BYTES
 	int
-	default "128" if GENERIC_CPU || MPSC
-	default "64" if MK8 || MCORE2
+	default "128" if MPENTIUM4 || MPSC
+	default "64" if MK8 || MCORE2 || GENERIC_CPU
 	depends on X86_64
 
 config X86_INTERNODE_CACHE_BYTES
@@ -316,10 +316,10 @@ config X86_CMPXCHG
 
 config X86_L1_CACHE_SHIFT
 	int
-	default "7" if MPENTIUM4 || X86_GENERIC || GENERIC_CPU || MPSC
+	default "7" if MPENTIUM4 || MPSC
 	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
-	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7
+	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7 || X86_GENERIC || GENERIC_CPU
 
 config X86_XADD
 	def_bool y

-- 
http://www.codemonkey.org.uk

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbZDVBo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbZDVBo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 21:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZDVBou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 21:44:50 -0400
Received: from rdu-nat.rpath.com ([66.192.95.194]:50960 "EHLO
	rdu-nat.rpath.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZDVBot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 21:44:49 -0400
Date: Tue, 21 Apr 2009 21:44:48 -0400
From: "Michael K. Johnson" <johnsonm@rpath.com>
To: linux-kernel@vger.kernel.org
Subject: x86: more than 8 32-bit CPUs requires X86_BIGSMP
Message-ID: <20090422014448.GB32541@logo.rdu.rpath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ cat x86-more-than-8-cpus-requires-bigsmp.patch

Enforce NR_CPUS <= 8 limitation if X86_BIGSMP not set

Configuring more than 8 logical CPUs on 32-bit x86 requires
X86_BIGSMP to be set in order to boot successfully, if more than 8
logical CPUs are actually found at boot time.  The X86_BIGSMP help
text describes that it is required to be set if more than 8 CPUs
are configured, but this was previously not enforced.

This configuration error has affected multiple distributions:
    https://bugzilla.redhat.com/show_bug.cgi?id=480844
    https://issues.rpath.com/browse/RPL-3022

Signed-off-by: Michael K Johnson <johnsonm@rpath.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c9086e6..cdad0d9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -664,6 +664,7 @@ config MAXSMP
 
 config NR_CPUS
 	int "Maximum number of CPUs" if SMP && !MAXSMP
+	range 2 8 if SMP && X86_32 && !X86_BIGSMP
 	range 2 512 if SMP && !MAXSMP
 	default "1" if !SMP
 	default "4096" if MAXSMP

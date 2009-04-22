Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbZDVChk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbZDVChk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 22:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbZDVCha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 22:37:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:50889 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbZDVCh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 22:37:29 -0400
Date: Wed, 22 Apr 2009 02:36:45 GMT
From: "tip-bot for Michael K. Johnson" <johnsonm@rpath.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnsonm@rpath.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnsonm@rpath.com, tglx@linutronix.de
In-Reply-To: <20090422014448.GB32541@logo.rdu.rpath.com>
References: <20090422014448.GB32541@logo.rdu.rpath.com>
Subject: [tip:x86/urgent] x86: more than 8 32-bit CPUs requires X86_BIGSMP
Message-ID: <tip-2a3313f494c2f3f74a27d66f0f14b38558b7dba2@git.kernel.org>
Git-Commit-ID: 2a3313f494c2f3f74a27d66f0f14b38558b7dba2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 22 Apr 2009 02:36:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a3313f494c2f3f74a27d66f0f14b38558b7dba2
Gitweb:     http://git.kernel.org/tip/2a3313f494c2f3f74a27d66f0f14b38558b7dba2
Author:     Michael K. Johnson <johnsonm@rpath.com>
AuthorDate: Tue, 21 Apr 2009 21:44:48 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 21 Apr 2009 19:34:54 -0700

x86: more than 8 32-bit CPUs requires X86_BIGSMP

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
LKML-Reference: <20090422014448.GB32541@logo.rdu.rpath.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c9086e6..b5cda6c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -664,6 +664,7 @@ config MAXSMP
 
 config NR_CPUS
 	int "Maximum number of CPUs" if SMP && !MAXSMP
+	range 2 8 if SMP && X86_32 && !X86_BIGSMP
 	range 2 512 if SMP && !MAXSMP
 	default "1" if !SMP
 	default "4096" if MAXSMP

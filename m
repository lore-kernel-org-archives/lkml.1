Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbZDWH4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbZDWH4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757375AbZDWHeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:34:21 -0400
Received: from sous-sol.org ([216.99.217.87]:51050 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757097AbZDWHeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:34:19 -0400
Message-Id: <20090423072910.826861440@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>
Subject: [patch 077/100] x86: disable X86_PTRACE_BTS for now
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=x86-disable-x86_ptrace_bts-for-now.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Ingo Molnar <mingo@elte.hu>

upstream commit: d45b41ae8da0f54aec0eebcc6f893ba5f22a1e8e

Oleg Nesterov found a couple of races in the ptrace-bts code
and fixes are queued up for it but they did not get ready in time
for the merge window. We'll merge them in v2.6.31 - until then
mark the feature as CONFIG_BROKEN. There's no user-space yet
making use of this so it's not a big issue.

Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
[chrisw: trivial 2.6.29 backport]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/Kconfig.cpu |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -523,6 +523,7 @@ config X86_PTRACE_BTS
 	bool "Branch Trace Store"
 	default y
 	depends on X86_DEBUGCTLMSR
+	depends on BROKEN
 	help
 	  This adds a ptrace interface to the hardware's branch trace store.
 


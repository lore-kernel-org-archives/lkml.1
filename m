Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbYIVStn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbYIVStn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYIVStP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:49:15 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59952 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbYIVStN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:49:13 -0400
Date: Mon, 22 Sep 2008 13:49:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       James Morris <jmorris@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       Andreas Gruenbacher <agruen@suse.de>, Andrew Morton <akpm@osdl.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 2/2] file capabilities: turn on by default
Message-ID: <20080922184901.GA3688@us.ibm.com>
References: <20080922184835.GA2826@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922184835.GA2826@us.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that file capabilities can be turned off at boot, go ahead
and compile them into the kernel by default by making
CONFIG_SECURITY_FILE_CAPABILITIES=y the default.

Note that the boot flag no_file_caps must be specified to turn
file capabilities off, as by default they are on.  So the
default behavior is in fact changed.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
---
 security/Kconfig |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/security/Kconfig b/security/Kconfig
index 5592939..6fbb233 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -75,12 +75,15 @@ config SECURITY_NETWORK_XFRM
 
 config SECURITY_FILE_CAPABILITIES
 	bool "File POSIX Capabilities"
-	default n
+	default y
 	help
 	  This enables filesystem capabilities, allowing you to give
 	  binaries a subset of root's powers without using setuid 0.
 
-	  If in doubt, answer N.
+	  You can still boot with the no_file_caps option to disable
+	  file capabilities.
+
+	  If in doubt, answer Y.
 
 config SECURITY_ROOTPLUG
 	bool "Root Plug Support"
-- 
1.5.4.3


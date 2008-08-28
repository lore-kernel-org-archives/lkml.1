Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbYH1Tyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbYH1Tyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYH1TyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:54:22 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47240 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbYH1TyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:54:21 -0400
From: Serge Hallyn <serue@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, morgan@kernel.org, agruen@suse.de,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 2/2] file capabilities: turn on by default
Date: Thu, 28 Aug 2008 14:54:15 -0500
Message-Id: <fe7784a0710a8fef0ac2e4f39589dff6f8293ad0.1219951973.git.serue@us.ibm.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <f79cd5c96d2996b984fdfe1c7d8300975f55e8e6.1219951973.git.serue@us.ibm.com>
References: <>
 <f79cd5c96d2996b984fdfe1c7d8300975f55e8e6.1219951973.git.serue@us.ibm.com>
In-Reply-To: <f79cd5c96d2996b984fdfe1c7d8300975f55e8e6.1219951973.git.serue@us.ibm.com>
References: <f79cd5c96d2996b984fdfe1c7d8300975f55e8e6.1219951973.git.serue@us.ibm.com>
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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbXJIXW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbXJIXW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756954AbXJIXWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:22:05 -0400
Received: from namei.org ([69.55.235.186]:44199 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756931AbXJIXWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:22:03 -0400
Date: Wed, 10 Oct 2007 09:19:55 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 1/6] SELinux: change Kconfig to use select instead of depends
In-Reply-To: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au>
Message-ID: <Xine.LNX.4.64.0710100918520.14862@us.intercode.com.au>
References: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

Changes the security/selinux/Kconfig to use select instead of depends
for most of the SELinux requirements.  This allows the SELinux option to
show up when people do a make config without already knowing they had to
enable audit and other non-obvious choices.  Added a depends on SECURITY
(which previously existed through SECURITY_NETWORK) so that SELinux
would not always show up, but would be easy and intuitive to find.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@e.namei>
---
 security/selinux/Kconfig |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/security/selinux/Kconfig b/security/selinux/Kconfig
index b32a459..40b97e6 100644
--- a/security/selinux/Kconfig
+++ b/security/selinux/Kconfig
@@ -1,6 +1,10 @@
 config SECURITY_SELINUX
 	bool "NSA SELinux Support"
-	depends on SECURITY_NETWORK && AUDIT && NET && INET
+	depends on SECURITY
+	select SECURITY_NETWORK
+	select AUDIT
+	select NET
+	select INET
 	select NETWORK_SECMARK
 	default n
 	help
@@ -9,6 +13,7 @@ config SECURITY_SELINUX
 	  You can obtain the policy compiler (checkpolicy), the utility for
 	  labeling filesystems (setfiles), and an example policy configuration
 	  from <http://www.nsa.gov/selinux/>.
+
 	  If you are unsure how to answer this question, answer N.
 
 config SECURITY_SELINUX_BOOTPARAM
-- 
1.5.2.4


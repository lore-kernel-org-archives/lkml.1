Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYDLPiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYDLPiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 11:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYDLPiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 11:38:08 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:42048 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYDLPiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 11:38:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=vBqj0J088fY9LQlPb8NLEqgwcS8AoEvuffh8m4kVzyGGiAHiDUCykTAnU6zi6JKh9a9H9WhqI0jbs7oFrg3+9a+hayV+eNQHG5AEWPq9YkPZj6MFd+7iDEaA75iW4n91FHs6XqVc6bLoLLfoilnU+PB1cU0sv51edb2Y2rZortc=
Date: Sat, 12 Apr 2008 23:34:23 +0800 (CST)
Message-Id: <20080412.233423.112727172.xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] UML: Make three functions static
From: WANG Cong <xiyou.wangcong@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make the following three functions static, since they don't need to be
global.

arch/um/drivers/mcast_kern.c::mcast_setup()
arch/um/drivers/mconsole_user.c::mconsole_reply_v0()
arch/um/drivers/port_user.c::port_pre_exec()

Compile testing passed.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
 arch/um/drivers/mcast_kern.c    |    2 +-
 arch/um/drivers/mconsole_user.c |    2 +-
 arch/um/drivers/port_user.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/um/drivers/mcast_kern.c b/arch/um/drivers/mcast_kern.c
index 822092f..8c4378a 100644
--- a/arch/um/drivers/mcast_kern.c
+++ b/arch/um/drivers/mcast_kern.c
@@ -58,7 +58,7 @@ static const struct net_kern_info mcast_kern_info = {
 	.write			= mcast_write,
 };
 
-int mcast_setup(char *str, char **mac_out, void *data)
+static int mcast_setup(char *str, char **mac_out, void *data)
 {
 	struct mcast_init *init = data;
 	char *port_str = NULL, *ttl_str = NULL, *remain;
diff --git a/arch/um/drivers/mconsole_user.c b/arch/um/drivers/mconsole_user.c
index 13af2f0..f8cf4c8 100644
--- a/arch/um/drivers/mconsole_user.c
+++ b/arch/um/drivers/mconsole_user.c
@@ -39,7 +39,7 @@ static struct mconsole_command commands[] = {
 /* Initialized in mconsole_init, which is an initcall */
 char mconsole_socket_name[256];
 
-int mconsole_reply_v0(struct mc_request *req, char *reply)
+static int mconsole_reply_v0(struct mc_request *req, char *reply)
 {
 	struct iovec iov;
 	struct msghdr msg;
diff --git a/arch/um/drivers/port_user.c b/arch/um/drivers/port_user.c
index addd759..d269ca3 100644
--- a/arch/um/drivers/port_user.c
+++ b/arch/um/drivers/port_user.c
@@ -153,7 +153,7 @@ struct port_pre_exec_data {
 	int pipe_fd;
 };
 
-void port_pre_exec(void *arg)
+static void port_pre_exec(void *arg)
 {
 	struct port_pre_exec_data *data = arg;
 
-- 
1.5.2.4


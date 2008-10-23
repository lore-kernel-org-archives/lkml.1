Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbYJWCfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbYJWCfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYJWCfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:35:31 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:44454
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752107AbYJWCfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:35:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIx//0h8qQJT/2dsb2JhbADAPYNO
X-IronPort-AV: E=Sophos;i="4.33,468,1220198400"; 
   d="scan'208";a="341660361"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 3/6] autofs4 - collect version check return
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>
Date: Thu, 23 Oct 2008 10:35:27 +0800
Message-ID: <20081023023527.4508.10819.stgit@raven.themaw.net>
In-Reply-To: <20081023023513.4508.54940.stgit@raven.themaw.net>
References: <20081023023513.4508.54940.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function check_dev_ioctl_version() returns an error code upon fail
but it isn't captured and returned in validate_dev_ioctl() as it should
be.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

---

 fs/autofs4/dev-ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 304c1ff..63bfb5d 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -116,9 +116,9 @@ static inline void free_dev_ioctl(struct autofs_dev_ioctl *param)
  */
 static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
 {
-	int err = -EINVAL;
+	int err;
 
-	if (check_dev_ioctl_version(cmd, param)) {
+	if ((err = check_dev_ioctl_version(cmd, param))) {
 		AUTOFS_WARN("invalid device control module version "
 		     "supplied for cmd(0x%08x)", cmd);
 		goto out;


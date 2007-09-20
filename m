Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbXITIce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbXITIce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbXITIbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:31:47 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:12702 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbXITIbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:31:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=K5XR0y9qoELuTcfoUs62B0Id4jHszSvHy13bbl/dwEQA7eN8ysTy46GBhmKbyBjezdcr2olj/LtC5iX4iNUvauEsEQAdTyOhLeZUpSOMNxFZyi7WmkcSHUXGspB3opQayLmV4JX73w4c1hqAfyD3EGkTw3Pi1FkzZT4fbnro9Zw=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 1/8] sysfs: notify file on deactivation
In-Reply-To: <11902770971822-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:31:37 +0900
Message-Id: <1190277097165-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Notify file on deactivation so that the pollers get event when the
polled file dies, which is very easy to implement with sd based
interface.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index a74ca4a..d50d3ac 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -245,6 +245,10 @@ static void sysfs_deactivate(struct sysfs_dirent *sd)
 	 */
 	v = atomic_add_return(SD_DEACTIVATED_BIAS, &sd->s_active);
 
+	/* file is dying, notify pollers */
+	if (sysfs_type(sd) == SYSFS_FILE)
+		sysfs_notify_file(sd);
+
 	if (v != SD_DEACTIVATED_BIAS)
 		wait_for_completion(&wait);
 
-- 
1.5.0.3



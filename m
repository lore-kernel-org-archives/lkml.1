Return-Path: <linux-kernel-owner+w=401wt.eu-S933212AbXCFKNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbXCFKNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933213AbXCFKNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:13:44 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:36326 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933212AbXCFKNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:13:43 -0500
X-Greylist: delayed 1141 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2007 05:13:43 EST
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH] Use a zero-size array in the struct devres
To: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 06 Mar 2007 09:54:37 +0000
Message-ID: <20070306095241.28180.76390.stgit@localhost.localdomain>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2007 09:54:37.0874 (UTC) FILETIME=[73CB8920:01C75FD5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9ac7849e35f705830f7b016ff272b0ff1f7ff759 adds the devres
structure containing a flexible unsigned long long array, with a
comment about the guaranteed alignment. According to the gcc manual,
flexible arrays are considered incomplete types and it is an error to
ask for their alignment. This patch makes data[] a zero-size array.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---

I came across this when trying to build kmemleak as the modified
container_of macro tries to get the size of the devres.data member and
sizeof cannot be applied to incomplete types.

 drivers/base/devres.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index e177c95..0d6c067 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -22,7 +22,7 @@ struct devres_node {
 struct devres {
 	struct devres_node		node;
 	/* -- 3 pointers */
-	unsigned long long		data[];	/* guarantee ull alignment */
+	unsigned long long		data[0];	/* guarantee ull alignment */
 };
 
 struct devres_group {


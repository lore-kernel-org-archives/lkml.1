Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbXHQJae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbXHQJae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 05:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbXHQJa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 05:30:26 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:37744 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbXHQJaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 05:30:25 -0400
Message-ID: <46C56994.30303@openvz.org>
Date: Fri, 17 Aug 2007 13:25:40 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Alexey Dobriyan <adobriyan@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH] Fix check for return value of create_pid_namespace
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The function in question returns ERR_PTR-s to indicate the
error, while the caller checks for return value to be NULL.

Found during testing the OpenVZ kernel with pid namespaces.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>

---
 kernel/pid.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index faad017..cb1f3cb 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -543,7 +543,7 @@ struct pid_namespace *copy_pid_ns(unsign
 		goto out_put;
 
 	new_ns = create_pid_namespace(old_ns->level + 1);
-	if (new_ns != NULL)
+	if (!IS_ERR(new_ns))
 		new_ns->parent = get_pid_ns(old_ns);
 
 out_put:

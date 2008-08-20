Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbYHTAXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbYHTAXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 20:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbYHTAXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 20:23:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:5123 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbYHTAXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 20:23:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=PrdeFllNXzflj2fpBMTyU2koRF2XznifnHTCI/XGi3Nvl1se3AUUM4FigaqYSfExk8
         kbEJyGmVYpXZhmHdeogEAF+os8FGPcJlm5PVNMJY3HUkBW1sL6CSViuLE1/0K2FGTSNw
         kXZpOLpHc3kx5NtaPso+SB/BLJ/HvV9K8Yuyg=
Subject: [PATCH] pcmcia: fix uninitialized variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Dominik Brodowski <linux@brodo.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 19 Aug 2008 17:23:46 -0700
Message-Id: <1219191826.17033.100.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/pcmcia/pcmcia_resource.c: In function ‘pcmcia_map_mem_page’:
drivers/pcmcia/pcmcia_resource.c:255: warning: ‘s’ is used uninitialized in this function

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/pcmcia/pcmcia_resource.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index 717a466..190b8bb 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -251,11 +251,11 @@ int pcmcia_map_mem_page(window_handle_t win, memreq_t *req)
 	struct pcmcia_socket *s;
 	if ((win == NULL) || (win->magic != WINDOW_MAGIC))
 		return -EINVAL;
+	s = win->sock;
 	if (req->Page != 0) {
 		ds_dbg(s, 0, "failure: requested page is zero\n");
 		return -EINVAL;
 	}
-	s = win->sock;
 	win->ctl.card_start = req->CardOffset;
 	if (s->ops->set_mem_map(s, &win->ctl) != 0) {
 		ds_dbg(s, 0, "failed to set_mem_map\n");
-- 
1.6.0.274.g8aacc




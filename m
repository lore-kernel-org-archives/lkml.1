Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYEWNKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYEWNKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbYEWNJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:09:24 -0400
Received: from gw.goop.org ([64.81.55.164]:33898 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbYEWNJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:09:21 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 5] xen pvfb: Zero unused bytes in events sent to backend
X-Mercurial-Node: d4519d6b15a1e1b9625e0bbd93b4471fe1f6b9a2
Message-Id: <d4519d6b15a1e1b9625e.1211547984@localhost>
In-Reply-To: <patchbomb.1211547980@localhost>
Date: Fri, 23 May 2008 14:06:24 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Markus Armbruster <armbru@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Armbruster <armbru@redhat.com>

This isn't a security flaw (the backend can see all our memory
anyway).  But it's the right thing to do all the same.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/video/xen-fbfront.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -61,6 +61,7 @@
 	union xenfb_out_event event;
 	u32 prod;
 
+	memset(&event, 0, sizeof(event));
 	event.type = XENFB_TYPE_UPDATE;
 	event.update.x = x;
 	event.update.y = y;



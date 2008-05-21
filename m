Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbYEUIlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbYEUIlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763340AbYEUIko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:40:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761485AbYEUIkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:40:43 -0400
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       mingo@redhat.com, akpm@linux-foundation.org,
       Pat Campbell <plc@novell.com>
Subject: [PATCH 4/5] xen pvfb: Zero unused bytes in events sent to backend
References: <87d4ngm4s4.fsf@pike.pond.sub.org>
From: Markus Armbruster <armbru@redhat.com>
Date: Wed, 21 May 2008 10:40:31 +0200
Message-ID: <871w3wm4n4.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't a security flaw (the backend can see all our memory
anyway).  But it's the right thing to do all the same.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 drivers/video/xen-fbfront.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 5553e51..291eef6 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -61,6 +61,7 @@ static void xenfb_do_update(struct xenfb_info *info,
 	union xenfb_out_event event;
 	u32 prod;
 
+	memset(&event, 0, sizeof(event));
 	event.type = XENFB_TYPE_UPDATE;
 	event.update.x = x;
 	event.update.y = y;
-- 
1.5.3.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZAGQVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZAGQVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbZAGQUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:20:38 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:63675 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbZAGQUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:20:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=AbPI+ol6aaXE+Z1DTiTRPsC4CKq4tx+/DEqTY/i7Ktrd1xN7cPp6WqMLqsdDWwNUqh
         aKf1A3JfCzqkjhTlz6acSE6XetloKtntDuyvwKohskwT5/0XeNnKztDKm9zxFpgN2Dqc
         3MtFsdrF8nOtWBFRt77ixB/WTF8yxzk1RajT4=
From: Bryan Wu <cooloney@kernel.org>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/2] usb: composite: Fix bug: should test set_alt function pointer before use it
Date: Thu,  8 Jan 2009 00:21:18 +0800
Message-Id: <1231345279-26618-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231345279-26618-1-git-send-email-cooloney@kernel.org>
References: <1231345279-26618-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/gadget/composite.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index f2da026..363951e 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -772,7 +772,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 		f = cdev->config->interface[w_index];
 		if (!f)
 			break;
-		if (w_value && !f->get_alt)
+		if (w_value && !f->set_alt)
 			break;
 		value = f->set_alt(f, w_index, w_value);
 		break;
-- 
1.5.6


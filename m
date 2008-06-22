Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbYFVJJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbYFVJJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 05:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYFVJJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 05:09:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:35197 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbYFVJJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 05:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=kBs4Q275s4FnVyy3MrfSbdT7KRLSwyhS5kmytyWK+prient9zh33Cr5K3zdUlOlT8m
         Idh4YbqwAk8pHJ3lVxOJ5aXg3L4eVzNp3pEGdyru0Jsczbv8OY01zQpDU1rU47rwdPLF
         tKGXIPObACI3ZYh3ZaZBy8MUv2zcFIQMMXVwU=
Date: Sun, 22 Jun 2008 11:08:16 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Daniel =?utf-8?Q?Marjam=C3=A4ki?= <danielm77@spray.se>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] USB: fix possible memory leak in pxa27x_udc
Message-ID: <20080622090813.GA11823@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix memory leak when _ep is null.
http://bugzilla.kernel.org/show_bug.cgi?id=10660

Noticed-by: Daniel Marjamäki <danielm77@spray.se>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/pxa27x_udc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index e02bfd4..e3a5d53 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -650,8 +650,11 @@ pxa_ep_alloc_request(struct usb_ep *_ep, gfp_t gfp_flags)
 {
 	struct pxa27x_request *req;
 
+	if (!_ep)
+		return NULL;
+
 	req = kzalloc(sizeof *req, gfp_flags);
-	if (!req || !_ep)
+	if (!req)
 		return NULL;
 
 	INIT_LIST_HEAD(&req->queue);
-- 
1.5.4.5


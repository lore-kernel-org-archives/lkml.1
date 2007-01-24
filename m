Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088AbXAXWQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbXAXWQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 17:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbXAXWQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 17:16:57 -0500
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:36383 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbXAXWQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 17:16:56 -0500
Message-ID: <45B7D946.90005@kernel.org>
Date: Wed, 24 Jan 2007 14:10:14 -0800
From: Josh Triplett <josh@kernel.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-usb-devel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>, usb-hacking@psas.pdx.edu
Subject: [PATCH] USB: In init_endpoint_class, use PTR_ERR to obtain an errno
 value, not IS_ERR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

init_endpoint_class calls class_create, and checks the result for an error
with IS_ERR; however, if true, it then returns the result of IS_ERR (a
boolean) rather than PTR_ERR (the actual errno).

Signed-off-by: Josh Triplett <josh@kernel.org>
---
 drivers/usb/core/endpoint.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/endpoint.c b/drivers/usb/core/endpoint.c
index 5e628ae..e0ec704 100644
--- a/drivers/usb/core/endpoint.c
+++ b/drivers/usb/core/endpoint.c
@@ -229,7 +229,7 @@ static int init_endpoint_class(void)
 	kref_init(&ep_class->kref);
 	ep_class->class = class_create(THIS_MODULE, "usb_endpoint");
 	if (IS_ERR(ep_class->class)) {
-		result = IS_ERR(ep_class->class);
+		result = PTR_ERR(ep_class->class);
 		goto class_create_error;
 	}
 

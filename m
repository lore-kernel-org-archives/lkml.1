Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYDPRsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYDPRsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYDPRr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:47:57 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:13126 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYDPRr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=nacOasQGrvI9EYdMSwcjdo54L4E/4Fb9/LiRuYVCccVce975iUfQ55+p+Rj6HNwcuHk7PDp1WDv65SJkHfN/bQiXfk5FyU5YLA5uQNn9YJD1aC185F2FTwabNrFtAKaPFQo04+/CXtzSDWNzKpnDAwZQbbcMRar9Q/NKKsTvw9k=
References: <20080416174421.442716301@gmail.com>>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 21:44:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: bfields@fieldses.org, neilb@suse.de, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, kkeil@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 3/3] ThinkPad ACPI: fix possible NULL pointer dereference
Content-Disposition: inline; filename=thinkpad-acpi-null-fix
Message-ID: <48063bc9.2533440a.1932.1fc1@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix potential NULL pointer dereference if kstrdup failed

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

Index: linux-2.6.git/drivers/misc/thinkpad_acpi.c
===================================================================
--- linux-2.6.git.orig/drivers/misc/thinkpad_acpi.c	2008-04-16 20:35:34.000000000 +0400
+++ linux-2.6.git/drivers/misc/thinkpad_acpi.c	2008-04-16 20:36:38.000000000 +0400
@@ -5826,7 +5826,7 @@ static void __init get_thinkpad_model_da
 
 	tp->model_str = kstrdup(dmi_get_system_info(DMI_PRODUCT_VERSION),
 					GFP_KERNEL);
-	if (strnicmp(tp->model_str, "ThinkPad", 8) != 0) {
+	if (tp->model_str && strnicmp(tp->model_str, "ThinkPad", 8) != 0) {
 		kfree(tp->model_str);
 		tp->model_str = NULL;
 	}

-- 

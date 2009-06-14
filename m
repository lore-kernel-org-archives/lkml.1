Return-Path: <linux-kernel-owner+w=401wt.eu-S1761512AbZFNNnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761512AbZFNNnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 09:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758667AbZFNNnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 09:43:07 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:43342 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbZFNNnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 09:43:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Mks9cGb7COp08mlow+Bpb9bTLh8Qn2B2c0CD+u/oE43tvHMCUt/DHYn6fcIGabOYz/
         kWbx/TrzEkF0SSqsURNPqWoXUHwhXnVzg78ofo5WIpBOjpW/yQ6v3B5kB59cs0fslYJH
         3hqeVew94m7BkXrC+fnF9OVvPrepFDH8vFF9A=
MIME-Version: 1.0
In-Reply-To: <1244649318.9942.33.camel@earl.localdomain>
References: <1244649318.9942.33.camel@earl.localdomain>
Date: Sun, 14 Jun 2009 09:43:08 -0400
Message-ID: <48f7fe350906140643o7db4d849jb9139bb2f9e83c23@mail.gmail.com>
Subject: [PATCH 2/3] Re: Radeon kernel modesetting patch (as staging) please 
	review
From: Ryan Hope <rmh3093@gmail.com>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 093f1cb1a1850951f86244ada018672885ec4ace
Author: Ryan Hope <rmh3093@gmail.com>
Date:   Sun Jun 14 09:36:48 2009 -0400

    fix fbcon/radeon initialization order

diff --git a/drivers/gpu/drm/radeon/radeon_drv.c
b/drivers/gpu/drm/radeon/radeon_drv.c
index f70c351..ff4e052 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -345,7 +345,11 @@ static void __exit radeon_exit(void)
        drm_exit(driver);
 }

+#ifdef MODULE
 module_init(radeon_init);
+#else
+late_initcall(radeon_init);
+#endif
 module_exit(radeon_exit);

 MODULE_AUTHOR(DRIVER_AUTHOR);

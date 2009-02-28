Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbZB1PSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbZB1PSA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 10:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZB1PRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 10:17:51 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:63874 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZB1PRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 10:17:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=aRsuqYtLjL6nhZ99WE3m4NcuH5l9J8wOE2DpLezbAwbEns8Kn2lYVGsb5LIf0OZwHi
         IUFyCoK/ZLiq8uVqVTa/Rp9ANGMQXHY+VgnoVc+B/nX/scVQRn39KPx3Y45Hj4fH1bR1
         mNETD84GMt1RpEpGQeMSJwhr3KWqvSoRtUJ58=
Date: Sat, 28 Feb 2009 18:17:47 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] acpi: check for pxm_to_node_map overflow
Message-ID: <20090228151747.GB7835@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is hardly (if ever) possible but in case of broken _PXM
entry we could reach out of pxm_to_node_map array
bounds in acpi_map_pxm_to_node() call.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Len Brown <lenb@kernel.org>
---

It's a patch resend. I didn't get any response on
previous submission from Len, oh :(

Len is the patch really not needed or such a situation
can't happen?

 drivers/acpi/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/drivers/acpi/numa.c
===================================================================
--- linux-2.6.git.orig/drivers/acpi/numa.c
+++ linux-2.6.git/drivers/acpi/numa.c
@@ -277,7 +277,7 @@ int acpi_get_node(acpi_handle *handle)
 	int pxm, node = -1;
 
 	pxm = acpi_get_pxm(handle);
-	if (pxm >= 0)
+	if (pxm >= 0 && pxm < MAX_PXM_DOMAINS)
 		node = acpi_map_pxm_to_node(pxm);
 
 	return node;

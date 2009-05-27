Return-Path: <linux-kernel-owner+w=401wt.eu-S1763448AbZE0OVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763448AbZE0OVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761280AbZE0OVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:21:18 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:43339 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759025AbZE0OVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=CSpoxnMB+CyHZ1xOUmCYGv52/nMdz2wuOxnXKpv/fLBPhCIITAWKEqFz4ergvOWXLj
         rvYyljVveQ181AbV2TxRRGmwmzvn2gEi4xgq/qQ5QWNgpurxU2ypo7b0RDuwnFxk5Th8
         Zmn8LR5Af4/hQxV4Pa+MMxFmj3/Dx6XUJMuOM=
Message-ID: <4A1D4C55.2010300@gmail.com>
Date: Wed, 27 May 2009 17:21:09 +0300
From: Robert Berger <robert.karl.berger@gmail.com>
Reply-To: lkml@reliableembeddedsystems.com, robert.karl.berger@gmail.com
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: sam@ravnborg.org
Subject: [PATCH] fixed _modinst_post - called by modules_install to pick up
 Cross $DEPMOD instead of host depmod
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Berger <robert.berger@reliableembeddedsystems.com>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 739fd34..d1dc869 100644
--- a/Makefile
+++ b/Makefile
@@ -1170,7 +1170,7 @@ _modinst_:
 PHONY += _modinst_post
 _modinst_post: _modinst_
        $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware
__fw_modinst
-       $(call cmd,depmod)
+       $(call cmd,$(DEPMOD))

 else # CONFIG_MODULES

--
1.5.4.5



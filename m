Return-Path: <linux-kernel-owner+w=401wt.eu-S1422910AbXCGRcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422910AbXCGRcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422876AbXCGRbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:31:44 -0500
Received: from mx1.suse.de ([195.135.220.2]:44205 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422822AbXCGRRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:17:07 -0500
Message-Id: <20070307171529.861105873@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ayaz Abdulla <aabdulla@nvidia.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 073/101] forcedeth: disable msix
Content-Disposition: inline; filename=forcedeth-disable-msix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ayaz Abdulla <aabdulla@nvidia.com>

forcedeth: disable msix

There seems to be an issue when both MSI-X is enabled and NAPI is
configured. This patch disables MSI-X until the issue is root caused.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/forcedeth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/drivers/net/forcedeth.c
+++ linux-2.6.20.1/drivers/net/forcedeth.c
@@ -825,7 +825,7 @@ enum {
 	NV_MSIX_INT_DISABLED,
 	NV_MSIX_INT_ENABLED
 };
-static int msix = NV_MSIX_INT_ENABLED;
+static int msix = NV_MSIX_INT_DISABLED;
 
 /*
  * DMA 64bit

--

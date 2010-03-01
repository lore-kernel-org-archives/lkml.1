Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab0CAJru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:47:50 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:38973 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab0CAJrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:47:48 -0500
X-Greylist: delayed 630 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2010 04:47:48 EST
From: Pauli Nieminen <suokkos@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       Pauli Nieminen <suokkos@gmail.com>
Subject: [PATCH] drm/radeon: Fix printf type warning in 64bit system.
Date: Mon,  1 Mar 2010 11:37:11 +0200
Message-Id: <1267436231-5524-1-git-send-email-suokkos@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20100301181452.9efa3661.sfr@canb.auug.org.au>
References: <20100301181452.9efa3661.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Type of iterator was promoted to unsigned long in 64bit systems.

*header is small structure so it is alwas safe to cast return value
of sizeof operator to int.

Signed-off-by: Pauli Nieminen <suokkos@gmail.com>
---
 drivers/gpu/drm/radeon/r300_cmdbuf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r300_cmdbuf.c b/drivers/gpu/drm/radeon/r300_cmdbuf.c
index 18d3ff8..27930fc 100644
--- a/drivers/gpu/drm/radeon/r300_cmdbuf.c
+++ b/drivers/gpu/drm/radeon/r300_cmdbuf.c
@@ -1148,7 +1148,7 @@ int r300_do_cp_cmdbuf(struct drm_device *dev,
 		default:
 			DRM_ERROR("bad cmd_type %i at byte %d\n",
 				  header->header.cmd_type,
-				  cmdbuf->buffer->iterator - sizeof(*header));
+				  cmdbuf->buffer->iterator - (int)sizeof(*header));
 			ret = -EINVAL;
 			goto cleanup;
 		}
-- 
1.6.3.3


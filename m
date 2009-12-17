Return-Path: <linux-kernel-owner+w=401wt.eu-S936082AbZLQBh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936082AbZLQBh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763611AbZLQBU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:20:27 -0500
Received: from kroah.org ([198.145.64.141]:47919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763616AbZLQBUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:16 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:02 2009
Message-Id: <20091217011602.574123357@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [36/90] drm/radeon/kms: Add quirk for HIS X1300 board
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 4e3f9b78ff917cc5c833858fdb5d96bc262e0bf3 upstream.

Board is DVI+VGA, not DVI+DVI

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -134,6 +134,14 @@ static bool radeon_atom_apply_quirks(str
 		}
 	}
 
+	/* HIS X1300 is DVI+VGA, not DVI+DVI */
+	if ((dev->pdev->device == 0x7146) &&
+	    (dev->pdev->subsystem_vendor == 0x17af) &&
+	    (dev->pdev->subsystem_device == 0x2058)) {
+		if (supported_device == ATOM_DEVICE_DFP1_SUPPORT)
+			return false;
+	}
+
 	/* Funky macbooks */
 	if ((dev->pdev->device == 0x71C5) &&
 	    (dev->pdev->subsystem_vendor == 0x106b) &&



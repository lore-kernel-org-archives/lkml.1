Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935224Ab0CMA2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:28:20 -0500
Received: from kroah.org ([198.145.64.141]:32810 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935042Ab0CMAVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:05 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:14 2010
Message-Id: <20100313001514.324083524@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [patch 105/123] drm/radeon/kms/atom: fix shr/shl ops
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 6a8a2d702b33c6ed5c789f21b4e89fdf221f01ca upstream.

The whole attribute table is valid for
shr/shl ops.

Fixes fdo bug 26668

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atom.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -881,8 +881,6 @@ static void atom_op_shl(atom_exec_contex
 	uint8_t attr = U8((*ptr)++), shift;
 	uint32_t saved, dst;
 	int dptr = *ptr;
-	attr &= 0x38;
-	attr |= atom_def_dst[attr >> 3] << 6;
 	SDEBUG("   dst: ");
 	dst = atom_get_dst(ctx, arg, attr, ptr, &saved, 1);
 	shift = atom_get_src(ctx, attr, ptr);
@@ -897,8 +895,6 @@ static void atom_op_shr(atom_exec_contex
 	uint8_t attr = U8((*ptr)++), shift;
 	uint32_t saved, dst;
 	int dptr = *ptr;
-	attr &= 0x38;
-	attr |= atom_def_dst[attr >> 3] << 6;
 	SDEBUG("   dst: ");
 	dst = atom_get_dst(ctx, arg, attr, ptr, &saved, 1);
 	shift = atom_get_src(ctx, attr, ptr);



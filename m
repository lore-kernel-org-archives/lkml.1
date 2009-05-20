Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbZETG3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbZETG3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 02:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZETG24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 02:28:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:34731 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbZETG24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 02:28:56 -0400
Subject: [PATCH 2/2 -tip] drm/i915: intel_lvds.c fix section mismatch
 warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, jarod@redhat.com
Cc: Eric Anholt <eric@anholt.net>, mjg@redhat.com,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242800768.3260.21.camel@localhost.localdomain>
References: <1242800768.3260.21.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 20 May 2009 11:57:35 +0530
Message-Id: <1242800855.3260.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


intel_no_lvds[] does not require __initdata as it is used only by :

  void intel_lvds_init(struct drm_device *dev)

fixes section mismatch warning:

  WARNING: drivers/gpu/drm/i915/i915.o(.text+0xf3c5): Section mismatch in reference from the function intel_lvds_init() to the variable .init.data:intel_no_lvds
  The function intel_lvds_init() references
  the variable __initdata intel_no_lvds.
  This is often because intel_lvds_init lacks a __initdata

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 439a865..5ffadf9 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -391,7 +391,7 @@ static int __init intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
 }
 
 /* These systems claim to have LVDS, but really don't */
-static const struct dmi_system_id __initdata intel_no_lvds[] = {
+static const struct dmi_system_id intel_no_lvds[] = {
 	{
 		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Apple Mac Mini (Core series)",
-- 
1.6.1.1




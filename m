Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbYCNFWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbYCNFWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbYCNFVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:21:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:24244 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215AbYCNFVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OJnLzg3NWsEn4eTls+vJ/pjnumChJrjJaVcSx1ErWCZEn1mLcTMjocLlxU2/ezk1rNXsz1PZtMeNxKt2Kv4l7zDHJpa2ld75eBZVg2k+TN8cBBkxMOi3xv7EYrnwKXIo0V7ANbBpQL8eitH2bczY+gpeoqbZ+tji4wv4GpRd1YA=
Subject: [PATCH 09/10] input: ff-memless.c use clamp_val() macro
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 22:21:34 -0700
Message-Id: <1205472094.19712.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace two opencoded nested min/max macros with clamp_val().

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/input/ff-memless.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
index d226d93..6790e97 100644
--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -247,9 +247,9 @@ static void ml_combine_effects(struct ff_effect *effect,
 		 * in s8, this should be changed to something more generic
 		 */
 		effect->u.ramp.start_level =
-			max(min(effect->u.ramp.start_level + x, 0x7f), -0x80);
+			clamp_val(effect->u.ramp.start_level + x, -0x80, 0x7f);
 		effect->u.ramp.end_level =
-			max(min(effect->u.ramp.end_level + y, 0x7f), -0x80);
+			clamp_val(effect->u.ramp.end_level + y, -0x80, 0x7f);
 		break;
 
 	case FF_RUMBLE:
-- 
1.5.4.4.653.g7cf1e



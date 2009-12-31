Return-Path: <linux-kernel-owner+w=401wt.eu-S1751636AbZLaMDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbZLaMDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 07:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZLaMDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 07:03:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47042 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZLaMDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 07:03:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=a7OI+FOyCCzFD8gd9jF95+XbNGWCn29Qh2jltnlJ9ZIt+X6b3WYcYA5TrABQ8B94Dq
         Dmmg6uiG9iKgyqrZyqCQX6EvXR6rtmw9jRDlLusksDTPf/K3mbQNt+Fuv9D6JmGMPjJr
         6DNM/japmrUQxHiuleN3/l7SEppGxJ7mFNPNo=
Message-ID: <4B3C93C5.9040504@gmail.com>
Date: Thu, 31 Dec 2009 13:06:29 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm/kms: Fix &&/|| confusion in drm_fb_helper_connector_parse_command_line()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This always evaluates to true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/gpu/drm/drm_fb_helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 1b49fa0..100ee48 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -156,7 +156,7 @@ static bool drm_fb_helper_connector_parse_command_line(struct drm_connector *con
 			force = DRM_FORCE_ON;
 			break;
 		case 'D':
-			if ((connector->connector_type != DRM_MODE_CONNECTOR_DVII) ||
+			if ((connector->connector_type != DRM_MODE_CONNECTOR_DVII) &&
 			    (connector->connector_type != DRM_MODE_CONNECTOR_HDMIB))
 				force = DRM_FORCE_ON;
 			else

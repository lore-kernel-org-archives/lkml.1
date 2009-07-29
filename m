Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZG2LYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZG2LYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZG2LY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:24:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50500 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbZG2LY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:24:29 -0400
Date: Wed, 29 Jul 2009 14:23:25 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb/audio: guard kernel-only code with __KERNEL__
Message-ID: <20090729112324.GA15759@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/usb/audio.h is exported to userspace,
so part of this file that is for internal kernel
usage need to be guarded with ifdef __KERNEL__.
This way make headers_install will stript it out.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/usb/audio.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/usb/audio.h b/include/linux/usb/audio.h
index b5744bc..353a300 100644
--- a/include/linux/usb/audio.h
+++ b/include/linux/usb/audio.h
@@ -258,6 +258,8 @@ struct usb_as_iso_endpoint_descriptor {
 };
 #define USB_AS_ISO_ENDPOINT_DESC_SIZE	7
 
+#ifdef __KERNEL__
+
 #define FU_CONTROL_UNDEFINED		0x00
 #define MUTE_CONTROL			0x01
 #define VOLUME_CONTROL			0x02
@@ -311,4 +313,5 @@ struct usb_audio_control_selector {
 	struct usb_descriptor_header *desc;
 };
 
+#endif /* __KERNEL__ */
 #endif /* __LINUX_USB_AUDIO_H */
-- 
1.6.2.5

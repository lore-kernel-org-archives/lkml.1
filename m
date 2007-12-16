Return-Path: <linux-kernel-owner+w=401wt.eu-S1765244AbXLPCVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765244AbXLPCVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 21:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbXLPCVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 21:21:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:52748 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbXLPCVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 21:21:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=C+9vqd2gREi6s8wRtSulxhT3f2beOjEmmrtMnhM5RurdF8PKTBwarMa/5GJMKchOGoQISlJug3PrKaR+noPGy/HUh2SFcugr2QjzaDpvBZ16BGyUdFRvSR1DK9byz61lWh5NXd6WPb9nSK7y+xquH4v/Nt5scTUw3Wy0OVvBV0c=
Date: Sun, 16 Dec 2007 03:23:20 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH RESEND] usbdevfs_urb: __user annotation
Message-ID: <20071216022317.GI26986@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix warning:
drivers/usb/core/devio.c:1226:20: warning: incorrect type in assignment (different address spaces)
drivers/usb/core/devio.c:1226:20:    expected void *usercontext
drivers/usb/core/devio.c:1226:20:    got void [noderef] <asn:1>*

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/usbdevice_fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/usbdevice_fs.h b/include/linux/usbdevice_fs.h
index 8ca5a7f..17cb108 100644
--- a/include/linux/usbdevice_fs.h
+++ b/include/linux/usbdevice_fs.h
@@ -104,7 +104,7 @@ struct usbdevfs_urb {
 	int error_count;
 	unsigned int signr;	/* signal to be sent on completion,
 				  or 0 if none should be sent. */
-	void *usercontext;
+	void __user *usercontext;
 	struct usbdevfs_iso_packet_desc iso_frame_desc[0];
 };

--
1.5.3.4


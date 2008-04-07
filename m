Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbYDGAqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbYDGAqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 20:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbYDGAqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 20:46:09 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:2389 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbYDGAqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 20:46:08 -0400
Message-ID: <47F96EC8.6060407@linuxtv.org>
Date: Sun, 06 Apr 2008 20:46:00 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: LKML <linux-kernel@vger.kernel.org>, v4l-dvb-maintainer@linuxtv.org,
       linux-next@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linus <torvalds@linux-foundation.org>, Mike Isely <isely@pobox.com>
Subject: [PATCH] pvrusb2: fix broken build due to patch order dependency (was
 Re: linux-next: origin build failure)
References: <20080407102716.2e2d3c7a.sfr@canb.auug.org.au>
In-Reply-To: <20080407102716.2e2d3c7a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next build (Linus' tree only, powerpc ppc64_defconfig)
> fails like this:
> 
> drivers/media/video/pvrusb2/pvrusb2-devattr.c:178: error: unknown field 'flag_has_analogtuner' specified in initializer
> drivers/media/video/pvrusb2/pvrusb2-devattr.c:179: error: unknown field 'flag_has_composite' specified in initializer
> drivers/media/video/pvrusb2/pvrusb2-devattr.c:180: error: unknown field 'flag_has_svideo' specified in initializer
> drivers/media/video/pvrusb2/pvrusb2-devattr.c:182: error: unknown field 'digital_control_scheme' specified in initializer
> drivers/media/video/pvrusb2/pvrusb2-devattr.c:182: error: 'PVR2_DIGITAL_SCHEME_HAUPPAUGE' undeclared here (not in a function)
> drivers/media/video/pvrusb2/pvrusb2-devattr.c:183: error: unknown field 'led_scheme' specified in initializer
> drivers/media/video/pvrusb2/pvrusb2-devattr.c:183: error: 'PVR2_LED_SCHEME_HAUPPAUGE' undeclared here (not in a function)
> 
> Introduced by commit 92c9d07507f0a90b64172bfede7e6fa845e8e66b ("V4L/DVB
> (7497): pvrusb2: add new usb pid for 73xxx models").  I have reverted
> that commit for today's linux-next tree.
> 


Sorry about that.  Here is the fix.

From: Michael Krufky <mkrufky@linuxtv.org>
Date: Sun, 6 Apr 2008 20:40:17 -0400
Subject: [PATCH] pvrusb2: fix broken build due to patch order dependency

Fix broken build due to patch order dependency.  A future patch requires
the lines that break the current build.  Disable those lines for now.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/video/pvrusb2/pvrusb2-devattr.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-devattr.c b/drivers/media/video/pvrusb2/pvrusb2-devattr.c
index 98557ce..fe9991c 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-devattr.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-devattr.c
@@ -175,12 +175,16 @@ static const struct pvr2_device_desc pvr2_device_73xxx = {
 		.fx2_firmware.cnt = ARRAY_SIZE(pvr2_fw1_names_73xxx),
 		.flag_has_cx25840 = !0,
 		.flag_has_hauppauge_rom = !0,
+#if 0
 		.flag_has_analogtuner = !0,
 		.flag_has_composite = !0,
 		.flag_has_svideo = !0,
 		.signal_routing_scheme = PVR2_ROUTING_SCHEME_HAUPPAUGE,
 		.digital_control_scheme = PVR2_DIGITAL_SCHEME_HAUPPAUGE,
 		.led_scheme = PVR2_LED_SCHEME_HAUPPAUGE,
+#else
+		.signal_routing_scheme = PVR2_ROUTING_SCHEME_HAUPPAUGE,
+#endif
 };
 
 

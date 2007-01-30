Return-Path: <linux-kernel-owner+w=401wt.eu-S1751577AbXA3Vfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbXA3Vfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbXA3Vfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:35:33 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:33846 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbXA3Vfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:35:32 -0500
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 16:35:31 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding:Sender:Reply-To;
	b=DtCmddquosAVUy/w94FABuIDIYyBOmXfugM5hOs3FNpVV8PnrHUs3DLQIGgRqr2ZQutWmZODuY/QA5oGRtpkfUv2GTr8fDMGBKgfFh1GETtSuSOvU+vA3R368XvxmztK;
Message-ID: <45BFB841.9030200@simon.arlott.org.uk>
Date: Tue, 30 Jan 2007 21:27:29 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] cxacru: Poll for device status more frequently.
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Reply-To: Simon Arlott <3d1f88d2534993eb311hc0vm0003uvpw@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The device is only polled for status every 5 seconds yet status updates occur as often as every second - when the line is down the status changes between "down" and "attempting to activate" every 2 seconds.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

---
 drivers/usb/atm/cxacru.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index c1f97a3..a30cd9b 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -64,7 +64,7 @@ #define BR_STACK_ADDR	0x00187f10
 #define SDRAM_ENA	0x1
 
 #define CMD_TIMEOUT	2000	/* msecs */
-#define POLL_INTERVAL	5000	/* msecs */
+#define POLL_INTERVAL	500	/* msecs */
 
 /* commands for interaction with the modem through the control channel before
  * firmware is loaded  */
-- 
1.4.3.1


-- 
Simon Arlott (subscribed to lkml, don't CC)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764617AbXG3L2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764617AbXG3L2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 07:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbXG3L17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 07:27:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:18233 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbXG3L16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 07:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=Nogu7gl/ld29XPfXkERQMqyF7fx/1ycJM6Uu9clKEpv+ULjf+Z08e/MozrYLR21YiNR/ZIJKhVjtlLgsCc3pohHHerSZ7hbU4HmYeggB4MuILSoLe3kipqElvcA8KxLbsg/7yb7jZjaQJvRWEgVD/1YY+arD6FYa3LBVnX4o17M=
Message-ID: <46ADC3FF.8040506@googlemail.com>
Date: Mon, 30 Jul 2007 12:57:03 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: tony.olech@elandigitalsystems.com, gregkh@suse.de
Subject: [PATCH] drivers/usb/host/u132-hcd.c - Fix a warning when CONFIG_PM=n
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed this warning with CONFING_PM=n 

...

drivers/usb/host/u132-hcd.c:1525: warning: 'port_power' defined but not used

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

 drivers/usb/host/u132-hcd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index 7f765ec..b88eb3c 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -1520,12 +1520,15 @@ static void u132_hcd_endp_work_scheduler(struct work_struct *work)
                 }
         }
 }
+#ifdef CONFIG_PM
 
 static void port_power(struct u132 *u132, int pn, int is_on)
 {
         u132->port[pn].power = is_on;
 }
 
+#endif
+
 static void u132_power(struct u132 *u132, int is_on)
 {
         struct usb_hcd *hcd = u132_to_hcd(u132)

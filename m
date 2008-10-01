Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbYJAKWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbYJAKWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 06:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYJAKW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 06:22:28 -0400
Received: from faui2k3.org ([213.95.10.24]:43278 "EHLO casella.faui2k3.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYJAKW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 06:22:27 -0400
Date: Wed, 1 Oct 2008 12:22:20 +0200
From: Wolfgang Kroener <lkml@azog.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20081001102220.GA4765@lupus.ipv6.sieglitzhof.net>
References: <20080930140658.GL10156@casella.faui2k3.org> <1222812610.9006.74.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1222812610.9006.74.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:a60:f01c:0:70:2:7:10
X-SA-Exim-Mail-From: lkml@azog.de
Subject: Re: [PATCH] suspend/resume for ATI Mobility Radeon RV350
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on casella.faui2k3.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 01, 2008 at 08:10:10, Benjamin Herrenschmidt wrote:
> Can you resend it with a proper Signed-off-by: line ? Thanks !

I hope, that's right.
Kind regards,
Wolfgang
-- 

radeonfb suspend/resume for Acer Travelmate 29X

This patch adds suspend/resume for the Acer Travelmate 290D/292LMi with
the following graphic-chip:
01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV350
[Mobility Radeon 9600 M10] [1002:4e50] (prog-if 00 [VGA controller])
	Subsystem: Acer Incorporated [ALI] TravelMate 290 [1025:005a]
	Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 10
	Memory at a8000000 (32-bit, prefetchable) [size=128M]
	I/O ports at c100 [size=256]
	Memory at e0010000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at a0000000 [disabled] [size=128K]
	Capabilities: [58] AGP version 2.0
	Capabilities: [50] Power Management version 2
	Kernel driver in use: radeonfb
	Kernel modules: radeonfb

Signed-off-by: Wolfgang Kroener <lkml@azog.de>
---
 drivers/video/aty/radeon_pm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/video/aty/radeon_pm.c b/drivers/video/aty/radeon_pm.c
index 675abda..5e4b2da 100644
--- a/drivers/video/aty/radeon_pm.c
+++ b/drivers/video/aty/radeon_pm.c
@@ -89,6 +89,9 @@ static struct radeon_device_id radeon_workaround_list[] = {
 	BUGFIX("Acer Aspire 2010",
 	       PCI_VENDOR_ID_AI, 0x0061,
 	       radeon_pm_off, radeon_reinitialize_M10),
+	BUGFIX("Acer Travelmate 290D/292LMi",
+	       PCI_VENDOR_ID_AI, 0x005a,
+	       radeon_pm_off, radeon_reinitialize_M10),
 	{ .ident = NULL }
 };
 

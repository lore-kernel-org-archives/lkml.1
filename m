Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbXB1M44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbXB1M44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 07:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbXB1M44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 07:56:56 -0500
Received: from sally.edelkey.net ([213.138.147.136]:57947 "EHLO
	sally.edelkey.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbXB1M4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 07:56:55 -0500
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 07:56:55 EST
Message-ID: <45E57A08.5060403@ray.fi>
Date: Wed, 28 Feb 2007 14:48:08 +0200
From: Tommi Kyntola <tommi.kyntola@ray.fi>
Reply-To: tommi.kyntola@ray.fi
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: acpi-devel@lists.sourceforge.net
Subject: [PATCH] acpi: fan after suspend-to-mem fix
X-MIMETrack: Itemize by SMTP Server on raysrv05/RAY(Release 6.5.5 HF456|May 19, 2006) at
 28.02.2007 14:48:09,
	Serialize by Router on raysrv05/RAY(Release 6.5.5 HF456|May 19, 2006) at
 28.02.2007 14:48:10,
	Serialize complete at 28.02.2007 14:48:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


acpi_fan_suspend should probably set state to ACPI_D3, rather than ACPI_D0.
With this change the fan works after S3 suspend atleast on HP nw8000 laptop,
for which the suspended fan has been broken since sword-and-stone.

Signed-off-by: Tommi Kyntola <tommi.kyntola@ray.fi>
---
Why this was ACPI_D0 beats me, but it's been that way since
the _suspend/_resume functios got added in the commit
0feabb01d93e5801d1127416a66cfc3963280bca (2.6.18-rc1, I think).

The fan hasn't worked on my HP nw8000 laptop after an S3 suspend
ever, but fixing that to ACPI_D3 there finally makes it work as
expected.

If there was some hidden reason why that was set to ACPI_D0,
then perhaps a config option for some ICH4 or HP laptops
is called for.

         Kynde

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 045c894..7ae70b0 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -243,7 +243,7 @@ static int acpi_fan_suspend(struct acpi_device *device, int state)
         if (!device)
                 return -EINVAL;

-       acpi_bus_set_power(device->handle, ACPI_STATE_D0);
+       acpi_bus_set_power(device->handle, ACPI_STATE_D3);

         return AE_OK;
  }


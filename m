Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYKNBAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYKNBAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYKNBAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:00:25 -0500
Received: from mail.tpi.com ([198.107.51.143]:1454 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbYKNBAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:00:23 -0500
Message-ID: <491CCD86.7050904@canonical.com>
Date: Thu, 13 Nov 2008 17:59:50 -0700
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mario Limonciello <mario_limonciello@dell.com>
Subject: Re: Dell Wireless 365 requires reset quirk
References: <20081104162448.A338EF8A65@sepang.rtg.net> <20081111145706.9bfb4627.akpm@linux-foundation.org>
In-Reply-To: <20081111145706.9bfb4627.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------060909030701010208060209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060909030701010208060209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Tue,  4 Nov 2008 09:24:48 -0700 (MST)
> timg@tpi.com (Tim Gardner) wrote:
> 
>> >From 931ccb629d739aa563347a4e866bc26107e6b545 Mon Sep 17 00:00:00 2001
>> From: Tim Gardner <tim.gardner@canonical.com>
>> Date: Tue, 4 Nov 2008 09:18:06 -0700
>> Subject: [PATCH] Dell Wireless 365 needs BTUSB_RESET quirk.
>>  OriginalAuthor: Mario Limonciello <mario_limonciello@dell.com>
>>
>> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
>> Cc: stable@kernel.org
>> ---
>>  drivers/bluetooth/btusb.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
>> index af472e0..051b758 100644
>> --- a/drivers/bluetooth/btusb.c
>> +++ b/drivers/bluetooth/btusb.c
>> @@ -125,6 +125,9 @@ static struct usb_device_id blacklist_table[] = {
>>  	/* Dell laptop with Broadcom chip */
>>  	{ USB_DEVICE(0x413c, 0x8126), .driver_info = BTUSB_RESET | BTUSB_WRONG_SCO_MTU },
>>  
>> +	/* Dell Wireless 365 */
>> +	{ USB_DEVICE(0x413c, 0x8160), .driver_info = BTUSB_RESET },
>> +
>>  	/* Dell Wireless 370 */
>>  	{ USB_DEVICE(0x413c, 0x8156), .driver_info = BTUSB_RESET | BTUSB_WRONG_SCO_MTU },
>>  
> 
> I shall assume that this patch was authored by Mario.  This should have
> been communicated by adding his From: line right at the top of the
> changelog.  Mario's signed-off-by: is absent, but that is tolerable
> because we have yours.
> 
> The (absent) changelog fails to explain what effect this patch has. 
> _why_ does this driver need this quirk?
> 
> As it stands, there is insufficient information here for making
> 2.6.28-vs-2.6.29 decisions, let alone 2.6.27.x, 2.6.26.x, etc.
> 

Is this better (aside from being an attachment) ?

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------060909030701010208060209
Content-Type: text/x-patch;
 name="0001--bluetooth-Dell-Wireless-365-needs-BTUSB_RESET-qui.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001--bluetooth-Dell-Wireless-365-needs-BTUSB_RESET-qui.patc";
 filename*1="h"

>From 8da2a85810aa0fb5abbc93d15482846af5d60669 Mon Sep 17 00:00:00 2001
From: Mario Limonciello <mario_limonciello@dell.com>
Date: Tue, 4 Nov 2008 09:18:06 -0700
Subject: [PATCH] bluetooth: Dell Wireless 365 needs BTUSB_RESET quirk.

This patch causes the BT365 to be reset when the driver is loaded.
Without it, you won't be able to connect to other devices or scan for
devices.

Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: stable@kernel.org
---
 drivers/bluetooth/btusb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index af472e0..051b758 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -125,6 +125,9 @@ static struct usb_device_id blacklist_table[] = {
 	/* Dell laptop with Broadcom chip */
 	{ USB_DEVICE(0x413c, 0x8126), .driver_info = BTUSB_RESET | BTUSB_WRONG_SCO_MTU },
 
+	/* Dell Wireless 365 */
+	{ USB_DEVICE(0x413c, 0x8160), .driver_info = BTUSB_RESET },
+
 	/* Dell Wireless 370 */
 	{ USB_DEVICE(0x413c, 0x8156), .driver_info = BTUSB_RESET | BTUSB_WRONG_SCO_MTU },
 
-- 
1.5.6.3


--------------060909030701010208060209--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZKMDJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZKMDJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 22:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZKMDJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 22:09:24 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:40482 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbZKMDJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 22:09:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=RSORPDE6UUyOhW9wUDzVkL9uhGrjUxIcwP5K3d+zOQ6RK6J32s7MHkH9Sb/1Fw6icg
         FfrTCnsQapHD28WpzkdDCxIE1R3oWWujuAkmHw4WZOIAkgHrLll0ZvQLjSCIWJmV/csR
         6/q7dHBucEo8UScLQJCxTpdt3Zx3Fk9vAb8FM=
MIME-Version: 1.0
Date: Fri, 13 Nov 2009 08:39:27 +0530
Message-ID: <4fb5db50911121909h1619e483ga4aa395af8fc1161@mail.gmail.com>
Subject: [patch 0/1] Adding radio type FM
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: majordomo@vger.kernel.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1b1493392faeb6702ff364447b135e481930b397 Mon Sep 17 00:00:00 2001
From: Janakiram Sistla <janakiram.sistla@gmail.com>
Date: Fri, 13 Nov 2009 08:16:26 +0530
Subject: [PATCH 1/1] Adding radio type FM

Adding radio type FM in RFKILL_TYPE_.FM also belongs to
same class of with both TX/RX capability.
Also Added input type for the above same.

Signed-off-by: Janakiram Sistla <janakiram.sistla@gmail.com>
---
 include/linux/input.h  |    1 +
 include/linux/rfkill.h |    1 +
 net/rfkill/core.c      |    2 ++
 net/rfkill/input.c     |    9 +++++++++
 4 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/input.h b/include/linux/input.h
index 0ccfc30..f03ae90 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -376,6 +376,7 @@ struct input_absinfo {
 #define KEY_DISPLAY_OFF		245	/* display device to off state */

 #define KEY_WIMAX		246
+#define KEY_FM			247

 /* Range 248 - 255 is reserved for special needs of AT keyboard driver */

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 3392c59..03f5598 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -45,6 +45,7 @@ enum rfkill_type {
 	RFKILL_TYPE_WIMAX,
 	RFKILL_TYPE_WWAN,
 	RFKILL_TYPE_GPS,
+	RFKILL_TYPE_FM,
 	NUM_RFKILL_TYPES,
 };

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index ba2efb9..b8ac206 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -592,6 +592,8 @@ static const char *rfkill_get_type_str(enum
rfkill_type type)
 		return "wwan";
 	case RFKILL_TYPE_GPS:
 		return "gps";
+	case RRFKILL_TYPE_FM:
+		return "fm";
 	default:
 		BUG();
 	}
diff --git a/net/rfkill/input.c b/net/rfkill/input.c
index a7295ad..f51b16d 100644
--- a/net/rfkill/input.c
+++ b/net/rfkill/input.c
@@ -212,6 +212,9 @@ static void rfkill_event(struct input_handle
*handle, unsigned int type,
 		case KEY_WIMAX:
 			rfkill_schedule_toggle(RFKILL_TYPE_WIMAX);
 			break;
+		case KEY_FM:
+			rfkill_schedule_toggle(RFKILL_TYPE_FM);
+			break;
 		}
 	} else if (type == EV_SW && code == SW_RFKILL_ALL)
 		rfkill_schedule_evsw_rfkillall(data);
@@ -290,6 +293,12 @@ static const struct input_device_id rfkill_ids[] = {
 		.keybit = { [BIT_WORD(KEY_UWB)] = BIT_MASK(KEY_UWB) },
 	},
 	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT |
+				INPUT_DEVICE_ID_MATCH_KEYBIT,
+		.evbit = { BIT_MASK(EV_KEY) },
+		.keybit = { [BIT_WORD(KEY_UWB)] = BIT_MASK(KEY_UWB) },
+	},
+	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
 		.evbit = { BIT_MASK(EV_KEY) },
 		.keybit = { [BIT_WORD(KEY_WIMAX)] = BIT_MASK(KEY_WIMAX) },
-- 
1.5.4.3


Regards,
Janakiram.
janakiram.sistla@gmail.com

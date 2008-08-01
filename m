Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbYHAA2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbYHAA2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 20:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYHAA2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 20:28:16 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:40436 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbYHAA2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 20:28:15 -0400
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: USB HID: Missing keys on Gyration Media Center Universal Remote Control
References: <871w2xnehf.fsf@old-tantale.fifi.org>
	<Pine.LNX.4.64.0806181139490.10085@jikos.suse.cz>
	<87bq1xgnhe.fsf@old-tantale.fifi.org>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 31 Jul 2008 17:28:11 -0700
In-Reply-To: <87bq1xgnhe.fsf@old-tantale.fifi.org>
Message-ID: <87protwpd0.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the record, the enclosed patch makes the remote work for me.

Phil.

X-From-Line: dwalker@dwalker1.mvista.com  Tue Jul  1 09:24:49 2008
Return-Path: <dwalker@dwalker1.mvista.com>
Received: from dwalker1.mvista.com (gateway-1237.mvista.com [63.81.120.158])
	by old-tantale.fifi.org (8.9.3p2/8.9.3/Debian 8.9.3-21) with ESMTP id JAA14827
	for <phil@fifi.org>; Tue, 1 Jul 2008 09:24:48 -0700
X-Authentication-Warning: old-tantale.fifi.org: Host gateway-1237.mvista.com [63.81.120.158] claimed to be dwalker1.mvista.com
Received: from dwalker1.mvista.com (localhost.localdomain [127.0.0.1])
	by dwalker1.mvista.com (8.14.1/8.14.1) with ESMTP id m61GOC0O014533;
	Tue, 1 Jul 2008 09:24:12 -0700
Received: (from dwalker@localhost)
	by dwalker1.mvista.com (8.14.1/8.14.1/Submit) id m61GOBx4014532;
	Tue, 1 Jul 2008 09:24:11 -0700
From: Daniel Walker <dwalker@mvista.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Philippe Troin <phil@fifi.org>, "Adolfo R. Brandes" <arbrandes@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH] hid: gyration remote support
Date: Tue,  1 Jul 2008 09:24:11 -0700
X-Gnus-Mail-Source: directory:~/priv/gnus/procmail
Message-Id: <1214929451-14515-1-git-send-email-dwalker@mvista.com>
X-Mailer: git-send-email 1.5.5.1.1.g0dfaf8
Lines: 67
Xref: old-tantale.fifi.org misc:34763

This adds in a quirk for the additional un-mapped buttons on the
gyration MCE remote.

Defines are now alphabetical.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
---
 drivers/hid/hid-input-quirks.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-input-quirks.c b/drivers/hid/hid-input-quirks.c
index 4c2052c..e6a937a 100644
--- a/drivers/hid/hid-input-quirks.c
+++ b/drivers/hid/hid-input-quirks.c
@@ -89,6 +89,29 @@ static int quirk_logitech_ultrax_remote(struct hid_usage *usage, struct input_de
 	return 1;
 }
 
+static int quirk_gyration_remote(struct hid_usage *usage, struct input_dev *input,
+			      unsigned long **bit, int *max)
+{
+	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_LOGIVENDOR)
+		return 0;
+
+	set_bit(EV_REP, input->evbit);
+	switch(usage->hid & HID_USAGE) {
+		/* Reported on Gyration MCE Remote */
+		case 0x00d: map_key_clear(KEY_HOME);		break;
+		case 0x024: map_key_clear(KEY_DVD);		break;
+		case 0x025: map_key_clear(KEY_PVR);		break;
+		case 0x046: map_key_clear(KEY_MEDIA);		break;
+		case 0x047: map_key_clear(KEY_MP3);		break;
+		case 0x049: map_key_clear(KEY_CAMERA);		break;
+		case 0x04a: map_key_clear(KEY_VIDEO);		break;
+
+		default:
+			return 0;
+	}
+	return 1;
+}
+
 static int quirk_chicony_tactical_pad(struct hid_usage *usage, struct input_dev *input,
 			      unsigned long **bit, int *max)
 {
@@ -303,6 +326,9 @@ static int quirk_sunplus_wdesktop(struct hid_usage *usage, struct input_dev *inp
 #define VENDOR_ID_EZKEY				0x0518
 #define DEVICE_ID_BTC_8193			0x0002
 
+#define VENDOR_ID_GYRATION			0x0c16
+#define DEVICE_ID_GYRATION_REMOTE		0x0002
+
 #define VENDOR_ID_LOGITECH			0x046d
 #define DEVICE_ID_LOGITECH_RECEIVER		0xc101
 #define DEVICE_ID_S510_RECEIVER			0xc50c
@@ -337,6 +363,8 @@ static const struct hid_input_blacklist {
 
 	{ VENDOR_ID_EZKEY, DEVICE_ID_BTC_8193, quirk_btc_8193 },
 
+	{ VENDOR_ID_GYRATION, DEVICE_ID_GYRATION_REMOTE, quirk_gyration_remote },
+
 	{ VENDOR_ID_LOGITECH, DEVICE_ID_LOGITECH_RECEIVER, quirk_logitech_ultrax_remote },
 	{ VENDOR_ID_LOGITECH, DEVICE_ID_S510_RECEIVER, quirk_logitech_wireless },
 	{ VENDOR_ID_LOGITECH, DEVICE_ID_S510_RECEIVER_2, quirk_logitech_wireless },
-- 
1.5.5.1.1.g0dfaf8



X-From-Line: dwalker@dwalker1.mvista.com  Tue Jul  1 09:24:49 2008
Return-Path: <dwalker@dwalker1.mvista.com>
Received: from dwalker1.mvista.com (gateway-1237.mvista.com [63.81.120.158])
	by old-tantale.fifi.org (8.9.3p2/8.9.3/Debian 8.9.3-21) with ESMTP id JAA14828
	for <phil@fifi.org>; Tue, 1 Jul 2008 09:24:48 -0700
X-Authentication-Warning: old-tantale.fifi.org: Host gateway-1237.mvista.com [63.81.120.158] claimed to be dwalker1.mvista.com
Received: from dwalker1.mvista.com (localhost.localdomain [127.0.0.1])
	by dwalker1.mvista.com (8.14.1/8.14.1) with ESMTP id m61GOCIU014537;
	Tue, 1 Jul 2008 09:24:12 -0700
Received: (from dwalker@localhost)
	by dwalker1.mvista.com (8.14.1/8.14.1/Submit) id m61GOCEg014536;
	Tue, 1 Jul 2008 09:24:12 -0700
From: Daniel Walker <dwalker@mvista.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Philippe Troin <phil@fifi.org>, "Adolfo R. Brandes" <arbrandes@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH] hid: gyration sleep button quirk
Date: Tue,  1 Jul 2008 09:24:12 -0700
X-Gnus-Mail-Source: directory:~/priv/gnus/procmail
Message-Id: <1214929451-14515-2-git-send-email-dwalker@mvista.com>
X-Mailer: git-send-email 1.5.5.1.1.g0dfaf8
In-Reply-To: <1214929451-14515-1-git-send-email-dwalker@mvista.com>
References: <1214929451-14515-1-git-send-email-dwalker@mvista.com>
Lines: 34
Xref: old-tantale.fifi.org misc:34762

This patch is based on one provided by Jiri Kosina to handle the sleep
button. I just added some cleanup and integrated it into my series.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
---
 drivers/hid/hid-input-quirks.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-input-quirks.c b/drivers/hid/hid-input-quirks.c
index e6a937a..16feea0 100644
--- a/drivers/hid/hid-input-quirks.c
+++ b/drivers/hid/hid-input-quirks.c
@@ -466,6 +466,18 @@ int hidinput_event_quirks(struct hid_device *hid, struct hid_field *field, struc
 		input_event(input, usage->type, REL_WHEEL, -value);
 		return 1;
 	}
+
+	/* Gyration MCE remote "Sleep" key */
+	if (hid->vendor == VENDOR_ID_GYRATION &&
+	    hid->product == DEVICE_ID_GYRATION_REMOTE &&
+	    (usage->hid & HID_USAGE_PAGE) == HID_UP_GENDESK &&
+	    (usage->hid & 0xff) == 0x82) {
+		input_event(input, usage->type, usage->code, 1);
+		input_sync(input);
+		input_event(input, usage->type, usage->code, 0);
+		input_sync(input);
+		return 1;
+	}
 	return 0;
 }
 
-- 
1.5.5.1.1.g0dfaf8



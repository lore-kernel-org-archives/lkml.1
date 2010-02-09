Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab0BINL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 08:11:59 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:36938 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754247Ab0BINL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 08:11:56 -0500
From: Michael Poole <mdpoole@troilus.org>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Provide a driver for the Apple Magic Mouse
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	<dd18b0c31002082322m4238a4a6m73fc30752ba30447@mail.gmail.com>
	<1265710460.2383.5685.camel@localhost.localdomain>
	<201002090736.55576.edt@aei.ca>
	<alpine.LNX.2.00.1002091339190.30967@pobox.suse.cz>
	<87y6j2eeqv.fsf_-_@troilus.org>
References: <87y6j2eeqv.fsf_-_@troilus.org>
Date: Tue, 09 Feb 2010 08:11:52 -0500
In-Reply-To: <87y6j2eeqv.fsf_-_@troilus.org> (Michael Poole's message of "Tue,
	09 Feb 2010 08:10:48 -0500")
Message-ID: <87tytqeep3.fsf_-_@troilus.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6fd44770774cd672df6f10e4767f4c17bf90bc30 Mon Sep 17 00:00:00 2001
From: Michael Poole <mdpoole@troilus.org>
Date: Sun, 24 Jan 2010 22:32:29 -0500
Subject: [RFC PATCH 3/4] Export hid_register_report().

The Apple Magic Mouse (and probably other devices) publish reports that
are not called out in their HID report descriptors -- they only send them
when enabled through other writes to the device.  This allows a driver to
handle these unlisted reports.

Signed-off-by: Michael Poole <mdpoole@troilus.org>
---
 drivers/hid/hid-core.c |    3 ++-
 include/linux/hid.h    |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index eabe5f8..e39055b 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -51,7 +51,7 @@ EXPORT_SYMBOL_GPL(hid_debug);
  * Register a new report for a device.
  */
 
-static struct hid_report *hid_register_report(struct hid_device *device, unsigned type, unsigned id)
+struct hid_report *hid_register_report(struct hid_device *device, unsigned type, unsigned id)
 {
 	struct hid_report_enum *report_enum = device->report_enum + type;
 	struct hid_report *report;
@@ -75,6 +75,7 @@ static struct hid_report *hid_register_report(struct hid_device *device, unsigne
 
 	return report;
 }
+EXPORT_SYMBOL_GPL(hid_register_report);
 
 /*
  * Register a new field for this report.
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 3661a62..456838c 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -690,6 +690,7 @@ int hid_input_report(struct hid_device *, int type, u8 *, int, int);
 int hidinput_find_field(struct hid_device *hid, unsigned int type, unsigned int code, struct hid_field **field);
 void hid_output_report(struct hid_report *report, __u8 *data);
 struct hid_device *hid_allocate_device(void);
+struct hid_report *hid_register_report(struct hid_device *device, unsigned type, unsigned id);
 int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size);
 int hid_check_keys_pressed(struct hid_device *hid);
 int hid_connect(struct hid_device *hid, unsigned int connect_mask);
-- 
1.6.5.6

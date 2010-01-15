Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0AOCKi (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 21:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791Ab0AOCKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 21:10:37 -0500
Received: from [206.15.93.42] ([206.15.93.42]:15478 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932151Ab0AOCKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 21:10:36 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH] hid-debug.c: make local symbols static
Date: Thu, 14 Jan 2010 19:10:07 -0700
Cc: jkosina@suse.cz
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001141910.08225.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid-debug.c: make local symbols static

The symbols hid_resolv_event and hid_dump_input_mapping
are only used locally in this file. Make them static to prevent
the following sparse warnings:

warning: symbol 'hid_resolv_event' was not declared. Should it be static?
warning: symbol 'hid_dump_input_mapping' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jiri Kosina <jkosina@suse.cz>

---

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 6abd036..cd4ece6 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -864,13 +864,13 @@ static const char **names[EV_MAX + 1] = {
 	[EV_SND] = sounds,			[EV_REP] = repeats,
 };
 
-void hid_resolv_event(__u8 type, __u16 code, struct seq_file *f) {
-
+static void hid_resolv_event(__u8 type, __u16 code, struct seq_file *f)
+{
 	seq_printf(f, "%s.%s", events[type] ? events[type] : "?",
 		names[type] ? (names[type][code] ? names[type][code] : "?") : "?");
 }
 
-void hid_dump_input_mapping(struct hid_device *hid, struct seq_file *f)
+static void hid_dump_input_mapping(struct hid_device *hid, struct seq_file *f)
 {
 	int i, j, k;
 	struct hid_report *report;

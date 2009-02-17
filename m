Return-Path: <linux-kernel-owner+w=401wt.eu-S1752972AbZBQLfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbZBQLfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZBQLf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:35:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZBQLf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:35:27 -0500
From: jirislaby@gmail.com
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, nyet@mrv.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] HID: fix bus handling in scripts/mod/file2alias.c
Date: Tue, 17 Feb 2009 12:35:28 +0100
Message-Id: <1234870528-24562-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Fix endianness of bus member of hid_device_id in modpost.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Reported-by: Nye Liu <nyet@mrv.com>
Cc: Jiri Kosina <jkosina@suse.cz>
---
 scripts/mod/file2alias.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 82a1011..a334428 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -210,6 +210,7 @@ static void do_usb_table(void *symval, unsigned long size,
 static int do_hid_entry(const char *filename,
 			     struct hid_device_id *id, char *alias)
 {
+	id->bus = TO_NATIVE(id->bus);
 	id->vendor = TO_NATIVE(id->vendor);
 	id->product = TO_NATIVE(id->product);
 
-- 
1.6.1.3


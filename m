Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZLZSu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZLZSu1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 13:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZLZSu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 13:50:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:19875 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZLZSu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 13:50:26 -0500
Message-ID: <4B365B96.8050107@gmail.com>
Date: Sat, 26 Dec 2009 19:53:10 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "James E.J. Bottomley" <James.Bottomley@suse.de>,
       linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] dc395x: Decrease iteration for tag_number of max_command
 in start_scsi()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tag_number reaches dcb->max_command + 1 after the loop, but when
the tag_number equals dcb->max_command an error message is already
issued. The last iteration therefore appears obsolete.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/scsi/dc395x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Or maybe we should allow a tag_number of dcb->max_command?

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 6c59c02..f476b52 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1596,7 +1596,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 		u32 tag_mask = 1;
 		u8 tag_number = 0;
 		while (tag_mask & dcb->tag_mask
-		       && tag_number <= dcb->max_command) {
+		       && tag_number < dcb->max_command) {
 			tag_mask = tag_mask << 1;
 			tag_number++;
 		}

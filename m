Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbZBADBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbZBADBk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 22:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZBADB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 22:01:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:60309 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbZBADBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 22:01:24 -0500
Message-ID: <49851037.1090203@kernel.org>
Date: Sun, 01 Feb 2009 12:00:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.com,
       dm-devel@RedHat.com
Subject: [PATCH 1/3] dmraid: set read_info to @offset by default in read_raid_dev()
References: <1233456951-992-1-git-send-email-tj@kernel.org> <49851012.8070904@kernel.org>
In-Reply-To: <49851012.8070904@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 01 Feb 2009 03:00:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read_info is passed from optional f_read_metatdata() to f_setup_rd().
If f_read_metadata() doesn't exist or doesn't initialize it, read_info
contains garbage.  Initialize it to @offset by default.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 lib/format/format.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/format/format.c b/lib/format/format.c
index 88cb938..4a2594a 100644
--- a/lib/format/format.c
+++ b/lib/format/format.c
@@ -435,7 +435,7 @@ read_raid_dev(struct lib_context *lc,
 {
 	struct raid_dev *rd = NULL;
 	void *meta;
-	union read_info info;
+	union read_info info = { .u64 = offset };
 
 	/*
 	 * In case the metadata format handler provides a special
-- 
1.6.0.2


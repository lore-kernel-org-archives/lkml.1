Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYIYLT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYIYLT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYIYLTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:19:49 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:54995 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbYIYLTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:19:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=s7Lab3GIyQQJtqMzTnLef6EiEbByYu9oX6HBsgP4gGQWnLlbzUx2jaKJ09DWBkUsj8
         z95ZV+Gc0kTbPO1W/HxPdjkaXbWzsPiVtcfZ8rcy0KIp9mnKm0+jYx7nxghjiCH/xSFb
         bb7USkHyxPW2TbOCLiFu6xMCR6MyWOscVStSM=
Message-ID: <48DB833A.9010103@gmail.com>
Date: Thu, 25 Sep 2008 13:25:30 +0100
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [Patch -tip 2/3] Tracing/ftrace: Don't consume unhandled entries
 by boot tracer
Content-Type: multipart/mixed;
 boundary="------------070004010803060202070106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070004010803060202070106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

When the boot tracer can't handle an entry output, it returns 1.
It should return 0 to relay on other output functions.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
--

--------------070004010803060202070106
Content-Type: text/plain;
 name="2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.diff"

diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index c65ef8f..d5c9e2e 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -47,7 +47,7 @@ static void boot_trace_ctrl_update(struct trace_array *tr)
 
 static int initcall_print_line(struct trace_iterator *iter)
 {
-	int ret = 1;
+	int ret = 0;
 	struct trace_entry *entry = iter->ent;
 	struct boot_trace *it = &entry->field.initcall;
 	struct trace_seq *s = &iter->seq;

--------------070004010803060202070106--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbYLHDBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbYLHDBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 22:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbYLHDBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 22:01:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58468 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbYLHDBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 22:01:34 -0500
Message-ID: <493C8D40.9000203@cn.fujitsu.com>
Date: Mon, 08 Dec 2008 10:58:08 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ring_buffer: fix comments
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: comments cleanup

fix incorrect comments for enum ring_buffer_type

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index e097c2e..4981a9a 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -28,17 +28,19 @@ struct ring_buffer_event {
  *				 size = 8 bytes
  *
  * @RINGBUF_TYPE_TIME_STAMP:	Sync time stamp with external clock
- *				 array[0] = tv_nsec
- *				 array[1] = tv_sec
+ *				 array[0]    = tv_nsec
+ *				 array[1..2] = tv_sec
  *				 size = 16 bytes
  *
  * @RINGBUF_TYPE_DATA:		Data record
  *				 If len is zero:
  *				  array[0] holds the actual length
- *				  array[1..(length+3)/4-1] holds data
+ *				  array[1..(length+3)/4] holds data
+ *				  size = 4 + 4 + length (bytes)
  *				 else
  *				  length = len << 2
- *				  array[0..(length+3)/4] holds data
+ *				  array[0..(length+3)/4-1] holds data
+ *				  size = 4 + length (bytes)
  */
 enum ring_buffer_type {
 	RINGBUF_TYPE_PADDING,



Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbYDJUii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbYDJUii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758632AbYDJUi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:38:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:59396 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758683AbYDJUi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:38:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cOQ989lUvIw/NYOfA5aC8ikOJ8OsPzJW7osMR+oRZwKpCAoIadDMVl18dqNW2dcDQpdFN0HNxzu/tgO/14PNaGdhlZ1YhwErvY+zb+tQb8/fWP8aNV6WOJ9Z/R2cRC/vvtvLcaAggvl1QUyCVsgE41NWQC/WEb+tjy5OvyR3wJ0=
Subject: [PATCH] lzo: fix possible typo in decompresor
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 10 Apr 2008 13:38:23 -0700
Message-Id: <1207859903.22001.36.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shift of a le value seems strange, probably meant to shift the cpu-order
variable as in the prvious section of the switch statement.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 lib/lzo/lzo1x_decompress.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/lzo/lzo1x_decompress.c b/lib/lzo/lzo1x_decompress.c
index 9dc7056..77f0f9b 100644
--- a/lib/lzo/lzo1x_decompress.c
+++ b/lib/lzo/lzo1x_decompress.c
@@ -158,7 +158,7 @@ match:
 					t += 7 + *ip++;
 				}
 				m_pos -= le16_to_cpu(get_unaligned(
-					(const unsigned short *)ip) >> 2);
+					(const unsigned short *)ip)) >> 2;
 				ip += 2;
 				if (m_pos == op)
 					goto eof_found;
-- 
1.5.5.144.g3e42




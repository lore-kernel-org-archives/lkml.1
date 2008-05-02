Return-Path: <linux-kernel-owner+w=401wt.eu-S1760957AbYEBFTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957AbYEBFTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 01:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYEBFTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 01:19:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:32934 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbYEBFTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 01:19:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RGETR0KsIhhWzUwfMqaSxFrVlc8RFh81OfDqKbQkbbG7nRRNflpoaK91RIwauwSXlCOjXD8G9BJClCsomAqwZI9jbYkUxnWNQcvvbO66AeL27UGWJSb53CDQwBAvt0pF+arvG4QIt1xEpBdbBCCgaUoZJCEl6SuGGkwmyV8e/dw=
Subject: [PATCH 3/6] lzo: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 22:19:33 -0700
Message-Id: <1209705573.22362.39.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 lib/lzo/lzo1x_decompress.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/lzo/lzo1x_decompress.c b/lib/lzo/lzo1x_decompress.c
index 77f0f9b..5dc6b29 100644
--- a/lib/lzo/lzo1x_decompress.c
+++ b/lib/lzo/lzo1x_decompress.c
@@ -138,8 +138,7 @@ match:
 					t += 31 + *ip++;
 				}
 				m_pos = op - 1;
-				m_pos -= le16_to_cpu(get_unaligned(
-					(const unsigned short *)ip)) >> 2;
+				m_pos -= get_unaligned_le16(ip) >> 2;
 				ip += 2;
 			} else if (t >= 16) {
 				m_pos = op;
@@ -157,8 +156,7 @@ match:
 					}
 					t += 7 + *ip++;
 				}
-				m_pos -= le16_to_cpu(get_unaligned(
-					(const unsigned short *)ip)) >> 2;
+				m_pos -= get_unaligned_le16(ip) >> 2;
 				ip += 2;
 				if (m_pos == op)
 					goto eof_found;
-- 
1.5.5.1.350.gbbbf



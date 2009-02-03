Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZBCPvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZBCPvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZBCPvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:51:35 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40574 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274AbZBCPve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:51:34 -0500
From: ericvh@gmail.com
To: v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH] net/9p: fix endian issues
Date: Tue,  3 Feb 2009 09:51:29 -0600
Message-Id: <1233676289-1933-1-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Van Hensbergen <ericvh@gmail.com>

When the changes were done to the protocol last release, some endian
bugs crept in.  This patch fixes those endian problems and has been
verified to run on 32/64 bit and x86/ppc architectures.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 net/9p/protocol.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index dcd7666..19ad5d2 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -164,7 +164,7 @@ p9pdu_vreadf(struct p9_fcall *pdu, int optional, const char *fmt, va_list ap)
 					errcode = -EFAULT;
 					break;
 				}
-				*val = cpu_to_le16(*val);
+				*val = le16_to_cpu(*val);
 			}
 			break;
 		case 'd':{
@@ -173,7 +173,7 @@ p9pdu_vreadf(struct p9_fcall *pdu, int optional, const char *fmt, va_list ap)
 					errcode = -EFAULT;
 					break;
 				}
-				*val = cpu_to_le32(*val);
+				*val = le32_to_cpu(*val);
 			}
 			break;
 		case 'q':{
@@ -182,7 +182,7 @@ p9pdu_vreadf(struct p9_fcall *pdu, int optional, const char *fmt, va_list ap)
 					errcode = -EFAULT;
 					break;
 				}
-				*val = cpu_to_le64(*val);
+				*val = le64_to_cpu(*val);
 			}
 			break;
 		case 's':{
@@ -362,19 +362,19 @@ p9pdu_vwritef(struct p9_fcall *pdu, int optional, const char *fmt, va_list ap)
 			}
 			break;
 		case 'w':{
-				int16_t val = va_arg(ap, int);
+				int16_t val = cpu_to_le16(va_arg(ap, int));
 				if (pdu_write(pdu, &val, sizeof(val)))
 					errcode = -EFAULT;
 			}
 			break;
 		case 'd':{
-				int32_t val = va_arg(ap, int32_t);
+				int32_t val = cpu_to_le32(va_arg(ap, int32_t));
 				if (pdu_write(pdu, &val, sizeof(val)))
 					errcode = -EFAULT;
 			}
 			break;
 		case 'q':{
-				int64_t val = va_arg(ap, int64_t);
+				int64_t val = cpu_to_le64(va_arg(ap, int64_t));
 				if (pdu_write(pdu, &val, sizeof(val)))
 					errcode = -EFAULT;
 			}
-- 
1.5.6.3


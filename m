Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbYKGS7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbYKGS7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYKGS6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:58:45 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:56407 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbYKGS6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:58:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Yc77AJS4bPZ5mwvUqRg/6FilHs2awlRTt8cOxMwp72izS7yn0gHzOGbe9takJrdLIy
         hwGCsSrMLvyhW909sTSVU21L1uYqYRZw0C02Lo29KwiMgWxkIl06h3kLkhB88DFcnSlX
         9jZxK1KkTyxpGaFDaYwi9VNDejdOASlklvd5Q=
Subject: [PATCH-ugly] kmemtrace: casting a gfp_t requires __force
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Eduard Munteanu <eduard.munteanu@linux360.ro>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 10:58:41 -0800
Message-Id: <1226084321.11596.37.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gfp_t is a bitwise type, casting to unsigned long produces a
warning.  Suppress it with __force.

Otherwise sparse complains thusly:
include/linux/kmemtrace.h:33:2: warning: cast from restricted gfp_t

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Eduard, this is a local patch I've had sitting around in my sparse testing
tree.  I'm really not sure what the appropriate format specifier is for a
gfp_t, but I don't think the trace infrastructure has support for it
anyway...so if you are going to keep casting to unsigned long you'll need
this...perhaps with a comment why added.

 include/linux/kmemtrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kmemtrace.h b/include/linux/kmemtrace.h
index 5bea8ea..9d82085 100644
--- a/include/linux/kmemtrace.h
+++ b/include/linux/kmemtrace.h
@@ -34,7 +34,7 @@ static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
 		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
 		   type_id, call_site, (unsigned long) ptr,
 		   (unsigned long) bytes_req, (unsigned long) bytes_alloc,
-		   (unsigned long) gfp_flags, node);
+		   (__force unsigned long)gfp_flags, node);
 }
 
 static inline void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
-- 
1.6.0.3.756.gb776d




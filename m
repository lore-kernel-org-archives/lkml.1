Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYL2Xzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYL2Xzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 18:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbYL2XzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 18:55:23 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:44088 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYL2XzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 18:55:21 -0500
Subject: [PATCH] linux/types.h: Do not depend on __GNUC__ for __le64 and
	__be64
From: Detlef Riekenberg <wine.dev@web.de>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Content-Type: text/plain
Date: Tue, 30 Dec 2008 00:55:21 +0100
Message-Id: <1230594921.7652.35.camel@p4.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18gfFIXv4eBIf1376rJ0krXe4vrXGl8Iee62MEv
	/5HW7HIheEClWvVS1vhZj3ZArH9vtP+t+CwC1lYHSqnnBQ6yeC
	xdwj2mqcs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
<linux/cdrom.h> is used in Wine, but failed to compile with pcc.
(__le64 and __be64 are referenced in <linux/byteorder/little_endian.h>)

There is no reason to restrict the typedefs with __GNUC__.
As reference, the typedefs for __u64 and __s64 where fixed
to be available with pcc on 02. Mai 2008 by H. Peter Anvin
(commit edfa5cfa3dc5bfa95e6aa82a2b8904e7f6c35ed7)

Wine: http://www.winehq.org
pcc:  http://pcc.ludd.ltu.se


Please CC me personally. Thanks

-- 
By by ... Detlef


>From 009605de95d2148c8c54ff83f72ebe0177b805ac Mon Sep 17 00:00:00 2001
From: Detlef Riekenberg <wine.dev@web.de>
Date: Mon, 29 Dec 2008 23:52:48 +0100
Subject: [PATCH] linux/types.h: Do not depend on __GNUC__ for __le64 and
__be64

Signed-off-by: Detlef Riekenberg <wine.dev@web.de>
---
 include/linux/types.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index 1d98330..ccf6742 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -181,10 +181,9 @@ typedef __u16 __bitwise __le16;
 typedef __u16 __bitwise __be16;
 typedef __u32 __bitwise __le32;
 typedef __u32 __bitwise __be32;
-#if defined(__GNUC__)
 typedef __u64 __bitwise __le64;
 typedef __u64 __bitwise __be64;
-#endif
+
 typedef __u16 __bitwise __sum16;
 typedef __u32 __bitwise __wsum;
 
-- 
1.5.4.3





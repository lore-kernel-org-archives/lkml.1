Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbZADAkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbZADAkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759742AbZADAk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:40:28 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:57681 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZADAk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:40:27 -0500
Subject: [PATCH] linux/types.h: Do not depend on __GNUC__ for __le64 and
	__be64 [synced to git]
From: Detlef Riekenberg <wine.dev@web.de>
To: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       trivial@kernel.org
In-Reply-To: <1230594921.7652.35.camel@p4.lan>
References: <1230594921.7652.35.camel@p4.lan>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 01:40:23 +0100
Message-Id: <1231029623.7225.10.camel@p4.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19xLeRQgwietAn3OgAGu41YMB3GbR9oCk/EfF2U
	ql/uHuYJj4TAXbxL1UbgMPRsoCg0pwbJkS1SSezHPMDo6DsSB7
	ChXIdFzkI=
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

This patch is a resync to current git.

Please CC me personally. Thanks
-- 
By by ... Detlef




>From 83199a23ff35af6f10d16ebcb7ca283b3f5f05e3 Mon Sep 17 00:00:00 2001
From: Detlef Riekenberg <wine.dev@web.de>
Date: Thu, 1 Jan 2009 22:55:21 +0100
Subject: [PATCH] linux/types.h: Do not depend on __GNUC__ for
__le64/__be64


Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Detlef Riekenberg <wine.dev@web.de>

---
 include/linux/types.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index 121f349..e2a2788 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -176,10 +176,9 @@ typedef __u16 __bitwise __le16;
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



 



Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbYEPSKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbYEPSKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbYEPSJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:09:51 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:29617 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbYEPSJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=leUORcWaUZWZYB/cF/Hxwwpm9MPxJ+aLuYiOjBbNLXze//+Z0U/PVzixMcJjeeMOWHoR6yuV7n3lMtOxxFabmgONk5BPepyb34vsnVpKxihh+/IWjt6ukm3gByMcbaVzjyxXBeq6Bxo8+APQKRgqTGE+lLNdPI6/rNxpTHyW0hk=
Subject: [RFC-PATCH] lib: add byteorder helpers for the aligned case
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Bryan Wu <cooloney@kernel.org>, Jie Zhang <jie.zhang@analog.com>,
       Oliver Neukum <oliver@neukum.org>, david-b@pacbell.net, greg@kroah.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0805161021450.25035-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0805161021450.25035-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Fri, 16 May 2008 11:09:45 -0700
Message-Id: <1210961386.5915.43.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some users know the pointer they are writing to are aligned,
rather than doing *(__le16 *)ptr = cpu_to_le16(val) add helpers
wrapping this up that have the same convention as put_unaligned_le/be.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Alan, as requested, I'm looking around a bit to see if there are actual
users for this.  But it does make a nice complement to the unaligned
versions.

 include/linux/byteorder/generic.h |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/byteorder/generic.h b/include/linux/byteorder/generic.h
index 0846e6b..38ff3e6 100644
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
@@ -119,6 +119,36 @@
 #define cpu_to_be16s __cpu_to_be16s
 #define be16_to_cpus __be16_to_cpus
 
+static inline void put_le16(u16 val, void *ptr)
+{
+	*(__le16 *)ptr = cpu_to_le16(val);
+}
+
+static inline void put_le32(u32 val, void *ptr)
+{
+	*(__le32 *)ptr = cpu_to_le32(val);
+}
+
+static inline void put_le64(u64 val, void *ptr)
+{
+	*(__le64 *)ptr = cpu_to_le64(val);
+}
+
+static inline void put_be16(u16 val, void *ptr)
+{
+	*(__be16 *)ptr = cpu_to_be16(val);
+}
+
+static inline void put_be32(u32 val, void *ptr)
+{
+	*(__be32 *)ptr = cpu_to_be32(val);
+}
+
+static inline void put_be64(u64 val, void *ptr)
+{
+	*(__be64 *)ptr = cpu_to_be64(val);
+}
+
 /*
  * They have to be macros in order to do the constant folding
  * correctly - if the argument passed into a inline function
-- 
1.5.5.1.570.g26b5e




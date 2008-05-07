Return-Path: <linux-kernel-owner+w=401wt.eu-S1764446AbYEGVTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764446AbYEGVTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYEGVTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:19:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:38262 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbYEGVTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:19:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=p2E5ggPj8OJrk9qv/9s1UWh6X/OOmR1UuETGq27juT14+ZK3etpibah/j6wgcn/M/LiB3EVc69hG/SSAowIW9f94fYDhTCiNQm4K1vN1nwrYJ94czdEuvpsT+TSct33lfkMKHWbBD9MBn9iYo8V6ktlLISdp8gNhH5thwuaNxKM=
Date: Thu, 8 May 2008 02:14:50 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] Fix cpumask_scnprintf_len() misdesign
Message-ID: <20080507221450.GA14375@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpumask_scnprintf_len() takes "len" as an argument which is surprising,
If one follows call chain down it isn't length but number of bits. But
there is natural number of bits when talking about CPU masks -- NR_CPUS.
So use that.

Remove 1:1 wrapper macro while I'm at it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/cpumask.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -289,11 +289,9 @@ static inline int __cpumask_scnprintf(char *buf, int len,
 	return bitmap_scnprintf(buf, len, srcp->bits, nbits);
 }
 
-#define cpumask_scnprintf_len(len) \
-			__cpumask_scnprintf_len((len))
-static inline int __cpumask_scnprintf_len(int len)
+static inline int cpumask_scnprintf_len(void)
 {
-	return bitmap_scnprintf_len(len);
+	return bitmap_scnprintf_len(NR_CPUS);
 }
 
 #define cpumask_parse_user(ubuf, ulen, dst) \


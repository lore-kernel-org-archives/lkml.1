Return-Path: <linux-kernel-owner+w=401wt.eu-S1762549AbXJZBmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762549AbXJZBmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbXJZBmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:42:47 -0400
Received: from ns1.suse.de ([195.135.220.2]:44466 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbXJZBmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:42:46 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix bitmap_scnlistprintf for empty masks
Date: Fri, 26 Oct 2007 03:42:42 +0200
User-Agent: KMail/1.9.6
Cc: pj@sgi.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260342.43058.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When a bitmap is empty bitmap_scnlistprintf would leave the buffer uninitialized.
Set it to an empty string in this case.

I didn't see any in normal kernel callers hitting this, but some custom debug
code of mine did.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6.24-rc1-hack/lib/bitmap.c
===================================================================
--- linux-2.6.24-rc1-hack.orig/lib/bitmap.c
+++ linux-2.6.24-rc1-hack/lib/bitmap.c
@@ -469,6 +469,10 @@ int bitmap_scnlistprintf(char *buf, unsi
 	/* current bit is 'cur', most recently seen range is [rbot, rtop] */
 	int cur, rbot, rtop;
 
+	if (buflen == 0)
+		return 0;
+	buf[0] = 0;
+
 	rbot = cur = find_first_bit(maskp, nmaskbits);
 	while (cur < nmaskbits) {
 		rtop = cur;

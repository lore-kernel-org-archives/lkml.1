Return-Path: <linux-kernel-owner+w=401wt.eu-S1761451AbYESRFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761451AbYESRFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbYESRFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:05:05 -0400
Received: from visualserver.org ([84.242.66.126]:39789 "EHLO visualserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbYESRFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:05:03 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 May 2008 13:05:03 EDT
Date: Mon, 19 May 2008 19:04:55 +0200 (CEST)
From: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>
To: linux-kernel@vger.kernel.org
cc: akinobu.mita@gmail.com
Subject: [PATCH 1/2] bitreversal program
Message-ID: <Pine.LNX.4.64.0805191859411.18461@visualserver.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-visualserver.org-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: C57A82FB42.3C4F8
X-visualserver.org-MailScanner: Found to be clean
X-visualserver.org-MailScanner-From: kernelhacker@visualserver.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- a/include/linux/bitrev.h    2008-04-17 08:19:44.000000000 +0530
+++ b/include/linux/bitrev.h    2008-05-19 21:49:46.000000000 +0530
@@ -3,11 +3,32 @@

  #include <linux/types.h>

-extern u8 const byte_rev_table[256];
+/**
+ * Here is a generalised bit reversal program
+ * @x: word to get bits reversed
+ * @k: key, explained below
+ * for k = 31, it reverses the bits of word(32 bit)
+ * for k = 24, it reverses the bytes in word
+ * for k = 7, it reverses the bits in every byte without
+ * changing the positions of bytes in a word
+ * and for k = 16 it swaps the left and right halves of a
+ * word
+ */

-static inline u8 bitrev8(u8 byte)
+static inline u32 gen_bit_rev(u32 x, u32 k)
  {
-       return byte_rev_table[byte];
+       if(k & 1)
+               x = (x & 0x55555555) << 1 | (x & 0xaaaaaaaa) >> 1;
+       if(k & 2)
+               x = (x & 0x33333333) << 2 | (x & 0xcccccccc) >> 2;
+       if(k & 4)
+               x = (x & 0x0f0f0f0f) << 4 | (x & 0xf0f0f0f0) >> 4;
+       if(k & 8)
+               x = (x & 0x00ff00ff) << 8 | (x & 0xff00ff00) >> 8;
+       if(k & 16)
+               x = (x & 0x0000ffff) << 16 | (x & 0xffff0000) >> 16;
+
+       return x;
  }

  extern u32 bitrev32(u32 in);

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


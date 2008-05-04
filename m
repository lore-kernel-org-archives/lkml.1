Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbYEDTP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbYEDTP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYEDTPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:15:51 -0400
Received: from ns.protei.ru ([195.239.28.26]:45395 "EHLO mail.protei.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279AbYEDTPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:15:51 -0400
X-Greylist: delayed 979 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 May 2008 15:15:51 EDT
Message-ID: <481E076A.8060302@protei.ru>
Date: Sun, 04 May 2008 22:58:50 +0400
From: =?UTF-8?B?0JLQuNC90L7Qs9GA0LDQtNC+0LIg0J3QuNC60L7Qu9Cw0Lkg0JzQuNGF0LA=?=
	 =?UTF-8?B?0LnQu9C+0LLQuNGH?= <nickolay@protei.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] asm-generic/bitops/fls64.h
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bugfix in fls64 on a big endian systems(against 2.6.25).

Signed-off-by: Nickolay Vinogradov <nickolay@protei.ru>

--

diff --git a/include/asm-generic/bitops/fls64.h 
b/include/asm-generic/bitops/fls64.h
index 1b6b17c..2eedb6f 100644
--- a/include/asm-generic/bitops/fls64.h
+++ b/include/asm-generic/bitops/fls64.h
@@ -8,7 +8,7 @@ static inline int fls64(__u64 x)
         __u32 h = x >> 32;
         if (h)
                 return fls(h) + 32;
-       return fls(x);
+       return fls((__u32)x);
  }

  #endif /* _ASM_GENERIC_BITOPS_FLS64_H_ */

-- 
Nickolay Vinogradov
Protei Research and Development Center
St.Petersburg, 194044, Russia
Tel.: +7 812 449 47 27

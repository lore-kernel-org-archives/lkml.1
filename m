Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYIANXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYIANXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYIANXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:23:08 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:8603 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751362AbYIANXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:23:07 -0400
Message-ID: <48BBEC6C.1050301@panasas.com>
Date: Mon, 01 Sep 2008 16:21:48 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] rt2x00: Compiler warning unmasked by fix of BUILD_BUG_ON
References: <48BBE77D.7070007@panasas.com>
In-Reply-To: <48BBE77D.7070007@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Sep 2008 13:21:00.0402 (UTC) FILETIME=[937D1D20:01C90C35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A "Set" of the sign-bit in an "&" operation causes a compiler warning.
Make calculations unsigned.

[ The warning was masked by the use of (void)() cast in the old
  BUILD_BUG_ON() ]

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
TO: Ivo van Doorn <IvDoorn@gmail.com>
TO: John W. Linville <linville@tuxdriver.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/net/wireless/rt2x00/rt2x00reg.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 7e88ce5..c0e8706 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -134,8 +134,8 @@ struct rt2x00_field32 {
  * Note that we cannot use the is_power_of_2() function since this
  * check must be done at compile-time.
  */
-#define is_power_of_two(x)	( !((x) & ((x)-1)) )
-#define low_bit_mask(x)		( ((x)-1) & ~(x) )
+#define is_power_of_two(x)	( !((unsigned)(x) & ((x)-1)) )
+#define low_bit_mask(x)		( ((unsigned)(x)-1) & ~(x) )
 #define is_valid_mask(x)	is_power_of_two(1 + (x) + low_bit_mask(x))
 
 /*

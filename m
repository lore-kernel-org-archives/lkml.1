Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYERV6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYERV6F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 17:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYERV5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 17:57:51 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:40767 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbYERV5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 17:57:50 -0400
Date: Sun, 18 May 2008 23:57:38 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] crypto: make michael_block a function
Message-ID: <20080518215738.GA6711@Chamillionaire.breakpoint.cc>
References: <1210918637.5915.24.camel@brick> <20080516070157.GA9769@Chamillionaire.breakpoint.cc> <1210925405.4000.3.camel@johannes.berg> <1210953123.5915.33.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1210953123.5915.33.camel@brick>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Harvey Harrison | 2008-05-16 08:52:03 [-0700]:

>Well, the code-size difference is significant (about 200 bytes smaller
>on X86-32).  This macro is essentially an inline function that is pretty
>large.

Can you please apply the attached patch and run
| modprobe tcrypt mode=314

before and after your patch?

I get the following numbers on one of my maschines:

before:
~~~~~~~
|test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    122 cycles/operation,    7 cycles/byte
|test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    370 cycles/operation,    5 cycles/byte
|test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    216 cycles/operation,    3 cycles/byte
|test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   1304 cycles/operation,    5 cycles/byte
|test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    746 cycles/operation,    2 cycles/byte
|test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    592 cycles/operation,    2 cycles/byte
|test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   5040 cycles/operation,    4 cycles/byte
|test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   2252 cycles/operation,    2 cycles/byte
|test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   2098 cycles/operation,    2 cycles/byte
|test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  10021 cycles/operation,    4 cycles/byte
|test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   4446 cycles/operation,    2 cycles/byte
|test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   4167 cycles/operation,    2 cycles/byte
|test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   4106 cycles/operation,    2 cycles/byte
|test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  19982 cycles/operation,    4 cycles/byte
|test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   8833 cycles/operation,    2 cycles/byte
|test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   8275 cycles/operation,    2 cycles/byte
|test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   8122 cycles/operation,    1 cycles/byte
|test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39906 cycles/operation,    4 cycles/byte
|test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):  17607 cycles/operation,    2 cycles/byte
|test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):  16492 cycles/operation,    2 cycles/byte
|test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):  16214 cycles/operation,    1 cycles/byte
|test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  16173 cycles/operation,    1 cycles/byte

after:
~~~~~~
|test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    175 cycles/operation,   10 cycles/byte
|test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    510 cycles/operation,    7 cycles/byte
|test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    342 cycles/operation,    5 cycles/byte
|test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   1813 cycles/operation,    7 cycles/byte
|test  4 (  256 byte blocks,   64 bytes per update,   4 updates):   1182 cycles/operation,    4 cycles/byte
|test  5 (  256 byte blocks,  256 bytes per update,   1 updates):   1013 cycles/operation,    3 cycles/byte
|test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   7026 cycles/operation,    6 cycles/byte
|test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   3869 cycles/operation,    3 cycles/byte
|test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   3701 cycles/operation,    3 cycles/byte
|test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  13975 cycles/operation,    6 cycles/byte
|test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   7662 cycles/operation,    3 cycles/byte
|test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   7346 cycles/operation,    3 cycles/byte
|test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   7282 cycles/operation,    3 cycles/byte
|test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  27875 cycles/operation,    6 cycles/byte
|test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):  15247 cycles/operation,    3 cycles/byte
|test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):  14615 cycles/operation,    3 cycles/byte
|test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  14447 cycles/operation,    3 cycles/byte
|test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  55673 cycles/operation,    6 cycles/byte
|test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):  30416 cycles/operation,    3 cycles/byte
|test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):  29155 cycles/operation,    3 cycles/byte
|test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):  28839 cycles/operation,    3 cycles/byte
|test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  28794 cycles/operation,    3 cycles/byte


>
>Harvey

Sebastian

---
 crypto/tcrypt.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1ab8c01..c0040d5 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1761,6 +1761,10 @@ static void do_test(void)
 		test_hash_speed("sha224", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
+	case 314:
+		test_hash_speed("michael_mic", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+
 	case 399:
 		break;
 
-- 
1.5.4.3


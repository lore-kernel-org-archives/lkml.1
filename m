Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbYAPJLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbYAPJLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 04:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYAPJL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 04:11:28 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:36430 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYAPJL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 04:11:27 -0500
Date: Wed, 16 Jan 2008 12:11:38 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: fix conversion from denormal float to double
Message-ID: <20080116091138.GA17506@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trap handler does properly update the fraction,
but not the exponent...

Thanks to Paolo Bonzini <bonzini@gnu.org> for the bug report
and the testcase.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/math-emu/math.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/math-emu/math.c b/arch/alpha/math-emu/math.c
index ae79dd9..58c2669 100644
--- a/arch/alpha/math-emu/math.c
+++ b/arch/alpha/math-emu/math.c
@@ -225,7 +225,7 @@ alpha_fp_emul (unsigned long pc)
 				FP_UNPACK_SP(SB, &vb);
 				DR_c = DB_c;
 				DR_s = DB_s;
-				DR_e = DB_e;
+				DR_e = DB_e + (1024 - 128);
 				DR_f = SB_f << (52 - 23);
 				goto pack_d;
 			}

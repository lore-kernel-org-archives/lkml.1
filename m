Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbYIANCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbYIANCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbYIANCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:02:22 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:17898 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750831AbYIANCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:02:21 -0400
Message-ID: <48BBE77D.7070007@panasas.com>
Date: Mon, 01 Sep 2008 16:00:45 +0300
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
Subject: [PATCHSET 0/5] BUILD_BUG_ON: error on none-const expressions
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Sep 2008 12:59:57.0151 (UTC) FILETIME=[A2884EF0:01C90C32]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Submitted a patchset to fix BUILD_BUG_ON to no longer let through
none compile-time constant expressions. This was debated a few
times on LKML. The final solution is as proposed by Rusty Russell,
which produces all expected results in my tests.
[see: http://www.spinics.net/lists/kernel/msg772904.html]

[PATCH 1/5] debug, x86: move BUILD_BUG_ON() ARRAY_SIZE and __FUNCTION__
  Ingo this is your patch. Please verify?

[PATCH 2/5] net/niu: Fix none-const BUILD_BUG_ON usage
[PATCH 3/5] virtio: Fix none-const BUILD_BUG_ON usage
[PATCH 4/5] rt2x00: Compiler warning unmasked by fix of BUILD_BUG_ON
  These three need maintainers approval. I hope I did not forget
  anyone

[PATCH 5/5] debug: BUILD_BUG_ON: error on none-const expressions
  Finally after all call sites are fixed this can go in.
  (Rusty this one is From: you)

I have only compiled ARCH=x86 (64/32) allmodconfig. So this might
break on other ARCHs. It should spend a night in Linux-Next to expose
these places.

Thanks
Boaz


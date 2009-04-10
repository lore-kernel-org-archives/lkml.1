Return-Path: <linux-kernel-owner+w=401wt.eu-S935381AbZDJQu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935381AbZDJQu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762149AbZDJQuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:50:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:40702 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760304AbZDJQuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:50:14 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [tip PATCH V2] futex: fix futex_wait_setup key handling
To: linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Date: Fri, 10 Apr 2009 09:50:05 -0700
Message-ID: <20090410165005.14342.16973.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the get_futex_key() call were to fail, the existing code would
try and put_futex_key() prior to returning.  This patch makes sure
we only put_futex_key() if get_futex_key() succeeded.

Please apply to -rt and to tip:/core/futexes.

Reported-by: Clark Williams <williams@redhat.com>
Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
---

 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 185c981..47520d2 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1645,7 +1645,7 @@ retry:
 	q->key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, fshared, &q->key);
 	if (unlikely(ret != 0))
-		goto out;
+		return ret;
 
 retry_private:
 	*hb = queue_lock(q);


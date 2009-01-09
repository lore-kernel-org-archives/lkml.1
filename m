Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZAIHw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZAIHw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 02:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbZAIHwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 02:52:49 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34322 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZAIHws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 02:52:48 -0500
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH] RFC: futex fault handling and futex key references (NOT FOR
	INCLUSION)
To: linux-kernel@vger.kernel.org
Date: Thu, 08 Jan 2009 23:52:17 -0800
Message-ID: <20090109075148.2226.5222.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to bend my brain around the various layers of fault handling in
futex.c, I think I may have uncovered some logical errors (or at least stale
code sections).  I've attached two patches that address the alleged problems
against linux-tip/core/futexes.  They are based on the following assumption:

Since the uaddr passed to a futex function isn't updated within the function,
and the mm doesn't change while we're in there, there should never be a need to
make repeat calls to futex_get_key().  Even if the queue_lock is dropped, the
futex_q might lose it's waiter (requeued) but the key stays the same.

I'd really appreciate any feedback.

Thanks in advance,

---

Darren Hart (2):
      RFC: Fix futex_lock_pi fault handling (NOT FOR INCLUSION)
      RFC: Fix futex_wake_op fault handling (NOT FOR INCLUSION)


 kernel/futex.c |   40 ++++++++++++++++------------------------
 1 files changed, 16 insertions(+), 24 deletions(-)

-- 
Signature

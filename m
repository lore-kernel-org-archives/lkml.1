Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYJPBsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYJPBsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 21:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYJPBsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 21:48:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbYJPBsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 21:48:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: prasad@linux.vnet.ibm.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
       mingo@elte.hu, jason.wessel@windriver.com, avi@qumranet.com,
       richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 6/9] Use virtual debug registers in process/thread
	handling code
In-Reply-To: K.Prasad's message of  Thursday, 9 October 2008 00:55:48 +0530 <20081008192548.GF4989@in.ibm.com>
References: <20081008192044.GA4510@in.ibm.com>
	<20081008192548.GF4989@in.ibm.com>
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20081016014407.81BDA1544CB@magilla.localdomain>
Date: Wed, 15 Oct 2008 18:44:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+/*
+	 * Handle debug registers.  This must be done _after_ current
+	 * is updated.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		switch_to_thread_hw_breakpoint(next_p);

It would be good if we could arrange that this works before current changes.
That way it says in __switch_to_xtra, which is off the hot path.

If you are moving it, then you need to match that by removing _TIF_DEBUG
from _TIF_WORK_CTXSW_NEXT.


Thanks,
Roland

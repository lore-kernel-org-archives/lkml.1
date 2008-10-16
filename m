Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbYJPA0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbYJPA0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 20:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbYJPA0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 20:26:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbYJPA0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 20:26:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: prasad@linux.vnet.ibm.com
X-Fcc: ~/Mail/linus
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
       mingo@elte.hu, jason.wessel@windriver.com, avi@qumranet.com,
       richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 3/9] Modifying generic debug exception to use virtual
	debug registers
In-Reply-To: K.Prasad's message of  Thursday, 9 October 2008 00:54:20 +0530 <20081008192420.GC4989@in.ibm.com>
References: <20081008192044.GA4510@in.ibm.com>
	<20081008192420.GC4989@in.ibm.com>
X-Zippy-Says: Gee, I feel kind of LIGHT in the head now, knowing I can't make my
    satellite dish PAYMENTS!
Message-Id: <20081016002555.808EF1544CB@magilla.localdomain>
Date: Wed, 15 Oct 2008 17:25:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You need to redo this (and the whole set) for the post-2.6.27 tree.
e.g. traps.c has been unified.

+	/* Store the virtualized DR6 value */
+	tsk->thread.vdr6 = dr6;
+
+	if (notify_die(DIE_DEBUG, "debug", regs, dr6, error_code,
+			SIGTRAP) == NOTIFY_STOP)
 		return;

I'm not sure you should change vdr6 when notify_die returns NOTIFY_STOP.
Maybe Alan and I hashed out the logic of this before, I don't recall.
If the notifier is eating the event, then it should not affect the
thread-virtualized view of %db6.  That would be consistent with the
existing code, where ->thread.debugreg6 is only set later when all the
intercepted or spurious exceptions have been filtered out.


Thanks,
Roland

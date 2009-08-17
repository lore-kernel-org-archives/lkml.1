Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZHQTgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZHQTgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 15:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbZHQTgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 15:36:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbZHQTgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 15:36:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] inline __fatal_signal_pending
In-Reply-To: Oleg Nesterov's message of  Monday, 17 August 2009 18:31:26 +0200 <20090817163126.GA14581@redhat.com>
References: <20090815003250.8101E40595@magilla.sf.frob.com>
	<20090817163126.GA14581@redhat.com>
X-Zippy-Says: PEGGY FLEMING is stealing BASKET BALLS to feed the babies in VERMONT.
Message-Id: <20090817193549.CE7514730F@magilla.sf.frob.com>
Date: Mon, 17 Aug 2009 12:35:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In fact, I think we do not need 2 helpers. I mean, fatal_signal_pending()
> does not need the signal_pending() check, we can just rename
> __fatal_signal_pending() to fatal_signal_pending(). Should be another
> change of course.

Right, I thought of that too.  I wasn't entirely sure that signal_pending()
vs test_tsk_thread_flag() doesn't have some important barrier-like ordering
effect that just the unlocked sigismember() check wouldn't have.  But if not,
fatal_signal_pending() indeed really only needs to be that one instruction.


Thanks,
Roland

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbYDHTwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbYDHTwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 15:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757850AbYDHTwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 15:52:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593AbYDHTwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 15:52:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] set_restore_sigmask TIF_SIGPENDING
In-Reply-To: Oleg Nesterov's message of  Tuesday, 8 April 2008 15:35:19 +0400 <20080408113519.GA227@tv-sign.ru>
References: <20080329001230.D013726FA1D@magilla.localdomain>
	<20080329001341.7F93826FA1D@magilla.localdomain>
	<alpine.LFD.1.00.0803281746480.14670@woody.linux-foundation.org>
	<20080408113519.GA227@tv-sign.ru>
Emacs: it's not slow --- it's stately.
Message-Id: <20080408195143.57F3326F992@magilla.localdomain>
Date: Tue,  8 Apr 2008 12:51:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Off hand, I concur with you and Linus.  I wasn't involved in the
introduction of TIF_RESTORE_SIGMASK and never thought too much about
it before.  In my recent changes I only considered the issue of
getting it out of _TIF_WORK_MASK et al to free up the low bit, and
didn't contemplate the structure of the implementation beyond that.

I don't think it's "too late" to change anything.  (It's never too
late!  It just might take a while to make a change in a safe and
orderly fashion for all the arch's.)  After my patch series, the
details are fully in the arch's corner.  It should be straightforward
to convert one at a time to use regs->return_register = -ERESTARTRESTOREMASK
to implement set_restore_sigmask() if you want to tackle it.


Thanks,
Roland

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbZJWVIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbZJWVIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 17:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZJWVIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 17:08:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZJWVIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 17:08:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Naohiro Ooiwa <nooiwa@miraclelinux.com>
X-Fcc: ~/Mail/linus
Cc: akpm@linux-foundation.org, oleg@redhat.com,
       LKML <linux-kernel@vger.kernel.org>, h-shimamoto@ct.jp.nec.com,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] show message when exceeded rlimit of pending signals
In-Reply-To: Naohiro Ooiwa's message of  Friday, 23 October 2009 19:07:06 +0900 <4AE1804A.2050404@miraclelinux.com>
References: <4AE1804A.2050404@miraclelinux.com>
Emacs: anything free is worth what you paid for it.
Message-Id: <20091023210707.EDA87AFC4@magilla.sf.frob.com>
Date: Fri, 23 Oct 2009 14:07:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have nothing in particular against the logging.  (However, to me it seems
a little odd to use system-wide logging for normal well-defined error cases
of individual programs.)  This seems to me primarily like a failure of
documentation.

If you'd asked me off hand what EAGAIN from timer_create could mean, I
would have told you right off that you have too many timers or too many
aggregate queued signals.  I'm a person who would happen to know, of
course.  But also, if you look in POSIX.1 for the timer_create definition,
under ERRORS it says:

      [EAGAIN] The system lacks sufficient signal queuing resources to
      	       honor the request.
      [EAGAIN] The calling process has already created all of the timers it
      	       is allowed by this implementation.

Now that is a little vague about it potentially relating to the
RLIMIT_SIGPENDING limit (which is not a POSIX.1 feature, though exactly the
sort of thing permitted by the "is allowed by this implementation" clause).
But it certainly points you in some reasonable directions so this doesn't
seem like it would be such a mystery.

But it's certainly unfortunate that man-pages-3.19 for timer_create has only:

       -EAGAIN
              The system could not process the request.

That description is basically content-free, it applies equally to any
potential error from any call.


Thanks,
Roland

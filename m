Return-Path: <linux-kernel-owner+w=401wt.eu-S1759079AbYG0Tzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079AbYG0Tzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 15:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbYG0TzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 15:55:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622AbYG0TzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 15:55:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wait_task_inactive: don't consider task->nivcsw
In-Reply-To: Oleg Nesterov's message of  Sunday, 27 July 2008 15:37:32 +0400 <20080727113732.GA178@tv-sign.ru>
References: <200807260245.m6Q2jwB4012297@imap1.linux-foundation.org>
	<20080727113732.GA178@tv-sign.ru>
X-Zippy-Says: I wish I was on a Cincinnati street corner holding a clean dog!
Message-Id: <20080727195513.5BE65154284@magilla.localdomain>
Date: Sun, 27 Jul 2008 12:55:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If wait_task_inactive() returns success the task was deactivated.
> In that case schedule() always increments ->nvcsw which alone can
> be used as a "generation counter".

Thanks, that looks fine to me.

> Q: perhaps it is better to do "ncsw = (p->nvcsw << 1) | 1" ? This
> decreases the possibility of "was it unscheduled" false positive
> when ->nvcsw == 0.

That makes sense.


Thanks,
Roland

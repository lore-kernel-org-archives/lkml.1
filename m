Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbYIZPPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbYIZPPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 11:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbYIZPPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 11:15:15 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:59145 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbYIZPPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 11:15:14 -0400
Date: Fri, 26 Sep 2008 19:21:18 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Anirban Sinha <kernel@anirban.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH]: correction: add a new wait_event_interruptible_timeout_modify helper
Message-ID: <20080926152118.GA283@tv-sign.ru>
References: <A1326102-87D8-44AE-856F-A7E49D9E5538@anirban.org> <816CA40C-41C0-4CCF-A75B-F67F1A2B0510@anirban.org> <248103A6-04E3-4F60-BFE4-2D4D42A91F6E@anirban.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <248103A6-04E3-4F60-BFE4-2D4D42A91F6E@anirban.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26, Anirban Sinha wrote:
>
> arrghh!!! my bad. corrected patch is pasted below:

The patch has numerous whitespace damages, please fix your mailer.

But more importantly, it lacks the changelog. And this changelog
should be very convincing, otherwise I'm afraid the patch will be
ignored. It is not common to add the helper which has no users in
kernel.

> + * It also modifies the @timeout value so that if the sleep is
> interrupted
> + * by a signal, the caller can call this helper again with the updated
> + * timeout.

This is a bit misleading... If the task was interrupted, the next
call will check "condition" and return immediately because of
signal_pending(). We should return to the user-space before we
can do interruptible sleep again.


Why do you need this helper? Given that it is trivial to read
jiffies before and after wait_event_interruptible_timeout(),
it doesn't seem to buy too much.

Oleg.


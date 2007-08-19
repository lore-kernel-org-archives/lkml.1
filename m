Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbXHSIi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbXHSIi2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 04:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXHSIiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 04:38:20 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:37151 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbXHSIiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 04:38:19 -0400
Date: Sun, 19 Aug 2007 12:38:27 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 5/5] exec: RT sub-thread can livelock and monopolize CPU on exec
Message-ID: <20070819083827.GA83@tv-sign.ru>
References: <20070818174001.GA218@tv-sign.ru> <20070818232525.9B7554D05C6@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070818232525.9B7554D05C6@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18, Roland McGrath wrote:
>
> Maybe it can use wait_task_inactive, which IIUC is being changed to address
> the same RT issue.

The group_leader can sleep before it enters exit_notify(). In that case
wait_task_inactive() returns, and we still need some polling to wait for
EXIT_ZOMBIE.

> OTOH, notify_count exists only for this.  So maybe the
> better way is to clean that whole mechanism up somehow.

Yes sure. But in any case I think we should avoid polling, we need some
notification from exit_notify().

> The exit.c changes
> in your patch seem to be making it more mysterious rather than less so.

I completely agree.

Oleg.


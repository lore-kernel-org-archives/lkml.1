Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbYHSClm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbYHSClm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 22:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYHSClb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 22:41:31 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:3529 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbYHSCla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 22:41:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUDAMvMqUh5LAMbiGdsb2JhbACSEAEBAQ8gox6BWA
X-IronPort-AV: E=Sophos;i="4.32,232,1217773800"; 
   d="scan'208";a="185128507"
Date: Tue, 19 Aug 2008 12:41:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: Kevin Diggs <kevdig@hypersurf.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Fwd: Corrections please ...]
Message-ID: <20080819024125.GM19760@disturbed>
Mail-Followup-To: Kevin Diggs <kevdig@hypersurf.com>,
	linux-kernel@vger.kernel.org
References: <48AA27AF.9070407@hypersurf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AA27AF.9070407@hypersurf.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 06:53:51PM -0700, Kevin Diggs wrote:
> Could someone ... anyone take a look at these kernel doc additions?
.....
>
> +/**
> + * complete: - signals a single thread waiting on this completion
> + * @x:  holds the state of this particular completion
> + *
> + * This will wake up a single thread waiting on this completion. If  
> multiple

Your mailer appears to be wrapping lines.

> + * threads are waiting ???
> + */
>  void complete(struct completion *x)
>  {
>         unsigned long flags;

complete() will only wake one waiting thread. If there are multiple
waiters, then further calls to complete() are required to wake them,
or a single call to complete_all() could be used.

>  EXPORT_SYMBOL(wait_for_completion);
>
> +/**
> + * wait_for_completion_timeout: - waits for completion of a task  
> (w/timeout)
> + * @x:  holds the state of this particular completion
> + * @timeout:  timeout value in jiffies
> + *
> + * This waits to be signaled for completion of a specific task. It is NOT
> + * interruptible. But there is a timeout in jiffies.

Doesn't read very well.

"This waits for either a completion of a specific task to be signalled
or for a defined length of time. It is not interruptible."

> +/**
> + * wait_for_completion_interruptible_timeout: - waits for completion  
> (w/(to,int
> r))
> + * @x:  holds the state of this particular completion
> + * @timeout:  timeout value in jiffies
> + *
> + * This waits to be signaled for completion of a specific task. It is
> + * interruptible. And there is a timeout in jiffies.
> + */

Same as for wait_for_completion_timeout().

> +/**
> + * wait_for_completion_killable: - waits for completion of a task  
> (killable)
> + * @x:  holds the state of this particular completion
> + *
> + * This waits to be signaled for completion of a specific task. It is
> + * killable (???).
> + */

Killable means that a kill signal will interrupt the wait, but not
all signals will. Typically used in places where you want a user
ctrl-c or a kill command to succeed but don't want any other signal
to interrupt the completion.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

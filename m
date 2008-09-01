Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYIAKBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYIAKBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 06:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757017AbYIAKBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 06:01:37 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34623 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173AbYIAKBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 06:01:37 -0400
Date: Mon, 1 Sep 2008 14:06:31 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Albert Cahalan <acahalan@gmail.com>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: don't confuse /bin/ps by zombie delay_group_leader's
Message-ID: <20080901100631.GA133@tv-sign.ru>
References: <20080830170841.GA7887@tv-sign.ru> <20080901010753.8FA4D154243@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080901010753.8FA4D154243@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31, Roland McGrath wrote:
>

(re-ordered)

> We've known it behaved this way for a very long time, and I've always
> considered it procps's problem to display such situations in ways that
> users find most useful.  It can already quickly tell that situation by a
> "Threads:" line with >1 when "State:" says "Z".

Agreed. It is much better to change /bin/ps and do not touch the kernel.
Albert, what do you think?

Please ignore this patch.

> I don't think it's right to change /proc/pid/task/tid/status this way.
> The real status is true and correct for the individual task, no matter what.
> If you want to change /proc/pid/status, then you ought to split it into
> proc_tgid_status and proc_tid_status variants to differ this way.

Perhaps yes, but

> If you do change it, it
> might be nicer to display it as a (compatible) special case:
>
> State:	S (delayed-leader)

Or "Z (delayed-leader)" if we fix ps. In this case both /proc/pid/status
and /proc/pid/task/tid/status can report the same state.

Oleg.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbYIABKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbYIABKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 21:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYIABKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 21:10:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50615 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbYIABKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 21:10:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Albert Cahalan <acahalan@gmail.com>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: don't confuse /bin/ps by zombie delay_group_leader's
In-Reply-To: Oleg Nesterov's message of  Saturday, 30 August 2008 21:08:41 +0400 <20080830170841.GA7887@tv-sign.ru>
References: <20080830170841.GA7887@tv-sign.ru>
Emacs: a Lisp interpreter masquerading as ... a Lisp interpreter!
Message-Id: <20080901010753.8FA4D154243@magilla.localdomain>
Date: Sun, 31 Aug 2008 18:07:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think it's right to change /proc/pid/task/tid/status this way.
The real status is true and correct for the individual task, no matter what.
If you want to change /proc/pid/status, then you ought to split it into
proc_tgid_status and proc_tid_status variants to differ this way.

I don't really have an opinion either way about this for /proc/pid/status.
We've known it behaved this way for a very long time, and I've always
considered it procps's problem to display such situations in ways that
users find most useful.  It can already quickly tell that situation by a
"Threads:" line with >1 when "State:" says "Z".  If you do change it, it
might be nicer to display it as a (compatible) special case:

State:	S (delayed-leader)


Thanks,
Roland

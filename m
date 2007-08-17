Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbXHQUE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbXHQUE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbXHQUEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:04:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbXHQUEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:04:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wait_task_zombie: don't fight with non-existing race with a dying ptracee
In-Reply-To: Oleg Nesterov's message of  Friday, 17 August 2007 19:37:40 +0400 <20070817153740.GA1098@tv-sign.ru>
X-Zippy-Says: The SAME WAVE keeps coming in and COLLAPSING like a rayon MUU-MUU..
Message-Id: <20070817200415.85ADA4D05B2@magilla.localdomain>
Date: Fri, 17 Aug 2007 13:04:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> (textually depends on wait_task_zombie-remove-unneeded-child-signal-check.patch)
> 
> The "p->exit_signal == -1 && p->ptrace == 0" check and the comment are bogus.
> We already did exactly the same check in eligible_child(), we did not drop
> tasklist_lock since then, and both variables need write_lock(tasklist) to be
> changed.

I think this is correct.  IIRC, when the check was added, ->ptrace could be
cleared some other way.


Thanks,
Roland

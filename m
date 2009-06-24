Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbZFXJsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbZFXJsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759025AbZFXJrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:47:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759064AbZFXJrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:47:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Ratan Nalumasu <rnalumasu@gmail.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] change __wake_up_parent() to use filtered wakeup
In-Reply-To: Oleg Nesterov's message of  Monday, 22 June 2009 19:04:37 +0200 <20090622170437.GA4906@redhat.com>
References: <20090622170437.GA4906@redhat.com>
X-Windows: you'll envy the dead.
Message-Id: <20090624091316.73D0F4059B@magilla.sf.frob.com>
Date: Wed, 24 Jun 2009 02:13:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, I'm glad to see this revived.  

I note that even simpler than eligible_child() is just:

	if ((wo->wo_flags & __WNOTHREAD) && wo->child_wait.private != p->parent)
		return 0;

IIRC that is the test that Ratan's original patch used to address the
particular application usage that first troubled him.  But probably this
is already what you meant by "more clever later" (and ->parent is perhaps
not right in all cases there).

Your two patches as they are look safe and useful to me and I hope they can
go in soon.


Thanks,
Roland

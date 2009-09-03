Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZICUMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZICUMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756354AbZICUMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:12:06 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:32831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756325AbZICUMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:12:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       Tom Horsley <tom.horsley@att.net>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 1/1] exec: do not sleep in TASK_TRACED under
	->cred_guard_mutex
In-Reply-To: Oleg Nesterov's message of  Thursday, 3 September 2009 18:05:14 +0200 <20090903160514.GA23646@redhat.com>
References: <20090903160514.GA23646@redhat.com>
Emacs: a learning curve that you can use as a plumb line.
Message-Id: <20090903200924.E46DF47C94@magilla.sf.frob.com>
Date: Thu,  3 Sep 2009 13:09:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I certainly think it's right to hold the mutex only as long as necessary.
Clearly holding it when we stop is wrong.

I'm a bit concerned about holding it for arbitrary periods while we block
in the filesystem code.  e.g., consider the scenario with a hangs-forever
NFS server or suchlike.  But I'm not sure there is a reasonable way around
that one.

The paired calls that leave the mutex locked in between should have some
clear comments calling attention to their pairing.  Aside from that making
sure that subtlety is clear, I don't see any problems in the patch off hand.
But I haven't scoured the code path lately to have full confidence.
I'd like to hear David's reactions.


Thanks,
Roland

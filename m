Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbZEAVdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbZEAVdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 17:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZEAVc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 17:32:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43899 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbZEAVc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 17:32:57 -0400
Date: Fri, 1 May 2009 23:32:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/6] kill-the-BKL/reiserfs3: performance improvements,
	faster than Bkl based scheme
Message-ID: <20090501213235.GA20235@elte.hu>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com> <alpine.LFD.2.00.0905011236530.5379@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0905011236530.5379@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 1 May 2009, Frederic Weisbecker wrote:
> > 
> > This reiserfs patchset applies against latest 
> > tip:core/kill-the-BKL It adds various explicit write lock 
> > releases on specific sleeping sections.
> 
> Btw, is there any reason why it cannot just be re-based on top of 
> standard -rc4?
> 
> I'd love to pull a "reiserfs: remove bkl" branch when the next 
> merge window opens, but there's no way I'll pull the kill-bkl 
> thing with all the odd random tty stuff etc that is totally 
> unrelated.

Btw., i can name another reason why we'd want to do reiserfs 
separately: if our testing and efforts are any proof, then reiser3 
turned out to be the hardest BKL nut to crack, by a wide margin.

All the other hacks in kill-the-BKL are really of relatively low 
complexity and really just tried to map out the problem areas. Even 
the tty ones are simple - just a few recursion assumptions.

We _suspected_ that kind of status quo before, but we never had any 
conclusive proof of that. I think we now know that for sure, and we 
have to fear the BKL no more.

After the reiser3 conversion we should just tackle all the other BKL 
users one by one, and go for a straight subsystem mutex in every 
case: it will cause little trouble, and it will be a job that can be 
finished within a reasonable time frame.

	Ingo

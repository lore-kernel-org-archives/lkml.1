Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbZBJXxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbZBJXxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbZBJXxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:53:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbZBJXxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:53:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] forget_original_parent: cleanup ptrace pathes
In-Reply-To: Oleg Nesterov's message of  Wednesday, 11 February 2009 00:40:14 +0100 <20090210234014.GA15411@redhat.com>
References: <20090129080603.GA26882@redhat.com>
	<20090205024021.04DDDFC381@magilla.sf.frob.com>
	<20090205153301.GC20953@redhat.com>
	<20090209023626.03C7DFC330@magilla.sf.frob.com>
	<20090210224751.GA9478@redhat.com>
	<20090210232324.399ADFC3DB@magilla.sf.frob.com>
	<20090210234014.GA15411@redhat.com>
X-Windows: even your dog won't like it.
Message-Id: <20090210235310.AEE3EFC35D@magilla.sf.frob.com>
Date: Tue, 10 Feb 2009 15:53:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes. But since I am paranoid, can we move the callsite later? I mean,
> I'd prefer to make a separate (trivial) patch which moves it.

Absolutely.

> Agreed, and probably forget_original_parent() can check empty(->children) too.

Yes, that might optimize (vs what we've always done) a case so common that
it actually makes a bit of difference in the grand scale. :-)

> Yes, nobody should at least. Nobody can find this task on its own list.

I was more worried about presumptions of all the linkage being complete
until release_task.  But I don't see any actual thing to worry about.

> If you don't mind, I'd prefer to make these changes on top of [PATCH 3/4],
> reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
> (and this one should be dropped).
> 
> Because that patch fixes the bug and changes the behaviour, while the
> discussed changes are cleanups.

I don't object to that patch first (and it might be fine for -stable even)
as long as these cleanups are really going in soon so that ->ptrace_entry
abuse disappears quickly.


Thanks,
Roland

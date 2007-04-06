Return-Path: <linux-kernel-owner+w=401wt.eu-S1751345AbXDFSbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbXDFSbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 14:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbXDFSbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 14:31:20 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47765 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbXDFSbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 14:31:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
	<Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
	<46159987.6090006@redhat.com>
	<Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
	<m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
	<20070406104301.GB19755@lnx-holt.americas.sgi.com>
	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
	<20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu>
Date: Fri, 06 Apr 2007 12:30:18 -0600
In-Reply-To: <20070406173249.GA2517@elte.hu> (Ingo Molnar's message of "Fri, 6
	Apr 2007 19:32:49 +0200")
Message-ID: <m11wix73ut.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> no. Two _completely separate_ lists.
>
> i.e. a to-be-reaped task will still be on the main list _too_. The main 
> list is for all the PID semantics rules. The reap-list is just for 
> wait4() processing. The two would be completely separate.

And what pray tell except for heuristics is the list of children used for?

I could find a use in the scheduler (oldest_child and younger/older_sibling).
I could find a use in mm/oom_kill.

I could find a use in irixsig where it roles it's own version of wait4.

Perhaps I was blind but that was about it.

I didn't see the child list implementing any semantics we really care
about to user space.

Eric

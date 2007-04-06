Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXDFTkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXDFTkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932309AbXDFTkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:40:45 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36552 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbXDFTkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:40:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Robin Holt <holt@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
	<Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
	<46159987.6090006@redhat.com>
	<Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
	<20070406180552.GH32549@infradead.org>
Date: Fri, 06 Apr 2007 13:39:36 -0600
In-Reply-To: <20070406180552.GH32549@infradead.org> (Christoph Hellwig's
	message of "Fri, 6 Apr 2007 19:05:52 +0100")
Message-ID: <m1odm15m2v.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> As all kernel thread (1) should be converted to kthread anyway for
> proper containers support and general "let's get rid of a crappy API'
> cleanups I think that's enough.  It would be nice to have SGI helping
> to convert more drivers over to the proper API as conversions have stalled
> a little bit.
>
>
> (1) There's a few very core kernel threads that need to stick to the
>     low-level API, but they're too few to make any differences.

Yes.  I had to step back and remind myself why I care as daemonize is
currently doing an effective job of removing the namespace information.

However there is nothing daemonize can do about the pid of the task
because it is returned by kernel_thread and used by the callers 
(to at the very least find the task_struct).

So not finishing that conversion is certainly one of the last blockers
for implementing the pid namespace.

Eric

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbZIRJqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbZIRJqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 05:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZIRJqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 05:46:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59469 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274AbZIRJqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 05:46:48 -0400
Date: Fri, 18 Sep 2009 11:46:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Patch 1/2] ia32: use generic sys_pipe()
Message-ID: <20090918094642.GA26833@elte.hu>
References: <20090722091051.6621.15184.sendpatchset@localhost.localdomain> <20090804122432.GB4367@elte.hu> <20090912133014.GA5858@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090912133014.GA5858@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Tue, Aug 04, 2009 at 02:24:32PM +0200, Ingo Molnar wrote:
> 
> > Please _ALWAYS_ mention the change in behavior in the changelog, 
> > just in case someone ends up bisecting it. I only found out when i 
> > reviewed the two syscalls out of caution.
> > 
> > The syscall you remove kept stale fd's around in case of -EFAULT 
> > from copy_to_user(). The generic version does an explicit close of 
> > those files:
> > 
> >                         sys_close(fd[0]);
> >                         sys_close(fd[1]);
> >                         error = -EFAULT;
> 
> > The generic version looks like the better choice to me but this 
> > difference should be mentioned in the changelog nevertheless, just 
> > in case some buggy app runs into this issue.
> 
> It's not a matter of QOI, actually - sys32_pipe() is supposed to do 
> what sys_pipe() would do on i386 host.  So any difference in handling 
> of an error case is simply wrong.
> 
> Whether we want those sys_close() in sys_pipe() or not is a separate 
> question, but we definitely want the same behaviour when 32bit process 
> is run natively and when it's run on amd64.  So sys32_pipe() has no 
> business existing at all.

I generally agree except the notion that we 'must' do this change.

This is a (small) past ABI sin of ours and we have to live with the 
consequences without breaking apps. We didnt break any it appears so 
it's all good.

	Ingo

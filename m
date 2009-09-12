Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbZILOQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbZILOQW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 10:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZILOQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 10:16:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39620 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbZILOQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 10:16:21 -0400
Date: Sat, 12 Sep 2009 14:30:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Patch 1/2] ia32: use generic sys_pipe()
Message-ID: <20090912133014.GA5858@ZenIV.linux.org.uk>
References: <20090722091051.6621.15184.sendpatchset@localhost.localdomain> <20090804122432.GB4367@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804122432.GB4367@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 02:24:32PM +0200, Ingo Molnar wrote:

> Please _ALWAYS_ mention the change in behavior in the changelog, 
> just in case someone ends up bisecting it. I only found out when i 
> reviewed the two syscalls out of caution.
> 
> The syscall you remove kept stale fd's around in case of -EFAULT 
> from copy_to_user(). The generic version does an explicit close of 
> those files:
> 
>                         sys_close(fd[0]);
>                         sys_close(fd[1]);
>                         error = -EFAULT;

> The generic version looks like the better choice to me but this 
> difference should be mentioned in the changelog nevertheless, just 
> in case some buggy app runs into this issue.

It's not a matter of QOI, actually - sys32_pipe() is supposed to do what
sys_pipe() would do on i386 host.  So any difference in handling of an
error case is simply wrong.

Whether we want those sys_close() in sys_pipe() or not is a separate
question, but we definitely want the same behaviour when 32bit process is
run natively and when it's run on amd64.  So sys32_pipe() has no business
existing at all.

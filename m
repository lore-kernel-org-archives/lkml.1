Return-Path: <linux-kernel-owner+w=401wt.eu-S1763274AbYBFAqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763274AbYBFAqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 19:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760945AbYBFAqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 19:46:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760892AbYBFAqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 19:46:44 -0500
Date: Tue, 5 Feb 2008 16:46:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: softlockup: automatically detect hung TASK_UNINTERRUPTIBLE
 tasks
Message-Id: <20080205164626.f9c920e0.akpm@linux-foundation.org>
In-Reply-To: <200801252259.m0PMxHmD012059@hera.kernel.org>
References: <200801252259.m0PMxHmD012059@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008 22:59:17 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=82a1fcb90287052aabfa235e7ffc693ea003fe69
> Commit:     82a1fcb90287052aabfa235e7ffc693ea003fe69
> Parent:     d0d23b5432fe61229dd3641c5e94d4130bc4e61b
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Fri Jan 25 21:08:02 2008 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri Jan 25 21:08:02 2008 +0100
> 
>     softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks

One of my test boxes (an 8-way x86_64 software-development thing from Intel
- I'm not sure what's inside it) no longer powers itself off when I run `halt
-pfn'.

During bisection I found two different problems.  Sometimes the machine
wouldn't power off at all.  Other times it would power off after a pause of
around twenty seconds.

Bisection indicates that this commit is what caused the 20-second pause. 
It could be that some later commit caused the infinity-second pause.


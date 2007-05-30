Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbXE3Lrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbXE3Lrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 07:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbXE3Lro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 07:47:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbXE3Lrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 07:47:43 -0400
Date: Wed, 30 May 2007 07:47:45 -0400
From: Jeff Layton <jlayton@redhat.com>
To: David Chinner <dgc@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add procfs tunable to enable immediate panic when there
 are busy inodes after umount
Message-Id: <20070530074745.15b8355b.jlayton@redhat.com>
In-Reply-To: <20070530002857.GW85884050@sgi.com>
References: <20070529114042.5fe0b810.jlayton@redhat.com>
	<20070530002857.GW85884050@sgi.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 10:28:57 +1000
David Chinner <dgc@sgi.com> wrote:

> On Tue, May 29, 2007 at 11:40:42AM -0400, Jeff Layton wrote:
> > After spending quite a bit of time tracking down a "VFS: busy inodes
> > after unmount" problem, it occurs to me that it would be nice to be
> > able to force a panic when that occurs. While an oops message alone is
> > not generally helpful for tracking down this sort of problem,
> > collecting and analyzing a coredump when this occurs can be.
> 
> Agreed - we've found that we've had roughly 50% success in finding
> the cause of these problems from crash dumps triggered immediately
> like this vs ~0% from a crash that occurred some time later.
> 
> Given that this problem will always result in a crash of the kernel
> at some random time in the future, why don't we just make this error
> an unconditional panic on get the crash over and done with?
> 

Perhaps that's the best course of action. Then again, there can be a
long time between the problem and crash (weeks even). For someone who
can't collect a coredump, it might be preferable to not immediately
crash the box and allow them to try to reboot it at a convenient time.
That was my reasoning for adding the procfs tunable.

Either way, if the machine doesn't crash immediately, I'd like to see a
different error message here. The current one is confusing to users.
They see it and figure "my box didn't crash in 5 mins, so everything
must be OK!"

-- 
Jeff Layton <jlayton@redhat.com>

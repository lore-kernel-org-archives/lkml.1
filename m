Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbXE3A3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbXE3A3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbXE3A3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:29:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52593 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750799AbXE3A3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:29:07 -0400
Date: Wed, 30 May 2007 10:28:57 +1000
From: David Chinner <dgc@sgi.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add procfs tunable to enable immediate panic when there are busy inodes after umount
Message-ID: <20070530002857.GW85884050@sgi.com>
References: <20070529114042.5fe0b810.jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529114042.5fe0b810.jlayton@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 11:40:42AM -0400, Jeff Layton wrote:
> After spending quite a bit of time tracking down a "VFS: busy inodes
> after unmount" problem, it occurs to me that it would be nice to be
> able to force a panic when that occurs. While an oops message alone is
> not generally helpful for tracking down this sort of problem,
> collecting and analyzing a coredump when this occurs can be.

Agreed - we've found that we've had roughly 50% success in finding
the cause of these problems from crash dumps triggered immediately
like this vs ~0% from a crash that occurred some time later.

Given that this problem will always result in a crash of the kernel
at some random time in the future, why don't we just make this error
an unconditional panic on get the crash over and done with?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

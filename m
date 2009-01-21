Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbZAUFxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbZAUFxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 00:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZAUFxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 00:53:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43225 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZAUFxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 00:53:09 -0500
To: Mike Waychison <mikew@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 0/8] Deferred dput() and iput() -- reducing lock contention
From: Andi Kleen <andi@firstfloor.org>
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
Date: Wed, 21 Jan 2009 06:52:16 +0100
In-Reply-To: <20090117022936.20425.43248.stgit@crlf.corp.google.com> (Mike Waychison's message of "Fri, 16 Jan 2009 18:29:36 -0800")
Message-ID: <877i4pdx4f.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Waychison <mikew@google.com> writes:

> livelock on dcache_lock/inode_lock (specifically in atomic_dec_and_lock()) 

I'm not sure how something can livelock in atomic_dec_and_lock which
doesn't take a spinlock itself? Are you saying you run into NUMA memory
unfairness here? Or did I misparse you?

> This patchset is an attempt to try and reduce the locking overheads associated
> with final dput() and final iput().  This is done by batching dentries and
> inodes into per-process queues and processing them in 'parallel' to consolidate
> some of the locking.

I was wondering what this does to the latencies when dput/iput
is only done for very objects. Does it increase costs then
significantly?

As a high level comment it seems like a lot of work to work
around global locks, like the inode_lock, where it might be better to 
just split the lock up? Mind you I don't have a clear proposal
how to do that, but surely it's doable somehow.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761969AbZEOQlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969AbZEOQlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 12:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbZEOQk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 12:40:59 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:50046 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbZEOQk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 12:40:58 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, Andrew Morton <akpm@linux-foundation.org>,
       xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       Anton Salikhmetov <salikhmetov@gmail.com>
Subject: Re: mmap vs mtime in 2.6.26 and up
References: <874ovws94s.fsf@tac.ki.iif.hu> <87ljp2v6vt.fsf@tac.ki.iif.hu>
	<2c0942db0905120837g702b457bm52a412293925021a@mail.gmail.com>
	<20090512155301.GA23160@infradead.org>
Date: Fri, 15 May 2009 18:40:29 +0200
In-Reply-To: <20090512155301.GA23160@infradead.org> (Christoph Hellwig's
	message of "Tue, 12 May 2009 11:53:01 -0400")
Message-ID: <87ws8i720y.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Tue, May 12, 2009 at 08:37:43AM -0700, Ray Lee wrote:
>>> I've noticed that the last modification times of our RRD files got
>>> stuck after upgrading from 2.6.24 to 2.6.26 (Debian Etch -> Lenny; I
>>> also tested with 2.6.30-rc5, they are still stuck). ??It has some
>>> literature, most notably kernel bug #2645, but that's closed long ago
>>> and the resulting patch http://lkml.org/lkml/2008/1/22/370 is present
>>> in my kernels. ??Still, the test program (version 3 from the bug report)
>>> gives failures:
>
> The problem is pretty simple.  do_wp_page and __do_fault use
> file_update_time to update ctime and mtime.  But this function is only
> a helper for simply filesystems that have a binary inode dirty/non dirty
> state and keep the m/ctime purely in the Linux inode.  It must not be
> called from generic code as more complex filesystems need a notification
> through ->setattr to update the timestamps.  This will also affect other
> filesystems like ubifs.  I'm not entirely sure why it ever worked
> before, we must have picked up those c/mtime updates by accident
> somehow.

Thanks for the analysis.  Unfortunately I don't nearly know enough to
work on this issue, but would like to track it as it affects our
backup system.  So, shouldn't #2645 be reopened again?
-- 
Feri.

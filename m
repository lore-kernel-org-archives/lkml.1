Return-Path: <linux-kernel-owner+w=401wt.eu-S1766947AbXDSTP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766947AbXDSTP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766949AbXDSTPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:15:25 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39253 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766947AbXDSTPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:15:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd_blkdevs: Convert to use the kthread API
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769657692046-git-send-email-ebiederm@xmission.com>
	<20070419164746.GA19469@infradead.org>
Date: Thu, 19 Apr 2007 13:13:22 -0600
In-Reply-To: <20070419164746.GA19469@infradead.org> (Christoph Hellwig's
	message of "Thu, 19 Apr 2007 17:47:46 +0100")
Message-ID: <m11wigmb3h.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Thu, Apr 19, 2007 at 12:55:28AM -0600, Eric W. Biederman wrote:
>> From: Eric W. Biederman <ebiederm@xmission.com> - unquoted
>> 
>> thread_run is used intead of kernel_thread, daemonize, and mucking
>> around blocking signals directly.
>
> Please don't do incomplete transitions like that.  We don't really
> want people to use kthread_run, but not the kthread stopping
> mechanisms, because people will simply forget about that bit and
> we'll never get rid of the enormous amount of, erm creativity, in
> handling kernel thread stopping.
>
> This is just the first patch in your series where the thread is mutable,
> but it equally applies to all following patches where this is the case
> aswell.

I don't really care about the creativity.  Although it would
be nice if it wasn't there.  I deliberately left it in so I would be
certain my patches were correct.

I care about killing the maintenance and forward development roadblocks
that are kernel_thread and daemonize.  And the user interface problem
that is handling signals in kernel threads.

Eric




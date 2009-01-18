Return-Path: <linux-kernel-owner+w=401wt.eu-S934889AbZARSWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934889AbZARSWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbZARSWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:22:12 -0500
Received: from brick.kernel.dk ([93.163.65.50]:22294 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbZARSWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:22:11 -0500
Date: Sun, 18 Jan 2009 19:20:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, Eric Dumazet <dada1@cosmosbay.com>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] splice: fix deadlock
Message-ID: <20090118182042.GD30821@kernel.dk>
References: <20090118153221.GA20980@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118153221.GA20980@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18 2009, Vegard Nossum wrote:
> From 8e1d58b03b47d937bc5e53d902bac6e690709034 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Sun, 18 Jan 2009 16:07:29 +0100
> Subject: [PATCH] splice: fix deadlock
> 
> splice from a file or socket needs to lock both the file/socket and the
> pipe inodes. pipe_wait() unlocks only the pipe lock, regardless of the
> order in which they were taken.
> 
> This patch adds an additional (optional) argument to pipe_wait(); if
> specified, pipe_wait() will unlock and reacquire both inode locks.
> 
> It fixes the lockup that occurs with the test-case below, but please
> review carefully. Consider this patch a proposal rather than a fix.

Thanks for the bug report and test case, it is indeed buggy! Good
spotting. I'll review your patch thoroughly and test it, and then
integrate your patch.

-- 
Jens Axboe


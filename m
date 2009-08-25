Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZHYOgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZHYOgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbZHYOgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:36:14 -0400
Received: from ozlabs.org ([203.10.76.45]:49815 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138AbZHYOgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:36:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH -stable] kthreads: fix kthread_create() vs kthread_stop() race
Date: Wed, 26 Aug 2009 00:06:06 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
       Robert Peterson <rpeterso@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
References: <20090824104529.GA6899@redhat.com>
In-Reply-To: <20090824104529.GA6899@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908260006.07310.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Aug 2009 08:15:29 pm Oleg Nesterov wrote:
> The bug should be "accidently" fixed by recent changes in 2.6.31,
> all kernels <= 2.6.30 need the fix. The problem was never noticed before,
> it was found because it causes mysterious failures with GFS mount/umount.
> 
> Credits to Robert Peterson. He blaimed kthread.c from the very beginning.
> But, despite my promise, I forgot to inspect the old implementation until
> he did a lot of testing and reminded me. This led to huge delay in fixing
> this bug.
> 
> kthread_stop() does put_task_struct(k) before it clears kthread_stop_info.k.
> This means another kthread_create() can re-use this task_struct, but the
> new kthread can still see kthread_should_stop() == T and exit even without
> calling threadfn().
> 
> Reported-by: Robert Peterson <rpeterso@redhat.com>
> Tested-by: Robert Peterson <rpeterso@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks, good catch!
Rusty.

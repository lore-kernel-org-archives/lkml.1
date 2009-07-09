Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbZGIV25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbZGIV25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbZGIV2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:28:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55729 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146AbZGIV2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:28:49 -0400
Date: Thu, 9 Jul 2009 23:25:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jmorris@namei.org,
       roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rework/fix is_single_threaded()
Message-ID: <20090709212555.GA9861@redhat.com>
References: <20090413214513.GA1119@redhat.com> <14878.1239876272@redhat.com> <20090416133658.GA6532@redhat.com> <20090416145444.GA12884@redhat.com> <20090618120716.fd1e4d92.akpm@linux-foundation.org> <20090618194238.GA17810@redhat.com> <20090622115148.5f1e5d1b.akpm@linux-foundation.org> <20090622171431.GA5010@redhat.com> <20090622140440.01d85542.akpm@linux-foundation.org> <28464.1247144463@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28464.1247144463@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > David, do you still dislike ->mmap_sem? I didn't see other objections,
> > and again, imho tasklist_lock is worse.
>
> My main objection to taking mmap_sem is that it restricts where the function
> can be used.  It can't, for example, be called by anyone holding a spinlock.

Yes, it is might_sleep().

> Furthermore, the more locks, the more chance of someone accidentally
> deadlocking something.

The current code is not lockless too, tasklist_lock is not free and
can lead too deadlocks as well.

Anyway. I agree it is better to avoid ->mmap_sem, I'll send the patch
in a minute. But I'd really like to do this in a separate patch, the
change is subtle and needs a changelog at least.

> But apart from that, go for it.

Great, thanks. Then I'll make the patch on top.

Oleg.


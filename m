Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYK1Egd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYK1Egd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 23:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYK1EgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 23:36:24 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:33015 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYK1EgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 23:36:23 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 27 Nov 2008 20:35:48 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Tejun Heo <htejun@gmail.com>
cc: Oleg Nesterov <oleg@redhat.com>, Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <mszeredi@suse.cz>, Brad Boyer <flar@allandria.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Roland McGrath <roland@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] poll: allow f_op->poll to sleep, take#6
In-Reply-To: <492E6A6E.9020000@gmail.com>
Message-ID: <alpine.DEB.1.10.0811272033440.3147@alien.or.mcafeemobile.com>
References: <20081125173032.GA21539@redhat.com> <492CD1AB.3000802@kernel.org> <492CD358.2020603@gmail.com> <alpine.DEB.1.10.0811252148540.32523@alien.or.mcafeemobile.com> <492CEF04.6070100@gmail.com> <alpine.DEB.1.10.0811252313420.32523@alien.or.mcafeemobile.com>
 <492E65F9.30208@gmail.com> <492E6A6E.9020000@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, Tejun Heo wrote:

> f_op->poll is the only vfs operation which is not allowed to sleep.  It's
> because poll and select implementation used task state to synchronize
> against wake ups, which doesn't have to be the case anymore as wait/wake
> interface can now use custom wake up functions.  The non-sleep restriction
> can be a bit tricky because ->poll is not called from an atomic context
> and the result of accidentally sleeping in ->poll only shows up as
> temporary busy looping when the timing is right or rather wrong.
> 
> This patch converts poll/select to use custom wake up function and use
> separate triggered variable to synchronize against wake up events.  The
> only added overhead is an extra function call during wake up and
> negligible.
> 
> This patch removes the one non-sleep exception from vfs locking rules and
> is beneficial to userland filesystem implementations like FUSE, 9p or
> peculiar fs like spufs as it's very difficult for those to implement
> non-sleeping poll method.

Looks OK to me, although it'd be better if some more folks eye it, in 
order to avoid painful mistakes.
Did you test it al all in a live system?


- Davide



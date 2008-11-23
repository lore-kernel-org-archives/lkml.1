Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbYKWDgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbYKWDgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 22:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbYKWDgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 22:36:11 -0500
Received: from [76.245.85.235] ([76.245.85.235]:59840 "EHLO cynthia.pants.nu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbYKWDgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 22:36:10 -0500
Date: Sat, 22 Nov 2008 19:34:57 -0800
From: Brad Boyer <flar@allandria.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Miklos Szeredi <miklos@szeredi.hu>,
       arjan@linux.intel.com, Linus Torvalds <torvalds@linux-foundation.org>,
       hch@infradead.org, Ingo Molnar <mingo@elte.hu>, rminnich@sandia.gov,
       ericvh@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: poll: allow f_op->poll to sleep, take #3
Message-ID: <20081123033457.GA1912@cynthia.pants.nu>
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu> <20081122123942.GF5707@parisc-linux.org> <4927FE87.6050005@gmail.com> <20081122105356.87856d04.akpm@linux-foundation.org> <4928B162.9030404@gmail.com> <alpine.DEB.1.10.0811221831550.19456@alien.or.mcafeemobile.com> <4928C891.80405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4928C891.80405@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 12:05:53PM +0900, Tejun Heo wrote:
> I thought try_to_wake_up() was made static to avoid abuse but then again
> creating dummy waitqueue is an obvious abuse of waitqueue.  What do
> other people think?  I'll be happy to use try_to_wake_up() directly.

Do you need all the extra arguments? The function wake_up_process()
is already a wrapper around try_to_wake_up() and is exported, but
it doesn't have any arguments other than the task_struct and uses
defaults for the other arguments. I'm not sure if anything in your
code would break by ignoring the other possible values instead of
passing them along from the arguments into the caller.

	Brad Boyer
	flar@allandria.com


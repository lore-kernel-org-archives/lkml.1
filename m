Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbYKWCfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbYKWCfv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 21:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbYKWCfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 21:35:42 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:44883 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbYKWCfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 21:35:41 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 22 Nov 2008 18:35:38 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Tejun Heo <htejun@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>,
       Miklos Szeredi <miklos@szeredi.hu>, arjan@linux.intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>, hch@infradead.org,
       Ingo Molnar <mingo@elte.hu>, rminnich@sandia.gov, ericvh@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: poll: allow f_op->poll to sleep, take #3
In-Reply-To: <4928B162.9030404@gmail.com>
Message-ID: <alpine.DEB.1.10.0811221831550.19456@alien.or.mcafeemobile.com>
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu> <20081122123942.GF5707@parisc-linux.org> <4927FE87.6050005@gmail.com> <20081122105356.87856d04.akpm@linux-foundation.org> <4928B162.9030404@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2008, Tejun Heo wrote:

> +static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
> +{
> +	struct poll_wqueues *pwq = wait->private;
> +	DECLARE_WAITQUEUE(dummy_wait, pwq->polling_task);
> +
> +	set_mb(pwq->triggered, 1);
> +
> +	/* perform the default wake up operation */
> +	return default_wake_function(&dummy_wait, mode, sync, key);
> +}

Wouldn't it be nicer to un-static try_to_wake_up() (or a wrapper) instead 
of setting up a fake wait queue just to use default_wake_function(), just 
to wake up a task?


- Davide


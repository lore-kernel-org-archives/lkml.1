Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbYKVMkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbYKVMkP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 07:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757450AbYKVMkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 07:40:00 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:50064 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195AbYKVMj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 07:39:59 -0500
Date: Sat, 22 Nov 2008 05:39:42 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, htejun@gmail.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, hch@infradead.org, mingo@elte.hu,
       rminnich@sandia.gov, ericvh@gmail.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH fwd] poll: allow f_op->poll to sleep
Message-ID: <20081122123942.GF5707@parisc-linux.org>
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 09:58:33AM +0100, Miklos Szeredi wrote:
> +int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
> +			  ktime_t *expires, unsigned long slack)

All callers of poll_schedule() and poll_schedule_timeout() pass
TASK_INTERRUPTIBLE.  We can elide the 'state' argument.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762850AbYCDBV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762850AbYCDBV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 20:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbYCDBVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 20:21:47 -0500
Received: from ozlabs.org ([203.10.76.45]:41137 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414AbYCDBVq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 20:21:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Module loading/unloading and "The Stop Machine"
Date: Tue, 4 Mar 2008 12:21:05 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Max Krasnyanskiy <maxk@qualcomm.com>, Tejun Heo <htejun@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kathy Staples <kathy.staples@au1.ibm.com>
References: <47ABC08C.8010101@qualcomm.com> <47BE29A0.6040409@qualcomm.com> <p73prup8awh.fsf@bingen.suse.de>
In-Reply-To: <p73prup8awh.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <200803041221.05434.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008 22:53:50 Andi Kleen wrote:
> Max Krasnyanskiy <maxk@qualcomm.com> writes:
> > static struct module *load_module(void __user *umod,
> >                                  unsigned long len,
> >                                  const char __user *uargs)
> > {
> >      ...
> >
> >      /* Now sew it into the lists so we can get lockdep and oops
> >         * info during argument parsing.  Noone should access us, since
> >         * strong_try_module_get() will fail. */
> >        stop_machine_run(__link_module, mod, NR_CPUS);
> >      ...
> > }
>
> Wow you found some really bad code. I bet it wouldn't be that
> difficult to fix the code to allow oops safe list insertion
> without using the big stop machine overkill hammer.

Yes it's overkill and it's becoming more noticable with larger machines.  
(Also, stop_machine is heavier than it should be, Kathy is working on fixing 
that though).

Most obvious is to add __ "lockless, but I'm in trouble anyway" accessors, but 
last I looked they'd have to be plumbed through a fair bit of code.

>From a quick reading of the code, a lockless add is possible, but it's fragile 
if one of the readers does something more complex in future.

Thanks,
Rusty.


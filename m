Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812Ab0ASHwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab0ASHwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600Ab0ASHwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:52:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab0ASHwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:52:32 -0500
Date: Tue, 19 Jan 2010 09:52:05 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org,
       andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Message-ID: <20100119075205.GI14345@redhat.com>
References: <20100118133755.GG30698@redhat.com>
 <84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
 <20100118141938.GI30698@redhat.com>
 <84144f021001180805q4d1203b8qab8ccb1de87b2866@mail.gmail.com>
 <20100118170816.GA22111@redhat.com>
 <84144f021001181009m52f7eaebp2bd746f92de08da9@mail.gmail.com>
 <20100118181942.GD22111@redhat.com>
 <20100118191031.0088f49a@lxorguk.ukuu.org.uk>
 <20100119071734.GG14345@redhat.com>
 <84144f021001182337o274c8ed3q8ce60581094bc2b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f021001182337o274c8ed3q8ce60581094bc2b9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 09:37:05AM +0200, Pekka Enberg wrote:
> Hi Gleb,
> 
> On Tue, Jan 19, 2010 at 9:17 AM, Gleb Natapov <gleb@redhat.com> wrote:
> > The thread took a direction of bashing mlockall(). This is especially
> > strange since proposed patch actually makes mlockall() more fine
> > grained and thus more useful.
> 
> No, the thread took a direction of you not being able to properly
> explain why we want MMAP_UNLOCKED in the kernel. It seems useless for
It is needed in the kernel because this is the only proper (aka thread
safe) way to mmap area bigger the main memory after mlockall(MCL_FUTURE).
Do you agree we that? Now you can ask why is this needed and this is
valid question.

> real-time and I've yet to figure out why you need _mlockall()_ if it's
> a performance thing.
I don't do real-time so will not argue how useful it is for that,
but it seems to me that people who argue that it is not useful for real
time don't do it either and the only person in this thread who does real
time uses mlockall(). Hmm strange.

In my case (virtualization) I want to test/profile guest under heavy swapping
of a guests memory, so I intentionally create memory shortage by creating
guest much large then host memory, but I want system to swap out only
guest's memory.

> 
> It would be probably useful if you could point us to the application
> source code that actually wants this feature.
> 
This is two line patch to qemu that calls mlockall(MCL_CURRENT|MCL_FUTURE)
at the beginning of the main() and changes guest memory allocation to
use MAP_UNLOCKED flag. All alternative solutions in this thread suggest
that I should rewrite qemu + all library it uses. You see why I can't
take them seriously?

--
			Gleb.

Return-Path: <linux-kernel-owner+w=401wt.eu-S932775AbZINSSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbZINSSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932765AbZINSSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:18:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932755AbZINSSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:18:41 -0400
Subject: Re: Warning from ring buffer code (Was: Re: linux-next: tip tree 
 build warning)
From: Steven Rostedt <srostedt@redhat.com>
To: Christopher Li <sparse@chrisli.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <70318cbf0909141009v46581785m4c70edf31fcb79fa@mail.gmail.com>
References: <20090804161640.70817ee6.sfr@canb.auug.org.au>
	 <1249403089.4634.139.camel@localhost.localdomain>
	 <20090912165300.9d257283.sfr@canb.auug.org.au>
	 <20090912073906.GA3972@elte.hu> <1252753957.12217.10.camel@ht.satnam>
	 <1252941416.2964.143.camel@localhost.localdomain>
	 <70318cbf0909141009v46581785m4c70edf31fcb79fa@mail.gmail.com>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 14 Sep 2009 14:17:18 -0400
Message-Id: <1252952238.2964.154.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 10:09 -0700, Christopher Li wrote:
> On Mon, Sep 14, 2009 at 8:16 AM, Steven Rostedt <srostedt@redhat.com> wrote:
> > static void func(int size_me) {
> >        char array[size_me];
> >
> >        memcpy(array, "hello", size);
> > };
> >
> > and sparse failed on it as well. Note, you need to have something call
> > func, or sparse will ignore it.
> 
> Gcc allows variable size. Sparse expects the size of an array is constant.
> For the kernel using variable array size is consider bad. Because the kernel
> has very limited stack size. (8K if I remember correctly). Using dynamic array
> is very easy to overflow the stack without realizing it.
> 
> It deserves a warning. I agree the warning message can use a better description
> though.

Good point!

I've added Frederic to the Cc list, since he wrote the code.

Frederic, how big can one of those events get. The ring buffer (and
TRACE_EVENT) allow up to almost a page size, which is very hefty for the
stack. This code needs to either be rewritten or we need to set a limit
to the size of a profile entry.

We could add:

	if (__entry_size > 256)
		return;

Thoughts?

-- Steve




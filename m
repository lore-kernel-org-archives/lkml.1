Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab0BBIRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:17:07 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:16700 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751031Ab0BBIRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:17:01 -0500
Date: Tue, 2 Feb 2010 09:16:57 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andrew Morton <akpm@linux-foundation.org>, dedekind1@gmail.com,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Provide ways of crashing the kernel through debugfs
Message-ID: <20100202091657.124e6b0c@marrow.netinsight.se>
In-Reply-To: <m1eil4i85t.fsf@fess.ebiederm.org>
References: <20100126105640.6bf9488c@marrow.netinsight.se>
	<2375c9f91001260208t31379702tb49cb57d12d5890b@mail.gmail.com>
	<20100126111853.10890fc6@marrow.netinsight.se>
	<2375c9f91001261853t1158a66aw86546a61e613338f@mail.gmail.com>
	<1264689482.1973.132.camel@localhost>
	<20100129071324.2521705c@marrow.netinsight.se>
	<20100129023327.021cb23d.akpm@linux-foundation.org>
	<m1eil4i85t.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Feb 2010 20:16:46 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:

> > Yes, it's the sort of thing which lots of people have written
> > throw-away ad-hoc versions of.  It probably makes sense to do it once,
> > do it right to save people from having to rererereinvent that wheel.
> >
> > What do others think?
> 
> I think it makes sense, and in fact we have already merged one attempt
> at doing this generically.  drivers/misc/lkdtm.c

So this functionality was already there - it would appear that I didn't do my
research good enough then (I did actually look for this kind of thing).
If something, I guess it shows that the kernel source is getting big!

To add to the irony, I work for a company that works on "DTM", although
it's not related to this functionality :-)

> I think Simon's patch adds some additional interesting failure modes.
> write_after_free, corrupt_stack_write, unaligned_load_store.
> 
> Simon is there any chance you can change your patch to an enhancement of lkdtm?
> 
> lkdtm actually digs into the interesting failure points with a jprobe
> to trigger the harder to reproduce scenarios.  Like stack overflow in
> an interrupt handler.

Yes, this would be a better way of supporting the crash functionality.
I'll take a look on integrating the extra tests into lkdtm.

I think it would also be good to provide a debugfs interface to lkdtm
similar to what provoke-crash has. Right now you have to set it up via
module parameters, and for some tests (write_after_free) I think that's
a limitation since it often doesn't crash immediately.

// Simon

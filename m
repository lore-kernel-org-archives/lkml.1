Return-Path: <linux-kernel-owner+w=401wt.eu-S964812AbXGWVG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812AbXGWVG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934057AbXGWVGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:06:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762992AbXGWVGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:06:11 -0400
Date: Mon, 23 Jul 2007 14:05:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org,
       "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Tim Bird" <tim.bird@am.sony.com>,
       bryan.wu@analog.com
Subject: Re: early_printk accessing __log_buf
Message-Id: <20070723140541.8fac78c5.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0707231354k7732f647qc0b55f105440ca1c@mail.gmail.com>
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
	<200707182358.24984.rgetz@blackfin.uclinux.org>
	<8bd0f97a0707221650r3bab822fq2d457d19eba1c8eb@mail.gmail.com>
	<200707231419.13182.rgetz@blackfin.uclinux.org>
	<20070723131553.2943861f.akpm@linux-foundation.org>
	<8bd0f97a0707231354k7732f647qc0b55f105440ca1c@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 16:54:36 -0400
"Mike Frysinger" <vapier.adi@gmail.com> wrote:

> On 7/23/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Mon, 23 Jul 2007 14:19:12 -0400
> > Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> >
> > > On Sun 22 Jul 2007 19:50, Mike Frysinger pondered:
> > > >
> > > > i think the attached two functions account for what Robin and Andrew
> > > > were thinking ...
> > >
> > > A note about why/when grab_lock would be set to zero (pre-kernel init, or
> > > OOPs) might be nice.
> >
> > Definitely.
> >
> > The pre-kernel init shouldn't be an issue: logbuf_lock is initialised at
> > compile time.
> >
> > At oops time we could possibly use oops_in_progress to work out whether to
> > avoid taking the lock.  That's not terribly nice, but nor is it nice for
> > callers to know about printk internals.
> 
> maybe, but for early debug users (the reason we wanted this
> originally), it wouldnt be an oops in progress ... but i guess we can
> just as easily set oops_in_progress to 1 in our code before calling
> this function to keep from having to worry over locks from being
> doubly grabbed.

I don't immediately see how logbuf_lock could be doubly grabbed.  Only if
you're calling this from hard irq context?



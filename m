Return-Path: <linux-kernel-owner+w=401wt.eu-S1763739AbXHCUxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763739AbXHCUxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 16:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbXHCUw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 16:52:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40513 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbXHCUw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 16:52:58 -0400
Date: Fri, 3 Aug 2007 13:52:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp =?ISO-8859-1?Q?T=F6lke?= <philipptoelke@web.de>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       Christophe Saout <christophe@saout.de>,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: PROBLEM: Oops when using dm-crypt with dpt_i2o
Message-Id: <20070803135239.42ae6208.akpm@linux-foundation.org>
In-Reply-To: <46B39416.7040809@web.de>
References: <46B0D4B4.2040809@web.de>
	<20070803110430.88a4b543.akpm@linux-foundation.org>
	<46B39416.7040809@web.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Aug 2007 22:46:14 +0200
Philipp T__lke <philipptoelke@web.de> wrote:

> Hi Andrew, hi everybody!
> 
> Thanks for the reply!
> 
> Andrew Morton wrote:
> >> The oopses:
> >>
> >> #v+
> >> BUG: unable to handle kernel paging request at virtual address 14001000
> >> [...]
> > 
> > So it looks like q->request_fn points at 0x14001000, which is in outer
> > space.
> > 
> > I wonder how that could happen, in the middle of heavy IO operations. 
> > Possibly a memory scribble.  I'd suggest you enable CONFIG_SLAB,
> > CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC.
> 
> That doesn't change anything, apart from adding a line "DEBUG_PAGEALLOC"
> to the oopses.

drat.

> Do I have to enable the debugging manually? After a quick
> grep over the sources and a google-session I think not but I'm no
> kernel-hacker.

No, just enable it.

> > You could also try switching
> > from CONFIG_SLAB to CONFIG_SLUB, then enable CONFIG_SLUB_DEBUG.
> 
> Unfortunately the only change seems to be, that the Keyboard-Leds don't
> flash after the crash. Everything else is the same.

drat.

> Could a hardware-error cause this?

It sounds unlikely.  One wouldn't expect it to crash in the same way each
time.



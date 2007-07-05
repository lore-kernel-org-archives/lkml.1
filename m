Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbXGEQnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbXGEQnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758380AbXGEQnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:43:07 -0400
Received: from canuck.infradead.org ([209.217.80.40]:36287 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182AbXGEQnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:43:04 -0400
Subject: Re: [1/2] 2.6.22-rc7: known regressions
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, marcel@holtmann.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       David Chinner <dgc@sgi.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <alpine.LFD.0.98.0707050921000.9434@woody.linux-foundation.org>
References: <468A7D14.1050505@googlemail.com>
	 <1183599771.2740.19.camel@shinybook.infradead.org>
	 <alpine.LFD.0.98.0707050921000.9434@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 12:43:22 -0400
Message-Id: <1183653802.2797.63.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 09:28 -0700, Linus Torvalds wrote:
> 
> On Wed, 4 Jul 2007, David Woodhouse wrote:
> > 
> > Oh, and here's another one for you. My Bluetooth mouse just stopped
> > working and hidd is deadlocked...
> 
> Looks like it is stuck on hidp_session_sem.
> 
> Nothing after 2.6.21 seems to have even touched that semaphore usage, and 
> in fact there's not a whole lot of changes to the hidp code at all (and 
> none of them look even remotely interesting). 
> 
> So I suspect it's something lower down in the bluetooth stack, or it's a 
> long-standing problem that you are somehow able to trigger more easily 
> now. Is it consistent?

It happened twice before I gave up on my 2.6.22-rc7 test kernel and went
back to something earlier. I suppose I should double-check that it
wasn't my slab changes, but I really don't think that's it.

> Can you showo the traces for the _other_ processes that are in bluetooth 
> functions? Because there should be other processes there, holding that 
> hidp_session_sem rwsem.

There was nothing, apart from a later 'hidd -l' which got stuck on the
same semaphore. I have an hcidump of it happening, at
http://david.woodhou.se/hidd-lockup-dump.txt -- it doesn't seem
particularly enlightening though. There's just a disconnection and
reconnect, as happens quite frequently with this mouse, and then we're
deadlocked. I'll build with hidp debugging.

-- 
dwmw2


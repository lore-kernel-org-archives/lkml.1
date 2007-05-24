Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbXEXTvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbXEXTvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbXEXTvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:51:42 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815AbXEXTvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:51:41 -0400
Date: Thu, 24 May 2007 12:50:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
In-Reply-To: <20070524193740.GA6787@elte.hu>
Message-ID: <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org>
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com>
 <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org>
 <20070524193740.GA6787@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 May 2007, Ingo Molnar wrote:
> 
> i very much agree that this kmalloc_index() one shouldnt be called a 
> "BUG: ", but if you look at the majority of WARN_ON() instances they are 
> checks for clear, serious kernel bugs.

I _still_ disagree.

There's a huge difference between "You killed my father, prepare to die", 
and "Btw, I didn't like that, but I'll just continue".

And that's the difference between BUG_ON() and WARN_ON().

And dammit, the kernel message should make that CLEAR. It's totally 
idiotic to call both "BUG". One is a clear BUG, the other is a "uhhuh, 
something unexpected happened, but I know how to continue".

So stop this idiotic "we should call them both the same". If they actually 
were the same, they'd both be called BUG_ON().

		Linus

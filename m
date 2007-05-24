Return-Path: <linux-kernel-owner+w=401wt.eu-S1751231AbXEXPbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbXEXPbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 11:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbXEXPaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 11:30:55 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829AbXEXPay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 11:30:54 -0400
Date: Thu, 24 May 2007 08:28:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Romano Giannetti <romanol@upcomillas.es>
cc: Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: Long delay in resume from RAM (Was Re: [patch 00/69]
 -stablereview)
In-Reply-To: <1180019201.15600.57.camel@localhost>
Message-ID: <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>  <4652070D.3090509@redhat.com>
  <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org> 
 <20070521212522.GL3429@sequoia.sous-sol.org>  <1179870110.16656.2.camel@localhost>
  <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> 
 <1180008394.15600.26.camel@localhost>
 <1180019201.15600.57.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 May 2007, Romano Giannetti wrote:
> 
> More data. I compiled 2.6.21.2 + the patch "Fix ACPI suspend / device
> suspend ordering problem  (52ade9b3b97fd3bea42842a056fe0786c28d0555)
> 
> and I discovered that if I do not put the 3Com 3CXEM556B card into the
> pcmcia slot, the suspend/resume (and the snapshot/restore) works ok,
> without delay at all.

Ok. That was probably true even before you added the suspend ordering 
patch.

> It continues to work even with a cardbus wifi in the slot, so my 
> conclusions are that the probable culprit is restricted to:
> 
>       *  a race when loading the .cis file from userspace
>       * the serial_cs or 3c589_cs driver (only when the device is in;
>         they are loaded still now and all is working ok)
> 
> ...what now?

Can you compile those two modules with PCMCIA_DEBUG=4?

Something like

	make EXTRA_CFLAGS=-DPCMCIA_DEBUG=4

should do it. You might also enable CONFIG_PCMCIA_DEBUG while you're at 
it. And then the extra debugging output hopefully will narrow down where 
things go south.

		Linus

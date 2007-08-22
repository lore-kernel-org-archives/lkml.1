Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbXHVF6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbXHVF6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 01:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbXHVF6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 01:58:01 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43594 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbXHVF57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 01:57:59 -0400
X-Originating-Ip: 72.143.224.166
Date: Wed, 22 Aug 2007 01:48:25 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Adrian Bunk <bunk@kernel.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: drop support for gcc < 4.0
In-Reply-To: <20070821182932.GD30705@stusta.de>
Message-ID: <Pine.LNX.4.64.0708220142001.3582@localhost.localdomain>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com>
 <20070821173550.GC30705@stusta.de> <20070821175453.GB19819@flint.arm.linux.org.uk>
 <20070821182932.GD30705@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Adrian Bunk wrote:

> It is an option to say "gcc >= 4.0 on i386 and >= 3.4 on all other
> architectures is required".

  if you're going to do something like that, you might as well take
the extra step and start keeping track of which versions of gcc work
with which architectures, along the lines of what dan kegel did with
the results matrix of crosstool:

http://www.kegel.com/crosstool/crosstool-0.43/buildlogs/

  i'm being only moderately facetious, of course but, on the other
hand, if there's all this anecdotal information regarding which
combinations work and which don't, maybe it's worth codifying that
into a compilation check somewhere in the build process.

  after all, at the moment in init/main.c, any gcc < 3.2 is rejected
outright, while gcc-4.1.0 generates a warning.  that's incredibly ad
hoc and certainly incomplete.  might as well just write a script for
the scripts/ directory which accepts an architecture and a version of
gcc and tells you what the current situation is and what you can do
about it.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================

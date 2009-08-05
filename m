Return-Path: <linux-kernel-owner+w=401wt.eu-S934701AbZHEQkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934701AbZHEQkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934684AbZHEQkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:40:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934490AbZHEQkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:40:17 -0400
Date: Wed, 5 Aug 2009 09:38:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Manuel Lauss <mano@roarinelk.homelinux.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
In-Reply-To: <alpine.LFD.2.01.0908050902300.3390@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908050931390.3390@localhost.localdomain>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain> <20090803165909.GA12824@roarinelk.homelinux.net> <alpine.LFD.2.01.0908041555120.3270@localhost.localdomain> <20090805155102.GA31646@roarinelk.homelinux.net>
 <alpine.LFD.2.01.0908050902300.3390@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 Aug 2009, Linus Torvalds wrote:
> 
> So I think I understand the behavior on your box, and the warning was 
> actually correct and useful - our PCI layer is being stupid. We should 
> mark ROM resources as being prefetchable.
> 
> Hmm.. We do seem to _try_ do exactly that in pci_read_bases(). I wonder 
> what I'm missing, and where that bit is then cleared. Or whether we're 
> doing that ROM BAR probe somewhere else too..

Manuel, could you compile your kernel with CONFIG_PCI_DEBUG enabled, and
then boot it with "pci=earlydump", and send me the dmesg of a kernel boot? 

You may need to make sure that CONFIG_LOG_BUF_SHIFT is big enough to get 
it all, and perhaps use "dmesg -s 1000000" (some versions of dmesg will 
truncate the result to 64kB or something by default, and depending on just 
how verbose your boot ends up being, you migth lose things).

			Linus

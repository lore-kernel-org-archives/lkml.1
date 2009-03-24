Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbZCXKK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbZCXKK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbZCXKKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:10:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54767 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755518AbZCXKKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:10:15 -0400
Date: Tue, 24 Mar 2009 10:10:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
In-Reply-To: <20090324093245.GA22483@elte.hu>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	<20090324093245.GA22483@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I have not had this problem since I applied Arjan's (for some reason
> > repeatedly rejected) patch to change the ioprio of the various writeback
> > daemons. Under some loads changing to the noop I/O scheduler also seems
> > to help (as do most of the non default ones)
> 
> (link would be useful)


"Give kjournald a IOPRIO_CLASS_RT io priority"

October 2007 (yes its that old)

And do the same as per discussion to the writeback tasks.


Which isn't to say there are not also vm problems - look at the I/O
patterns with any kernel after about 2.6.18/19 and there seems to be a
serious problem with writeback from the mm and fs writes falling over
each other and turning the smooth writeout into thrashing back and forth
as both try to write out different bits of the same stuff.

<Rant>
Really someone needs to sit down and actually build a proper model of the
VM behaviour in a tool like netlogo rather than continually keep adding
ever more complex and thus unpredictable hacks to it. That way we might
better understand what is occurring and why.
</Rant>

Alan


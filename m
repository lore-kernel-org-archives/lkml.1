Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZDOUEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZDOUEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbZDOUEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:04:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:34587 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZDOUEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:04:31 -0400
Date: Wed, 15 Apr 2009 13:06:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: VomLehn <dvomlehn@cisco.com>, Mark Lord <lkml@rtr.ca>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090415130614.55b1cb28@infradead.org>
In-Reply-To: <20090415183252.32ba7a4f@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.44L0.0904151146210.3072-100000@iolanthe.rowland.org>
	<49E60219.9080103@rtr.ca>
	<20090415170617.GA14485@cuplxvomd02.corp.sa.net>
	<20090415183252.32ba7a4f@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 18:32:52 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Saying that we were "lucky" that things worked before is no help and
> > you should be aware that it ticks people off. 
> 
> No doubt those who wrote the code and never expected that timing to
> reliably work will take affront at those who blame them for it not
> working. 

It's even more than that; it's OTHER code that gets faster that
can/will break this.

> Those who expected it to work and never knew it was not
> guaranteed will feel likewise in reverse.

For storage at least the solution already existed (root_wait);
it just hasn't been used consistently.

For other pieces it's hard. Non-enumeratable busses just suck;
at some point all you can do is just wait (which we have already 
available today for anyone to do). I realize people don't want to
just wait 4 seconds (the people who first objected to boot time
improvements then suddenly care about boot time ;-)...

For root fs there's some options, and I have patches to basically retry
on fail. (The patches have a bug and I don't have time to solve it this
week, so I'm not submitting them)
For other devices it is hard. Realistically we need hotplug to work
well enough so that when a device shows up, we can just hook it up when
it does.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

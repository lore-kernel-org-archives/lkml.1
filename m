Return-Path: <linux-kernel-owner+w=401wt.eu-S1161042AbXAZP3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161042AbXAZP3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 10:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161044AbXAZP3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 10:29:38 -0500
Received: from rtr.ca ([64.26.128.89]:2721 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161042AbXAZP3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 10:29:37 -0500
Message-ID: <45BA1E5E.6050405@rtr.ca>
Date: Fri, 26 Jan 2007 10:29:34 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
References: <20070125150905.652f9ce2@localhost.localdomain>  <1169741658.3593.98.camel@shinybook.infradead.org>  <20070125172739.0c990a9a@localhost.localdomain>  <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>  <1169770985.3593.146.camel@shinybook.infradead.org>  <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org> <1169778239.3593.195.camel@shinybook.infradead.org> <Pine.LNX.4.64.0701251832040.25027@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0701251832040.25027@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> (Yeah, mmap() has taught some people about MAP_FAIL, but that's pretty 
> unusual too.

It's so unusual, that I regularly find buggy code checking for NULL
instead of MAP_FAILED.  Just about every program I look at has it wrong
in at least one place.

Ditto for the result value from wait() -- lots of code fails to use
the fancy macros required for correct interpretation of it.

> The quality of our drivers is low;

I think that's a bit harsh.  But yes, compared to core parts
of the kernel perhaps (eg. page dirty mappings: remember the recent bugfix?).

The real deal is that using zero/NULL makes it *easier* to get the code right.
And we certainly have tons more people working on drivers than anything else,
so making it *easier* for those coders to reduce the bug count is a Good Thing(tm).

Cheers

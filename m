Return-Path: <linux-kernel-owner+w=401wt.eu-S1030749AbXAZFKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030749AbXAZFKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 00:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030750AbXAZFKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 00:10:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44123 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030749AbXAZFKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 00:10:34 -0500
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
	controllers
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701252029570.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain>
	 <1169741658.3593.98.camel@shinybook.infradead.org>
	 <20070125172739.0c990a9a@localhost.localdomain>
	 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>
	 <1169770985.3593.146.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org>
	 <1169778239.3593.195.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0701251832040.25027@woody.linux-foundation.org>
	 <1169782107.3593.219.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0701251932250.25027@woody.linux-foundation.org>
	 <1169785150.3593.231.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0701252029570.25027@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 26 Jan 2007 13:09:40 +0800
Message-Id: <1169788181.3593.250.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-01-25 at 20:48 -0800, Linus Torvalds wrote:
> Irq0 may _exist_. IO Port 0 may _exist_. Virtual address 0 may
> _exist_. 
> 
> Got it?
> 
> But they ARE NOT VALID THINGS FOR DRIVERS TO WORRY ABOUT.

I do understand what you're saying; there's no need to shout. I think
it's very misguided and leads to both internal inconsistency (as
demonstrated by the setup_irq() patch) and external inconsistency with
stuff like hardware documentation. But I _do_ understand what you're
saying.

> When a *DRIVER* sees a [zero], it's always a sign of "not here".

Except when it isn't. Like when it's a DMA address. Or a file
descriptor. Or a CPU number. Or one of numerous other things.

But still, I do understand what you're saying although I disagree with
your intention and your statement above is plain wrong (well, at least
my misquote of it is wrong -- you actually said 'NULL' which is fair
enough, but in the middle of a rant about _zero_ so I edited the quote
to say zero because that's what we're actually talking about).

> But they ARE NOT VALID THINGS FOR DRIVERS TO WORRY ABOUT.
 ...
> NO NORMAL USER SHOULD EVER SEE [zero] AS A REAL IO PORT. 

Yes, that much I understand. We disagree, but I understand you. My last
response was not intending to pursue that part of the discussion.

My question was about _how_ you think this should be achieved in this
particular case. You didn't like the suggestion that we should put your
new special-case hack into the resource code... where/how _do_ you
suggest that it's done, so that we can protect those poor driver authors
from the number zero?

-- 
dwmw2


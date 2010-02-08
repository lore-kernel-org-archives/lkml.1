Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab0BHKwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:52:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53308 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0BHKwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:52:16 -0500
Date: Mon, 8 Feb 2010 11:52:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100208105209.GA31671@atrey.karlin.mff.cuni.cz>
References: <20100208065519.GE1290@ucw.cz> <1265622676.4020.19.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265622676.4020.19.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> On Mon, 2010-02-08 at 06:55 +0000, Pavel Machek wrote:
> > > > So, let's put this in the HCD drivers and be done with it.
> > >
> > > The patch below is what fixes the I-D cache incoherency issues on ARM. I
> > > don't particularly like the solution but it seems to be the only one
> > > available.
> > 
> > Really? It looks like arm should just flush the caches when mapping
> > executable page to the userspace.... you can't expect all the drivers
> > to be modified like that...
> 
> We could of course flush the caches every time we get a page fault but
> that's far from optimal, especially since DMA-capable drivers to do
> not

Maybe far for optimal, but it is something that should be done,
_first_. Correctness is more important than performance, and you can't
expect all drivers to behave like you want them.

Then you can add optimalizations not to do the flushes on drivers you
audited and where you care...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

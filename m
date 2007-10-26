Return-Path: <linux-kernel-owner+w=401wt.eu-S1764041AbXJZQCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764041AbXJZQCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbXJZQCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:02:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35452 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763958AbXJZQCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:02:34 -0400
Date: Fri, 26 Oct 2007 17:02:06 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCMCIA: prevent auto insert during resume.
Message-ID: <20071026160206.GC4321@flint.arm.linux.org.uk>
Mail-Followup-To: Rodolfo Giometti <giometti@enneenne.com>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20071026105125.GA28769@enneenne.com> <20071026151141.GA4321@flint.arm.linux.org.uk> <20071026154705.GY19019@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026154705.GY19019@enneenne.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 05:47:06PM +0200, Rodolfo Giometti wrote:
> On Fri, Oct 26, 2007 at 04:11:41PM +0100, Russell King wrote:
> > On Fri, Oct 26, 2007 at 12:51:25PM +0200, Rodolfo Giometti wrote:
> > > If a socket has been ejected before sleeping, at resume time it
> > > shouldn't be awaked.
> > 
> > Conversely, if a card has been inserted into an empty slot prior to
> > resuming, it should be detected.  Removing this check prevents that
> > happening, which sucks for at least embedded devices.
> 
> You can use "pccardctl insert" to do it. :)

Not on a battery powered device with a graphical interface.

> On battery powered device I should prevent power lost, so if I power
> down a device I'd like it should remain off even after resume.

In which case you need to remember why it was powered down and act
accordingly.

> Why the system should power it on automagically? Just for detection?

When you bring the battery device out of resume, and you've inserted a
card, you want it to be detected.  Your change means you have to wait
until the system has finished resuming before you plug the card in,
which practically is a pain in the butt and actually leads to user
errors.  IOW:

"I plugged my wireless card in after I pressed the power button, why
wasn't it detected?"

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

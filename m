Return-Path: <linux-kernel-owner+w=401wt.eu-S1765013AbXJZQlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765013AbXJZQlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763778AbXJZQhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:37:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34201 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764331AbXJZQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:37:16 -0400
Date: Fri, 26 Oct 2007 17:36:51 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCMCIA: prevent auto insert during resume.
Message-ID: <20071026163651.GD4321@flint.arm.linux.org.uk>
Mail-Followup-To: Rodolfo Giometti <giometti@enneenne.com>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20071026105125.GA28769@enneenne.com> <20071026151141.GA4321@flint.arm.linux.org.uk> <20071026154705.GY19019@enneenne.com> <20071026160206.GC4321@flint.arm.linux.org.uk> <20071026162705.GZ19019@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026162705.GZ19019@enneenne.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 06:27:06PM +0200, Rodolfo Giometti wrote:
> On Fri, Oct 26, 2007 at 05:02:06PM +0100, Russell King wrote:
> > When you bring the battery device out of resume, and you've inserted a
> > card, you want it to be detected.  Your change means you have to wait
> > until the system has finished resuming before you plug the card in,
> > which practically is a pain in the butt and actually leads to user
> > errors.  IOW:
> > 
> > "I plugged my wireless card in after I pressed the power button, why
> > wasn't it detected?"
> 
> My patch doesn't affect the power on sequence, just the resume
> one.

On a lot of devices, the "power button" is the resume button.  When you
"turn it off" it suspends, and when you "turn it on" it resumes.

> Also if you didn't eject the socket, at resume the device will be
> powered up again, my patch just prevents that a pre-powered off device
> to be turned on at resume time.
> 
> However you should consider that some embedded systems have fixed
> PCMCIA devices that can't be removed so there are no reasons to detect
> them after resume, nobody can change them. :)
> 
> Also battery powered devices can go very frequently to sleep and the
> current behavior force the user to switch off the unused device each
> time the system resumes from sleep.

I realise that.  I do work on embedded devices, and this behaviour is
explicitly there to support embedded devices.

I've suggested a workable solution to you which allows both of us to
have the behaviour we both desire from the system.  That sounds like
a negotiated solution to me...

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

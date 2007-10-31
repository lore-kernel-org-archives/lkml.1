Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbXJaV20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbXJaV20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbXJaV2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:28:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:53759 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbXJaV2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:28:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iL7OzDTky8CUuJwl54xu5ktxn12ydQsY3QQImsD53Avd60lJWg+ZfxQoJc8fRpzlHgX82NBSZTHpgXmEen83lm0vJgnGmXZvz9kW/bj5FYjDOSiJcOh4IsMme9BUf4does30z8jjisOmDaICLUFrajCuJEQ8NAKjXQyYRbFipI0=
Message-ID: <2c0942db0710311428i7675a4b6saf3f79dc60a4f0be@mail.gmail.com>
Date: Wed, 31 Oct 2007 14:28:11 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "John Sigler" <linux.kernel@free.fr>
Subject: Re: How to debug complete kernel lock-ups
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       greg@kroah.com, grundler@parisc-linux.org
In-Reply-To: <47284A21.1070901@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471E1D3A.8000705@free.fr> <471F0DB4.1080709@free.fr>
	 <47284A21.1070901@free.fr>
X-Google-Sender-Auth: 1f663a6650ade9a7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/07, John Sigler <linux.kernel@free.fr> wrote:
> "It seems that the PCI clock on this system has a rather large over- and
> undershoot and we suspect that the undershoot (of ~1V) is causing a drop
> in the core voltage of the on-board FPGA which results in lockup of the
> firmware. Both the under- and overshoot are well outside the allowed
> ranges (high=VCC+0.5V and low=-0.5V) of the PCI specification and a
> premature conclusion might be that the system does not comply to the PCI
> spec and that this is the cause of the lockup on this PC."
>
> This is waaay out of my league, as my area is software.
>
> Is it typical for voltage issues to hang hardware?

Yes, if the voltage is applied (or lacking) at the right place.

> Is it typical for one PCI board locking up to nail the entire system?

This doesn't appear to be a case of the *board* crashing, but rather
the board taking the pci bus and related hardware on-motherboard down
with it. Once that's down, anything that you need that goes through
the bus (on a PC, that's pretty much everything), is inaccessible.

> I don't understand why the lockup would only happen when I write to the
> 4 ports within a small time frame, and not when I only write to 2 ports
> (either one port on each card, or 2 ports on the same card). I suspected
> some kind of concurrency issue...

No, given the hardware guy's description, it's a power issue. Perhaps
when you're writing to a port, you're using more power on the card?
Four ports = 4 * the power draw. When the current load increases,
voltage drops, and if you underpower a chip, it's going to lose its
little head.

> I suppose the next logical step is to get the board's engineers
> and the system's engineers duke it out? :-)

Yes, all signs point to it being a pure hardware issue. You may be
able to work around it in software by initializing a 'counting
semaphore' to 2 to manage the maximum concurrency, so that you'll
never write more than 2 ports at a time until the hardware guys figure
it out.

Ray

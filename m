Return-Path: <linux-kernel-owner+w=401wt.eu-S1761082AbXGPFGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761082AbXGPFGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 01:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXGPFGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 01:06:31 -0400
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:28291 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751351AbXGPFGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 01:06:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=L5ggHGtheU6rraQmXuS04vNK3bl6Jwhe8Itbg9YlaYnbFZ8B4YCBr3DYUngi7gh5BFlYfxzbB5gOF8CeWAB6aRR41X6okkbelzfLp4raJSTvagTUKSoQmeqk7FPyB+aLtOtRZO9zeLRgFxRA29ZYr+f8/RKTWHKOhQHjuk482Kc=  ;
X-YMail-OSG: 2PRy0PEVM1naNSZ.YIiHj6nd04JuMhkMYVOtS7RHN4yZVKcl
From: David Brownell <david-b@pacbell.net>
To: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Timo Lindemann" <tlindemann@arcor.de>
Subject: Re: PROBLEM: kernel hang in ohci init
Date: Sun, 15 Jul 2007 22:06:26 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <4695EC25.6050003@arcor.de> <4699F9CB.5010407@arcor.de> <a781481a0707150418o35e4d60fs59cba3f835ebef67@mail.gmail.com>
In-Reply-To: <a781481a0707150418o35e4d60fs59cba3f835ebef67@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707152206.26995.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 July 2007, Satyam Sharma wrote:
> On 7/15/07, Timo Lindemann <tlindemann@arcor.de> wrote:

> > It is just odd that up to (not including) the 2.6.21-series every kernel
> > boots, and after that, they just freeze.

On *your* system, note -- all my OHCI+PCI systems that have
been upgraded to 2.6.22 are behaving just peachy-keen-swell.
And that's true for most people, it seems...


> > I am kinda stumped here.

It gets that way sometimes.  Thing is, pci-quirks.c runs early
enough in the boot process -- before the OHCI driver can even
run!! -- that you can probably rule out the USB stack as being
the cause of this regression.  Disable the USB host controllers
in your config, and see what happens...


> Hey, just try git-bisect already :-)
> 
> In fact, you can first try by just reverting / un-applying that patch that
> you initially had a suspicion on. 

Extremely unlikely to matter, since it wouldn't have been able
to run that early.  Plus, you were seeing problems even before
that recent change to pci-quirks ... 


> Or, because you've already spent 
> some time tracking down the issue, you could simply go through the
> git history of that file / subsystem in question 

Where the subsystem in question is early PCI/ACPI initialization,
before the drivers start binding to PCI devices... it's always
annoying when changes in that area cause USB to break, since the
only involvement of USB is to display a "rude failure" symptom.
It took a long time to get the IRQ setup glitches fixed!

One thing you might do is enable all the ACPI debug messaging and
disable the usb/host/pci-quirks.c stuff (just comment it all out),
assuming you can boot without USB keyboard/mouse.  Then compare
the relevant diagnostics between "good" and "bad" kernels.  It's
likely something interesting will appear.

- Dave



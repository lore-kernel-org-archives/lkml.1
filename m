Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZAJMcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZAJMcv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 07:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbZAJMcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 07:32:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60926 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbZAJMcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 07:32:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH] ricoh_mmc: Use suspend/resume_noirq (v2) (resend)
Date: Sat, 10 Jan 2009 13:32:03 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: linux kernel <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       sfr@canb.auug.org.au, Pierre Ossman <drzeus@drzeus.cx>
References: <40499.98.210.152.237.1231345314.squirrel@overt.org> <200901082314.52840.rjw@sisk.pl> <94b68f283abf372eab895fd76b0feb34@localhost>
In-Reply-To: <94b68f283abf372eab895fd76b0feb34@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901101332.03851.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 January 2009, Philip Langdale wrote:
> 
> On Thu, 8 Jan 2009 23:14:52 +0100, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > On Wednesday 07 January 2009, philipl@overt.org wrote:
[...]
> > dependencies between the devices are, so can you please explain that
> > to me?
> 
> I hope my write up answers this question.

I think they are, though I have to read them more thoroughly yet.

> > That said, if you want to suspend-resume ricoh_mmc with interrupts
> > disabled,
> > please use the legacy PCI .suspend_late() and .resume_early() callbacks
> for
> > that, since in the new framework the core will carry out some standard PM
> > operations in addition to your .suspend_noirq() and .resume_noirq().  It
> > may
> > not be what you want in this case, though.
> 
> I'd need to know what those other operations are. I originally wrote this
> patch with suspend_late and resume_early but the first pm_ops patch I saw
> removed those. Are you now saying that both suspend_late/resume_early and
> noirq callbacks are supported now.

Yes, they are.  You implement either the "old" ones (->suspen(), ->resume(),
->suspend_late(), ->resume_early() in struct pci_driver) and even if only one of
them is defined, the "legacy" handling will be used for the other operations
too, so the existing drivers' code is not affected, or the "new" ones (the pm
object).

> It's all a bit confusing :-)

Yes, it is, unfortunately.  There are a couple of reasons, one of them being
that the code has only been finished recently and another that the whole
concept changed slightly just before 2.6.28, when we discovered a mode of
failure that had not been known before and it had to be taken into account.

I'm now going to finally write some documentation. :-)

Thanks,
Rafael

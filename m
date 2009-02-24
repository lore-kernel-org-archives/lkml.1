Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbZBXXHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbZBXXHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 18:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbZBXXHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 18:07:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50665 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbZBXXHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 18:07:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Wed, 25 Feb 2009 00:07:11 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <200902242342.07721.rjw@sisk.pl> <alpine.LFD.2.00.0902241449221.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902241449221.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902250007.13069.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, Linus Torvalds wrote:
> 
> On Tue, 24 Feb 2009, Rafael J. Wysocki wrote:
> >
> > > The only safe way on x86 to shutdown a level triggered ioapic irq
> > > outside of irq context is for the driver to program the hardware to
> > > not generate an irq.
> > 
> > Well, that changes things quite a bit, because it means we can't change the
> > suspend-resume sequence in a way we thought we could without fixing all
> > drivers first, but this is exactly what we'd like to avoid by changing the
> > core.
> 
> Calling "disable_irq()" is perfectly fine.
> 
> What is not possible on that broken IO-APIC (among other things) is to 
> actually turn the interrupts off at the apic (ie the whole ->shutdown() 
> thing). But that's not what we even want to do. What we care about is 
> just disabling the interrupt from a drievr perspective.
> 
> IOW, the patches I have seen are fine, and all the comments from Eric are 
> just confusion about what we want done.

Ah, OK.  Thanks for the explanation, I got confused too.

> WE DO NOT WANT TO TURN OFF THE IO-APIC. That may or may happen later, but 
> that's totally unrelated to this whole "suspend_device_irq()" thing.

Yeah.

Rafael

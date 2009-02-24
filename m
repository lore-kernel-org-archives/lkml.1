Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbZBXWwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbZBXWwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZBXWw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:52:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585AbZBXWw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:52:29 -0500
Date: Tue, 24 Feb 2009 14:51:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
 suspend-resume
In-Reply-To: <200902242342.07721.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902241449221.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200902232239.05926.rjw@sisk.pl> <m1iqn01ph3.fsf@fess.ebiederm.org> <200902242342.07721.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Feb 2009, Rafael J. Wysocki wrote:
>
> > The only safe way on x86 to shutdown a level triggered ioapic irq
> > outside of irq context is for the driver to program the hardware to
> > not generate an irq.
> 
> Well, that changes things quite a bit, because it means we can't change the
> suspend-resume sequence in a way we thought we could without fixing all
> drivers first, but this is exactly what we'd like to avoid by changing the
> core.

Calling "disable_irq()" is perfectly fine.

What is not possible on that broken IO-APIC (among other things) is to 
actually turn the interrupts off at the apic (ie the whole ->shutdown() 
thing). But that's not what we even want to do. What we care about is 
just disabling the interrupt from a drievr perspective.

IOW, the patches I have seen are fine, and all the comments from Eric are 
just confusion about what we want done.

WE DO NOT WANT TO TURN OFF THE IO-APIC. That may or may happen later, but 
that's totally unrelated to this whole "suspend_device_irq()" thing.

		Linus

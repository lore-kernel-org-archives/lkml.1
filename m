Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbZBCXT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbZBCXT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZBCXTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:19:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374AbZBCXTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:19:16 -0500
Date: Tue, 3 Feb 2009 15:18:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
 standard config registers of all devices early)
In-Reply-To: <1233702327.16867.109.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0902031514510.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>  <200902032253.42709.rjw@sisk.pl> <1233700390.16867.97.camel@pasglop>  <200902032344.22348.rjw@sisk.pl> <1233702327.16867.109.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Feb 2009, Benjamin Herrenschmidt wrote:
> 
> Wait wait wait ... the -whole- point of the exercise, wether using
> local_irq_save or disable_irq, -is- to put the ACPI bit -after- setting
> the device in low power state and before the restore on wakeup...

You're missing context.

ACPI isn't just for the device power settings. It's for the CPU's too, and 
it's for things like "prepare to sleep". And they all have _different_ 
requirements.

What Rafael is trying to tell you is that we have ACPI-initiated ordering 
requirements between turning CPU's off, and turning devices off, and he's 
not willing to change that.

> The -one- thing that indeed conflicts here is that we disable nonboot
> CPUs earlier. Right ?

This.

> Now, I doubt that would be a big issue

With ACPI, there is no such thing as a "big issue". There are only tons of 
small horrid details that. And the "big issue" is that all the small 
details are insane.

		Linus

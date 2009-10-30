Return-Path: <linux-kernel-owner+w=401wt.eu-S932895AbZJ3VSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbZJ3VSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 17:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932881AbZJ3VSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 17:18:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932872AbZJ3VSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 17:18:03 -0400
Date: Fri, 30 Oct 2009 14:17:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from
 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
In-Reply-To: <alpine.LFD.2.01.0910301335570.31845@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0910301412500.31845@localhost.localdomain>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200910301948.24473.rjw@sisk.pl> <alpine.LFD.2.01.0910301228430.31845@localhost.localdomain> <200910302132.44759.rjw@sisk.pl> <alpine.LFD.2.01.0910301335570.31845@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Oct 2009, Linus Torvalds wrote:
> 
> And partly exactly _because_ even Cardbus is starting to be "legacy", I'd 
> personally prefer to try to simplify the model to the point where we don't 
> have to think about all the subtle interactions. Just making suspend act 
> as an eject would mean that we'd never have to worry about how the CardBus 
> bridge interacts with the PCI layer at suspend/resume time.

Put another way: five years ago I would have felt that it could be 
important that people can suspend and resume while they have a CD-ROM 
mounted through a PCMCIA IDE card. Or something like that where you want 
to keep session information.

These days, that scenario is less interesting to begin with, and we're 
generally better at some of the hotplug issues anyway. Example: one of the 
reasons I used to like not causing an unplug event was because I had 
network cards, and hated setting up the connection again. These days, all 
distros come with networkmanager or similar, and hotplug networking just 
works (even if the "CD-ROM mounted" case probably still would cause 
problems).

So I think we used to have good reasons to try to maintain state over a 
suspend event, but many of those reasons have become weaker, while at the 
same time USB has meant that PCMCIA itself has become more of a 
"maintenance burden" rather than a "primary subsystem".

			Linus

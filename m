Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbZADTMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbZADTMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbZADTMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:12:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754431AbZADTMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:12:32 -0500
Date: Sun, 4 Jan 2009 11:11:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
In-Reply-To: <20090104110559.306186c4@infradead.org>
Message-ID: <alpine.LFD.2.00.0901041107590.3179@localhost.localdomain>
References: <20090104092430.7ffd2c41@infradead.org> <alpine.LFD.2.00.0901041009060.3179@localhost.localdomain> <20090104103104.6fdda9f2@infradead.org> <alpine.LFD.2.00.0901041038570.3179@localhost.localdomain> <20090104110559.306186c4@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 4 Jan 2009, Arjan van de Ven wrote:
>
> or we declare the irq probing stuff "rare" and just make THAT fully
> serializing....
> do a full synchronization before starting a probe 

Yes. That's entirely possible. However, have you verified that if an async 
thread does a synchronization, it doesn't deadlock? 

> > That said, I also wonder if we really even need to autoprobe the 
> > interrupts on any modern hardware. Rather than trying to speed up irq 
> > probing, maybe we could figure it out some other way.. The only thing
> > that matters on 99% of all machines are the one or two standard ports
> > that normally show up on 2f8h/irq3 and 3f8h/irq4 or something like
> > that. 
> 
> too bad this stuff isn't PCI enumerated.
> but if someone really still maintains this code, it could probably be
> rewritten in a "we think it's likely irq 3. how about we test that. Oh
> no? then we do expensive probing" kind of way.
> 
> Right now I don't think I have time for it (this is going to take time..
> there's so many weird things with serial ports that it's bound to break
> stuff in the beginning etc)

Yeah. The problem is that that driver is used on such varied hardware. But 
we can probably pick it up from PnP/ACPI, and autoprobe only for things 
that don't get the info from there (either because they are not PC's, or 
becuase PnP/ACPI isn't configured in). 

This is one case where I wouldn't be afraid of PnP information, because we 
could easily choose to only trust it if it makes sense (ie "if it's the 
standard 2f8/irq3 thing, then you might as well trust PnP").

		Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbZADS3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbZADS3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZADS3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:29:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:52908 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZADS3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:29:16 -0500
Date: Sun, 4 Jan 2009 10:31:04 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Message-ID: <20090104103104.6fdda9f2@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
References: <20090104092430.7ffd2c41@infradead.org>
	<alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009 10:16:57 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 4 Jan 2009, Arjan van de Ven wrote:
> > 
> > To see this working, I uploaded a "before" and "after" kernel
> > bootchart for one of my testboxes at
> > 
> > http://www.fenrus.org/linux/before.svg
> > http://www.fenrus.org/linux/after.svg
> 
> Ok, so why does the serial port init take so long? That's a quarter
> of a second for you, which is ridiculous.

good question; I was about to start looking into that one (but wanted
to get the patches out first before I did more than 3 to not waste time
on some dead-end approach if it ends up being that)

> 
> I _think_ it's the irq auto-probing, but that's just a guess.

I kinda was hoping that in part it was a scaling thing with the number
of ports (4 in my .config) so that I could do the ports
asynchronous compared to eachother ;-)

> The irq auto-probing itself also has a few excessive delays, like
> waiting for 0.1 s just to wait for spurious interrupts to trigger.
> Doing the extra unnecessary probe makes that doubly expensive.
> 
> Does this patch make any difference to you? I'm not at all sure that
> it's the irq probing, but if it is, then this should make the serial
> probe go much faster.

it turned it into a 25 msec deal .. pretty good improvement in my book.
(now I still might want to try to do this async so that it becomes
25/4 ... but the pressure i

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

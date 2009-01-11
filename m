Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbZAKNOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbZAKNOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbZAKNOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:14:21 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55661 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZAKNOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:14:19 -0500
Date: Sun, 11 Jan 2009 14:14:06 +0100
From: Pavel Machek <pavel@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Message-ID: <20090111131405.GA2217@ucw.cz>
References: <20090104092430.7ffd2c41@infradead.org> <alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-01-04 10:16:57, Linus Torvalds wrote:
> 
> 
> On Sun, 4 Jan 2009, Arjan van de Ven wrote:
> > 
> > To see this working, I uploaded a "before" and "after" kernel bootchart
> > for one of my testboxes at
> > 
> > http://www.fenrus.org/linux/before.svg
> > http://www.fenrus.org/linux/after.svg
> 
> Ok, so why does the serial port init take so long? That's a quarter of a 
> second for you, which is ridiculous.
> 
> I _think_ it's the irq auto-probing, but that's just a guess. The 8250 
> driver does some historical crud, like
> 
> 	probe_irq_off(probe_irq_on());
> 
> to get rid of any pending irq's, but that should be entirely pointless 
> these days. I bet that line basically goes back to pre-history, before we 
> made the auto-probing much stabler.
> 
> The irq auto-probing itself also has a few excessive delays, like waiting 
> for 0.1 s just to wait for spurious interrupts to trigger. Doing the extra 
> unnecessary probe makes that doubly expensive.
> 
> Does this patch make any difference to you? I'm not at all sure that it's 
> the irq probing, but if it is, then this should make the serial probe go 
> much faster.

Do serial ports even matter for the netbooks this is targeted at?
Serial ports are gone even on normal notebooks and getting rare at
desktop...


>  	}
>  
>  	/* forget possible initially masked and pending IRQ */
> -	probe_irq_off(probe_irq_on());

Delete the comment, too? :-).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbZEMIoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbZEMIoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZEMIoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:44:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43873 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753868AbZEMIoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:44:07 -0400
Date: Wed, 13 May 2009 09:44:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: dsaxena@plexity.net
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250: Don't restore NS16550 mode when console suspend
 is disabled
Message-ID: <20090513094409.50c2409f@lxorguk.ukuu.org.uk>
In-Reply-To: <20090513002850.GA28422@plexity.net>
References: <20090512210015.GA25540@plexity.net>
	<alpine.LFD.2.01.0905121452190.3343@localhost.localdomain>
	<20090513011842.22d9cd6c@lxorguk.ukuu.org.uk>
	<20090513002850.GA28422@plexity.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Surely if my console is at 230Kbits/sec then resuming it at a totally
> > different speed is going to break things for people even if it happens to
> > help XO debug ?
> 
> The console is not in high speed mode when we suspend. The original 
> commit (b5b82df6) just assumes that if it is a NATSEMI device, we 
> should set it to high speed mode at resume w/o checking if that 
> was the mode we were in when we suspended.

Then hard coding is no improvement either. It needs to restore the mode
that was present at suspend.

I'll update the 8250 Maintainers entry I suppose, I seem to have been
landed it as part of tty 8)

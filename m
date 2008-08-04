Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbYHDUib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbYHDUib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762887AbYHDUiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:38:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38265 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758841AbYHDUiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:38:11 -0400
Message-ID: <489768A1.8000501@garzik.org>
Date: Mon, 04 Aug 2008 16:37:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
References: <fa.OGeO7gZvBG4obEzRbVltjSebgTQ@ifi.uio.no> <fa.KtvYE2B2yrJqUleolhtMPN9ljAQ@ifi.uio.no> <fa.AqEKTvguYFAzDFHy/We/8MpOqmo@ifi.uio.no> <48976168.3020804@shaw.ca>
In-Reply-To: <48976168.3020804@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Alan Cox wrote:
>>> * There are still corner case in libata core - PIO is dead slow
>>> compared to drivers/ide/,
>>
>> There are two there - libata keeps IRQs blocked for longer in PIO mode as
>> well which is a factor for realtime that needs looking at, as well as
>> using 16bit not 32bit I/O for most devices (which is trivial to fix). The
>> IRQ masking stuff is more complex and old IDE handles it far better for
>> PIO on non shared IRQ interfaces. That is actually probably the most
>> complicated thing to address of the stuff you'd want to do if you were
>> going to kill off old IDE.
> 
> I was looking into the 32-bit PIO issue a bit yesterday. It looks like 
> some of the VLB libata drivers are doing this internally already, so it 
> shouldn't be hard to do this in the core. Only question is how we know 
> generically if the controller can do it or not? It looks like in old 
> IDE, a few controllers explicitly disable it, but it appears that it 
> doesn't default to on for any controller, so it's possible there are 
> others on which it doesn't work. Presumably anything on an actual 16-bit 
> bus (ISA, LPC, etc.) wouldn't like it, to start with.

FWIW there is already a patch from Willy Terreau (sp?) to add 32-bit I/O.

I queued it for "later" because it had some issues that Alan pointed 
out, IIRC.  I definitely want to push it in, though.

	Jeff




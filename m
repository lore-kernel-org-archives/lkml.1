Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbYHDXuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbYHDXuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 19:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbYHDXtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 19:49:50 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:1549 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbYHDXtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:49:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=E5rJhJF9bWORdyY81/VrQzYP4hBIuKfD8swjpT6/hAdeq7a7qfVKKGgOIecDcsaoxF
         dnNpdMLxvVLFCsebsHuelZsxjeNX/NpKVtENuIgphTQwSFqE9yfvyC6Obr0La/JTYyvf
         Q2zYfdIXstIh7uht0WyVVO5emeLH2N1o8BI14=
Message-ID: <48979575.7090004@gmail.com>
Date: Tue, 05 Aug 2008 08:49:09 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Robert Hancock <hancockr@shaw.ca>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-ide <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Ksummit-2008-discuss] Kernel Summit request for Discussion of
 future of ATA (libata) and IDE
References: <fa.OGeO7gZvBG4obEzRbVltjSebgTQ@ifi.uio.no>	<fa.KtvYE2B2yrJqUleolhtMPN9ljAQ@ifi.uio.no>	<fa.AqEKTvguYFAzDFHy/We/8MpOqmo@ifi.uio.no>	<48976168.3020804@shaw.ca> <489768A1.8000501@garzik.org>
In-Reply-To: <489768A1.8000501@garzik.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Robert Hancock wrote:
>> Alan Cox wrote:
>>>> * There are still corner case in libata core - PIO is dead slow
>>>> compared to drivers/ide/,
>>> There are two there - libata keeps IRQs blocked for longer in PIO mode as
>>> well which is a factor for realtime that needs looking at, as well as
>>> using 16bit not 32bit I/O for most devices (which is trivial to fix). The
>>> IRQ masking stuff is more complex and old IDE handles it far better for
>>> PIO on non shared IRQ interfaces. That is actually probably the most
>>> complicated thing to address of the stuff you'd want to do if you were
>>> going to kill off old IDE.
>> I was looking into the 32-bit PIO issue a bit yesterday. It looks like 
>> some of the VLB libata drivers are doing this internally already, so it 
>> shouldn't be hard to do this in the core. Only question is how we know 
>> generically if the controller can do it or not? It looks like in old 
>> IDE, a few controllers explicitly disable it, but it appears that it 
>> doesn't default to on for any controller, so it's possible there are 
>> others on which it doesn't work. Presumably anything on an actual 16-bit 
>> bus (ISA, LPC, etc.) wouldn't like it, to start with.
> 
> FWIW there is already a patch from Willy Terreau (sp?) to add 32-bit I/O.
> 
> I queued it for "later" because it had some issues that Alan pointed 
> out, IIRC.  I definitely want to push it in, though.

Jeff, have your thoughts about PIO IRQ disable handling changed yet?  I
don't really see any better way than doing it like IDE.

Thanks.

-- 
tejun

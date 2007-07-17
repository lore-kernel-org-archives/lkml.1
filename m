Return-Path: <linux-kernel-owner+w=401wt.eu-S934459AbXGQOXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459AbXGQOXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933650AbXGQOQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:16:37 -0400
Received: from homer.mvista.com ([63.81.120.155]:13498 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933853AbXGQOQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:16:35 -0400
Message-ID: <469CCFBD.4030708@ru.mvista.com>
Date: Tue, 17 Jul 2007 18:18:37 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Suleiman Souhlal <ssouhlal@freebsd.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Make the IDE DMA timeout modifiable
References: <200706160123.55636.bzolnier@gmail.com> <4693D9B6.4090408@ru.mvista.com> <20070713161612.2f2ebb0b@the-village.bc.nu> <46979652.6040201@rtr.ca> <4697987E.3040406@ru.mvista.com> <4697D425.7000300@rtr.ca> <4697D518.7010108@ru.mvista.com> <4697D686.6090104@rtr.ca> <4697DAAE.5090704@ru.mvista.com> <4697E7E2.70303@rtr.ca> <20070716192925.GA10124@bitwizard.nl>
In-Reply-To: <20070716192925.GA10124@bitwizard.nl>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Rogier Wolff wrote:

>>>  Ah, that makes sense -- during PIO interrupts happen a lot more often.
>>>20 secs still seem to be too much.

>>I don't think so, even for modern drives.
>>Figure 8-10 seconds max for spin-up,
>>plus 6-9 seconds to do a sector re-assignment
>>or retries on a bad block (a measured *real-life* value).

>>That adds up to 14-19 seconds, so 20 seconds is probably good.

>>Still, this does need to be adjustable for faster (CF) devices,
>>and slower (optical/tape) devices, rather than just a single
>>set of fixed timeout values.

> In real life, with real bad blocks on real harddrives, some harddrives
> take more than the DMA TIMEOUT time to read a single block, even without
> having to spin up. 

   Yeah, "shit happens".

> The current code then resets the drive, on which the drive reports
> "busy, not ready for command", and things go downhill from there. 

    You are clearly mixing things: this message is a result of retrying 
command in PIO mode (that fails because the drive is still busy), and then the 
drives are actually reset. If they keep being busy *after* that, all I'd say 
is dump them ASAP. ;-)

> 	Roger. 

MBR, Sergei

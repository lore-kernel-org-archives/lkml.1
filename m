Return-Path: <linux-kernel-owner+w=401wt.eu-S1765753AbXJPHRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765753AbXJPHRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 03:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758038AbXJPHRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 03:17:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58838 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758542AbXJPHRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 03:17:46 -0400
Message-ID: <47146593.2060909@garzik.org>
Date: Tue, 16 Oct 2007 03:17:39 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, shemminger@linux-foundation.org
Subject: Re: [patch] forcedeth: fix the NAPI poll function
References: <20071015112430.GA30006@elte.hu> <20071015.125731.79447899.davem@davemloft.net> <20071015220357.GA7174@elte.hu> <20071015220720.GA16101@elte.hu> <20071015223009.GA27425@elte.hu> <4713EC59.4010106@pobox.com> <20071016054236.GA27906@elte.hu> <47145075.1080003@garzik.org> <20071016064026.GA9578@elte.hu>
In-Reply-To: <20071016064026.GA9578@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
>>>> The compiler certainly doesn't care, and IMO it prevents bugs.
>>> agreed. Do you have an uptodate patch/git-URI for the forcedeth 
>>> rewrite you did? I can throw it into the testbed.
>> Branch 'fe-lock' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
>>
>> It works here locally, but at this very minute I am rewriting those 
>> changesets yet again :)
> 
> FYI, looks good so far, ontop of Linus' latest -git tree.
> 
> btw., one thing i always found weird about forcedeth is that it 
> generates an extra ~100 irqs per second even when there's no network 
> traffic:
> 
>  11:      89752    XT-PIC-XT        eth0
>  11:      89854    XT-PIC-XT        eth0
>  11:      89955    XT-PIC-XT        eth0
>  11:      90056    XT-PIC-XT        eth0
>  11:      90157    XT-PIC-XT        eth0
> 
> (irq count snapshot every second). Just in case it's easy to fix ...


May I presume that behavior occurs in both mainline and my fe-lock branch?

That is likely the NIC's timer irq, which is programmed to kick the irq 
handler every so often.  DEV_NEED_TIMERIRQ is a starting point, as well 
as "Known bugs" at the top of forcedeth.c, if you're curious.

I'm _betting_ that some of that can be eliminated, but we'll see...

	Jeff



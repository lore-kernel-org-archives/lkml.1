Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbYF3F3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbYF3F3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 01:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYF3F3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 01:29:25 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18368 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbYF3F3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 01:29:25 -0400
Message-ID: <48686D8F.8010901@nokia.com>
Date: Mon, 30 Jun 2008 08:22:23 +0300
From: Stefan Becker <Stefan.Becker@nokia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: ext David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
CC: ext Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: 2.6.26-rc8: Fix IRQF_DISABLED for shared interrupts
References: <Pine.LNX.4.44L0.0806281241200.23326-100000@netrider.rowland.org> <200806281251.21299.david-b@pacbell.net> <4867A2DE.3070509@nokia.com> <200806292009.26975.david-b@pacbell.net>
In-Reply-To: <200806292009.26975.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jun 2008 05:22:23.0861 (UTC) FILETIME=[47127250:01C8DA71]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

ext David Brownell wrote:
> 
> By the way, did you notice the oddness of IRQF_SAMPLE_RANDOM there?
> For a shared IRQ, I would rather think that if any IRQ was flagged
> as "too predictable for use as IRQ randomness" (by not having that
> flag set) then the IRQ should never be sampled ... there's some odd
> thought (or non-thought) involved in IRQ sharing.

Good question. What happens when you mix a random and a not-so-random 
source: does the result have an as good random quality as the original 
random source? If the answer is yes then the current code is OK.


> One technical comment:
> 
>> --- a/kernel/irq/internals.h
 >>
>> + * IRQF_DISABLED_CUMULATIVE - one handler in the chain has IRQF_DISABLED
>> set + */
>> +#define IRQF_DISABLED_CUMULATIVE       0x80000000
> 
> I don't think you should need that flag; and if you did, it should be
> declared in <linux/irq.h> to prevent anyone else from using that bit
> for some other purpose.

My fear was that if it is a public flag in linux/interrupt.h then 
somebody might misuse it.


> Instead, I think you can set IRQF_DISABLED in irq_desc[irq].status
> to achieve the same effect.

I actually had the same idea but missed the "irq" in the 
handle_IRQ_event() signature :-(


I'll try to send an updated patch today...

Regards,

	Stefan

---
Stefan Becker
E-Mail: Stefan.Becker@nokia.com

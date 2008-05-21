Return-Path: <linux-kernel-owner+w=401wt.eu-S934655AbYEUPZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934655AbYEUPZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763117AbYEUPZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:25:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42110 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762275AbYEUPZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:25:03 -0400
Message-ID: <48343EBC.70703@garzik.org>
Date: Wed, 21 May 2008 11:24:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: better msleep for drivers
References: <20080511110124.GA24187@basil.nowhere.org> <alpine.LFD.1.10.0805111408440.3197@apollo.tec.linutronix.de> <20080521104131.GA4948@ucw.cz>
In-Reply-To: <20080521104131.GA4948@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> Still longer term I suppose there's really no way around having accurate
>>> sleep functions and it's probably better to start testing earlier than later.
>> No objections, but we should not do that with a stupid msleep
>> replacement interface; instead we should expose a flexible in kernel
>> variant of hrtimer_nanosleep() which lets the user utilize
>> ABS/REL_TIME and the different clocks. A msleep helper can be built on
>> top of this very easily.
> 
> While you are at it... it would be cool to have
> 
> 'mdelay(2500 msec), but it is okay to wait 100msec more' -- type
> interface, so we could use that for nohz benefit.
> 
> Currently, mdelay is 'it is okay to wait 10msec more' interface, and
> it would be nice to have that explicit.

eh, I think you transposed mdelay with msleep?

msleep() is the "it is okay to wait longer than I said" interface, not 
mdelay().  mdelay() has always been non-sleeping and exact (as much as 
the delay loop allows)

	Jeff




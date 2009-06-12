Return-Path: <linux-kernel-owner+w=401wt.eu-S1762247AbZFLJE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762247AbZFLJE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756280AbZFLJEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:04:21 -0400
Received: from mail.atmel.fr ([81.80.104.162]:57805 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580AbZFLJEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:04:20 -0400
Message-ID: <4A3219F6.6000300@atmel.com>
Date: Fri, 12 Jun 2009 11:03:50 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Rob Emanuele <poorarm@shoreis.com>, Andrew Victor <avictor.za@gmail.com>
CC: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Joey Oravec <joravec@drewtech.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Subject: Re: [PATCH][Fix] New Unified AVR32/AT91 MCI Driver that supports
 both 	MCI slots used at the same time
References: <c8284b5b0906101641v586c3487i465263bb6908e3f7@mail.gmail.com>	 <20090611095432.2e3a4067@hskinnemoen-d830> <c8284b5b0906111316p1367a508vdb59ee7c2a8d2ff1@mail.gmail.com>
In-Reply-To: <c8284b5b0906111316p1367a508vdb59ee7c2a8d2ff1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Emanuele :
> Hi Haavard,
> 
>>> As with the at91 port I had of this driver, I had to add more flags to
>>> the ATMCI_DATA_ERROR_FLAGS as other communication errors were
>>> occurring and they were not be reported back.  Can anyone add more
>>> insight into this?
>> Adding them to the data error bits doesn't sound like the right thing
>> to do...but I guess there might be some sort of timing issue in there
>> where we think we're done sending the command but the controller may
>> still raise errors.
>>
>>> Again, anyone who can, please test (on either or both the AT91 and
>>> AVR32) and comment.
>> I haven't looked very closely at it yet, but I spotted a few things
>> which might prevent the patch from being accepted as-is:
>>  - I'm not sure if adding "unified" (or "now supports AT91") all over
>>    the place is the right thing to do. If the driver is selectable
>>    when you configure for AT91, it should obviously work on AT91.
> 
> Well, what is the best way to differentiate it from the at91_mci
> driver and keep users from trying to use both drivers?

I propose that we setup a kind of choice sub menu in the Kconfig for
those two drivers when they are both supported.

[..]

>>  - The AT91 platform parts should be separated from the rest since it
>>    may need to go through a different maintainer.
> 
> Who would that be as I haven't seen anyone who maintains any of those
> boards other than the at91rm8200 (at least nothing listed in the
> MAINTAINERS file)?  The board-sam9g20ek.c platform only shows Atmel as
> the most recent copyright.

Hey, AT91 are very well maintained, SAM9 as well as at91rm9200.
So, AT91 specific bits should be sent to this mailing-list with Andrew
Victor in copy.
I will also certainly add comments on this code.

Best regards,
-- 
Nicolas Ferre


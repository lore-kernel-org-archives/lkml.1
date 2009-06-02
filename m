Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbZFBQcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbZFBQcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756467AbZFBQbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:31:55 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:33209 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255AbZFBQby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:31:54 -0400
MIME-Version: 1.0
In-Reply-To: <4A24E788.2090305@atmel.com>
References: <c8284b5b0905281440hd2e4993re3d0d8c590713fa0@mail.gmail.com>
	 <4A24E788.2090305@atmel.com>
Date: Tue, 2 Jun 2009 09:31:55 -0700
X-Google-Sender-Auth: 933fe6c2254721ac
Message-ID: <c8284b5b0906020931v1d30bb7co40db73239d44c629@mail.gmail.com>
Subject: Re: [PATCH] New AT91 MCI Driver that supports both MCI slots used at 
	the same time
From: Rob Emanuele <poorarm@shoreis.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings Nicolas,

Thank you for your interest in this.

On Tue, Jun 2, 2009 at 1:49 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Rob Emanuele :
>> Greetings,
>>
>> This patch creates a new AT91 Multimedia Card Interface (MCI) driver
>> that supports using both MCI slots at the same time.  I'm looking for
>> others to test this patch on other boards within the same family of
>> chips.
>>
>> This driver is a port the Atmel AVR32 MCI driver which uses similar silicon.
>
> I am very interested with this work. But, you will have to tell us what
> is the precise relation between this code and the Atmel AVR32 MCI driver.
> Why did you rename all function and variables to at91... instead of
> trying to modify the atmel-mci driver ? Was the needed behavior so far
> from the original code that you decided to create another completely new
> one ? Please enlighten us.
>
> Moreover, it seems that in your code, DMA is not supported so atmel-mci
> without the DMA option enabled should be working without modification at
> all (am I missing something ?).

Currently the behavior is similar to that of the AVR32.  The DMA
support will be vastly different and the registers are not a perfect
match.  Those were the main reasons for diverging the driver from the
AVR32.  I need to be sure this code can work as well as possible
without regard for the AVR32 (as I do not have the ability to test
against it for regressions).  As the driver improves in performance
and gets to a very stable point I would be happy to look at
re-integrating them.

>
>> In addition it modifies the AT91SAM9G20-EK's board platform config to
>> support having MCI Slot A hooked to an SD Slot.  This was the board
>> that this was developed on. To support MCI Slot A it was needed to not
>> enable the LEDs on the AT91SAM9G20-EK board if SD/MMC Slot A is
>> enabled.  The Slot A pins overlap the LEDs on Rev A and B boards.
>
> This is a different board, so you will have to create a different board
> source file (board-my9g20customboard.c) or find a clever way of sharing
> code (true, can be preferable as only a few lines are changing).

I have one that I can include in the next version of the patch.

As it stands now, I am having trouble writing more than a small file
to both cards simultaneously (from the user's point of view).  I can
write to one card and then the other.  I start to get errors when, for
example, I write continuously to slot B and then try to write anything
more than 16k to slot A.  I'm exploring the causes of this.  I'm
thinking it is either the controller needs to be fully reconfigured
when switching between slots or that the locks in the driver aren't
protecting everything they need to be.

Again thank you for your interest,

Rob Emanuele

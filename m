Return-Path: <linux-kernel-owner+w=401wt.eu-S1761892AbYA1ToZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761892AbYA1ToZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYA1ToR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:44:17 -0500
Received: from ms01.sssup.it ([193.205.80.99]:55468 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751052AbYA1ToQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:44:16 -0500
X-Greylist: delayed 3598 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2008 14:44:16 EST
Message-ID: <18229.80.33.200.229.1201545855.squirrel@feanor.sssup.it>
In-Reply-To: <200801281021.57317.david-b@pacbell.net>
References: <479DB934.6090806@gandalf.sssup.it>
    <20080128145615.1d756025@dhcp-252-066.norway.atmel.com>
    <200801281021.57317.david-b@pacbell.net>
Date: Mon, 28 Jan 2008 19:44:15 +0100 (CET)
Subject: Re: at91sam9260 wakeup on serial port
From: trimarchi@feanor.sssup.it
To: "David Brownell" <david-b@pacbell.net>
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "michael" <trimarchi@gandalf.sssup.it>, linux-kernel@vger.kernel.org,
       "Andrew Victor" <linux@maxim.org.za>
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> On Monday 28 January 2008, Haavard Skinnemoen wrote:
>> On Mon, 28 Jan 2008 12:15:00 +0100
>> michael <trimarchi@gandalf.sssup.it> wrote:
>>
>> > Hi,
>> > I implement a little patch (ndr just for a try) for the atmel serial
>> > driver atmel_serial.c to wakeup the system when it is in suspend-ram
>> state.
>> > I reconfigure the RXD pin as a gpio in suspend function and restore it
>> > in the resume function. It is the correct way?
>>
>> I'm not sure...this is rather platform-specific, so I don't think it
>> really belongs in the atmel_serial() driver. One solution might be to
>> add a function pointer to struct atmel_uart_data that the driver can
>> call from ->suspend() in order to let the platform code handle this as
>> appropriate.
>
> The core issue is that the system clock driving the baud rate generator
> is no longer running fast enough to let the UART run.  (In "standby" the
> clock is still driven by the PLL, so this issue doesn't come up.)  The
> GPIO logic can catch the START bit though ... this technique is used on
> some OMAP boards too.
>
> Agreed that knowing exactly which pin(s) should be remuxed (UARTn.RX to
> GPIO in suspend then enabling it as a wakeup irq, then reversing that
> on resume; maybe UARTn.DCD should work too..), and how (as A-peripheral?
> or  B?) is chip-specific knowledge.  Such a function pointer could work.
>
> What will AVR32 (AP7) need to do, when it supports system sleep states?
>
> - Dave
>
My code just works and I can try to implement a clean patches and submit to
the mailing list.

Michael


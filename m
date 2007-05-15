Return-Path: <linux-kernel-owner+w=401wt.eu-S1762099AbXEOIob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762099AbXEOIob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758461AbXEOIoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:44:24 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:43199 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757760AbXEOIoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:44:23 -0400
Date: Tue, 15 May 2007 10:43:31 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Tilman Schmidt <tilman@imap.cc>
cc: "Lars K.W. Gohlke" <lkwg82@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
In-Reply-To: <4648E9F7.5090908@imap.cc>
Message-ID: <Pine.LNX.4.61.0705151020310.9570@yvahk01.tjqt.qr>
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de>
 <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr> <4648E9F7.5090908@imap.cc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 15 2007 01:00, Tilman Schmidt wrote:
>Am 14.05.2007 22:00 schrieb Jan Engelhardt:
>> On May 14 2007 19:40, Lars K.W. Gohlke wrote:
>>>>
>>>> after searching the mailing list and searching the web, I still don't
>>>> know how to access correctly the serial port (in user space known as
>>>> /dev/ttyS01)
>> 
>> http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad
>
>That's not nice, sending a newbie on a wild goose chase like that.
>He doesn't want to write to a file from kernel after all. Reading
>FAQs is never bad, of course, but reading that particular one
>won't help him at all with this questions.

The original poster is quite unclear about how he wants to access the
serial port. Given that he uses "in user space known as", I deducted
he means kernel space. Then of course is the big question since there
are a number of ways:

  - access by filp
  - access by ldisc
  - access by <whatever drives console=ttyS0> (printk and something)
  - access by inb (perhaps it is a serial port with a custom chip
    that the OP wanted to write a driver for?)

Unfortunately, my magic sphere is out of order, so I could only take
a really really vague guess at what was wanted. 


>Lars: Read that at your leisure if you have time. It is quite
>educating, though completely irrelevant to your questions.
>
>>>> would somebody be so kind to give me an example:
>>>>
>>>> with this behaviour:
>>>>
>>>> 1. read from port
>>>> 2. output via printk()
>>>> 3. write to port
>> 
>> inb/inw/inl, printk, outb/outw/outl.
>
>This is even less nice. You're sending him down the road of
>directly programming UART registers, knowing full well (I hope)
>that this a Bad Thing.

This is how 8250.c works.



	Jan
-- 

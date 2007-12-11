Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbXLKBrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbXLKBrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 20:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbXLKBrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 20:47:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55346 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbXLKBrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 20:47:10 -0500
Message-ID: <475DEBD8.2080608@zytor.com>
Date: Mon, 10 Dec 2007 17:46:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Newall <david@davidnewall.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Rene Herman <rene.herman@keyaccess.nl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz> <475CBDD7.5050602@keyaccess.nl> <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com>
In-Reply-To: <475DEB23.1000304@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> H. Peter Anvin wrote:
>> David Newall wrote:
>>> Where did the 8us delay come from?  The documentation and source is 
>>> careful not to say how long the delay is.  Would changing it to, say 
>>> 1us, be technically wrong?  Is code that requires 8us correct?
>>
>> I think a single ISA bus transaction is 1 µs, so two of them back to 
>> back should be 2 µs, not 8 µs...
> 
> Exactly.  You think it's 2us, but the documentation doesn't say.  The _p 
> functions are generic inasmuch as they provide an unspecified delay.  
> Drivers which work across platforms, and which use _p, therefore have 
> different delays on different platforms.  Should the length of the delay 
> be unimportant?  I wouldn't have thought so.  If it is important, does 
> that mean that such drivers are buggy on some platforms?
> 

What it specifically does is it generates a delay which is proportional 
to the ISA/LPC clock.

> I really *hate* the idea that access to non-present hardware is used to 
> generate a delay.  That sucks so badly.  It's worthy of a school-aged 
> hacker, not of a world-leading operating system.  It's so not 
> best-practice that it's worst-practice.
> 

Perhaps you do, but it's the de facto standard on the platform.  Every 
BIOS uses the same technique, because it works.

*Now*, the real question is how many drivers actually need these delays. 
  My guess is most don't at all.

	-hpa


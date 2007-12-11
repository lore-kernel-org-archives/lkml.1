Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbXLKBnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbXLKBnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 20:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbXLKBnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 20:43:08 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:37073 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbXLKBnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 20:43:07 -0500
Message-ID: <475DEB23.1000304@davidnewall.com>
Date: Tue, 11 Dec 2007 12:12:59 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Rene Herman <rene.herman@keyaccess.nl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz> <475CBDD7.5050602@keyaccess.nl> <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com>
In-Reply-To: <475DE6F4.80702@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> David Newall wrote:
>> Where did the 8us delay come from?  The documentation and source is 
>> careful not to say how long the delay is.  Would changing it to, say 
>> 1us, be technically wrong?  Is code that requires 8us correct?
>
> I think a single ISA bus transaction is 1 µs, so two of them back to 
> back should be 2 µs, not 8 µs...

Exactly.  You think it's 2us, but the documentation doesn't say.  The _p 
functions are generic inasmuch as they provide an unspecified delay.  
Drivers which work across platforms, and which use _p, therefore have 
different delays on different platforms.  Should the length of the delay 
be unimportant?  I wouldn't have thought so.  If it is important, does 
that mean that such drivers are buggy on some platforms?

I really *hate* the idea that access to non-present hardware is used to 
generate a delay.  That sucks so badly.  It's worthy of a school-aged 
hacker, not of a world-leading operating system.  It's so not 
best-practice that it's worst-practice.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbXLGHfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbXLGHfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 02:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbXLGHfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 02:35:08 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:37802 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbXLGHfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 02:35:06 -0500
Message-ID: <4758F76C.1090207@keyaccess.nl>
Date: Fri, 07 Dec 2007 08:34:04 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <fa./27SNSh+L5T3iqFNPdHClEu+yT0@ifi.uio.no> <4758927F.50500@shaw.ca> <4758D584.90105@keyaccess.nl> <4758E014.7040108@reed.com> <4758F373.6020901@keyaccess.nl>
In-Reply-To: <4758F373.6020901@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-12-07 08:17, Rene Herman wrote:

> On 07-12-07 06:54, David P. Reed wrote:
> 
>> Pardon my ignorance, but is port 0xed really safe to push an out cycle 
>> at across the entire x86_64 family?
> 
> Please do not top-post. Who knows, probably not. You just experienced 
> that 0x80 is apparently not safe for you and that one's the conventional 
> choice so it's likely that someone somewhere will have problems with 
> 0xed as well.
> 
> That's why I adviced you'd test and see what blows up and suggested that 
> in the absence of better fixes a 0x80/0xed port choice might be able to 
> hang off machine types as retrievable from DMI or something.
> 
> The better fix would probably be to simply udelay(1) but you need 
> calibrated timers before you can do that and some googling leads me to 
> believe that's why it's not today. There's also a possible issue in that 
> an I/O access might serve as a method of flushing forwarding buffers on 
> a PCI bridge but I have no idea if that's a real issue (and if it is, an 
> inb() should suffice as well).
> 
>> How long must real _p pauses be in reality?
> 
> 8 ISA bus cycles is the intended delay it seems which at a typical ISA 
> bus speed of 8 MHz amounts to 1 us.
> 
>> (and who cares about what the code calls "really slow i/o").
> 
> Paranoid programmers and those that need to delay for 4 us.
> 
>> Why are we waiting at all?  I read the comments in io_64.h, and am a 
>> bit mystified.  Does Windoze or DOS do this magical mystery wait?
> 
> The CMOS example at hand is the standard example. It's accessed through 
> an index/data register pair. You need to be sure that the RTC has 
> switched the  correct internal register to the data register before you 
> poke at it or you may read/write the wrong one.
> 
> Now, as said, I can't say I've ever in fact caught _any_ piece of 
> hardware with its pants down like that and needing this for actual 
> RTC/CMOS could as far as I'm aware be more of a left-over from The Olden 
> Days with a bus more or less directly tied to the 8086 than sensible for 
> anything on which Linux could run. Hard to test though and certainly for 
> generic outb_p use.
> 
> Yes, DOS or at least many programs that ran under it did very similar 
> things but DOS ofcourse originated on those first PCs.
> 
>> Anyway, the virtualization hooks in 32-bit x86 almost make it possible 
>> to isolate this simply - maybe - after the merge of 32/64 being 
>> contemplated.
>>
>> And anyone who knows what the chipset might be doing with the 80 port 
>> rather than POST codes, perhaps could contribute.  Any nvidia folks 
>> who know what's happening under NDA?  Any Phoenix BIOS types?
> 
> It's fairly surprising that 0x80 is given you trouble. It's a very well 
> known legacy port. Even though it may not be all that sensible a thing 
> today I'd say that if your machine put anything other than an actual 
> integrated POST monitor on port 0x80 it in fact fucked up.

This is a good thread to read:

http://linux.derkeiler.com/Mailing-Lists/Kernel/2003-09/5700.html

maybe you have some LPC device that gets confused by aborts on the bus as well.

Rene.

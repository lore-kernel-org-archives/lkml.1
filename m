Return-Path: <linux-kernel-owner+w=401wt.eu-S932387AbXBSQbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbXBSQbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 11:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932390AbXBSQbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 11:31:03 -0500
Received: from lmv.inov.pt ([146.193.64.2]:51664 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387AbXBSQbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 11:31:01 -0500
Message-ID: <45D9D073.7020701@inov.pt>
Date: Mon, 19 Feb 2007 16:29:39 +0000
From: Jose Goncalves <jose.goncalves@inov.pt>
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
References: <20070220132909.GD566@slug> <20070219134539.GA27370@flint.arm.linux.org.uk> <20070220142442.GF566@slug> <20070219143520.GB27370@flint.arm.linux.org.uk> <20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk>
In-Reply-To: <20070219150508.GD27370@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Tue, Feb 20, 2007 at 02:48:14PM +0000, Frederik Deweerdt wrote:
>   
>> (trimmed tie-fei.zang from the CC, added by mistake)
>> On Mon, Feb 19, 2007 at 02:35:20PM +0000, Russell King wrote:
>>     
>>>> Neither did I, but introducing printk's through the function, we narrowed
>>>> the problem to this part of the code. And removing it makes the problem
>>>> go away. We inserted 37 printk's in the function body, and Jose bisected
>>>> those until the problem went away.
>>>>         
>>> Well, there's still little clue about why this is causing a NULL pointer
>>> dereference.  The only thing I can think is that somehow performing
>>> this test is causing a power glitch to your CPU, causing its registers
>>> to get corrupted, and which results in it doing a NULL pointer deref.
>>>       
>> That may be the case, indeed.
>>     

But if the problem was a power glitch I should get Oops with or without
printk() inserted, shouldn't I?

>>> Are you saying that the NULL pointer occurred while executing this code?
>>> If not, where does the NULL pointer occur?
>>>       
>> The thing is, the NULL pointer deref dissapeared as soon as we
>> instrumented (printk'ed) the code. So it's seems to be triggered by
>> check+timing+hardware.
>>     
>
> So to summarise, we have some code somewhere which is causing a NULL
> pointer deref in uart_startup().  If we remove some code, the NULL
> pointer deref stops happening.
>
> And that's about the sum total of the information we know.  We don't
> know precisely where the NULL pointer deref occurs, and we don't know
> what's causing it.
>
> It doesn't sound like there's much understanding of the problem at hand. ;(
>
>   
>>> Andrew's said no (in that the thread you refer to) and suggested an
>>> alternative, I've said no, how many more 'no's do you need to turn
>>> you away from the wrong approach?
>>>       
>> One is usually sufficient once I've understood :). I missed the module
>> option approach. Is it ok with you? If yes, I'll put up a patch to do
>> this.
>>     
>
> I guess so, but how does the user know whether they need this enabled or
> disabled?
>
>   
>> The problem appears to be reproducible on Jose's hardware within 2-3 days.
>>     

In a kernel without instrumentation I get problems within a 1 day period.

>> If you see other tests to be performed...
>>     
>
> Maybe adding some delays in that bit of code?  I'm sure you've already
> thought of that though.  Since no one has a proper understanding of the
> problem, the only suggestions possible are mere shots in the dark.
>   

I'm no kernel expert, but it's not possible to trace what is the
instruction that is causing the NULL pointer dereference? The kernel
dump does not show this?

I have no clue on what is causing this problem but, what I know, is that
I can always reproduce it, and it always happens in the same code
section of serial8250_startup().

Regards,
José Gonçalves

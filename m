Return-Path: <linux-kernel-owner+w=401wt.eu-S1762445AbXLPXHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762445AbXLPXHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 18:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbXLPXHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 18:07:23 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:65245 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbXLPXHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 18:07:22 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18orowIbMio7banHLX1lEmY
Message-ID: <4765AF78.60307@reed.com>
Date: Sun, 16 Dec 2007 18:06:32 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <20071215230036.GF2434@elf.ucw.cz> <47645D66.4020506@zytor.com> <20071216094029.GD27280@elte.hu> <47659BF3.4040100@zytor.com>
In-Reply-To: <47659BF3.4040100@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The process of safely making delicate changes here is beyond my 
responsibility as just a user - believe me, I'm not suggesting that a 
risky fix be put in .24.   I can patch my own kernels, and I can even 
share an unofficial patch with others for now, or suggest that Fedora 
and Ubuntu add it to their downstream.

May I make a small suggestion, though.   If the decision is a DMI-keyed 
switch from out-80 to udelay(2)  gets put in, perhaps there should also 
be a way for people to test their own configuration for the underlying 
problem made available as a script.   Though it is a "hack", all you 
need to freeze a problem system is to run a loop doing about 1000 "cat 
/dev/nvram > /dev/null"  commands.  If that leads to a freeze, one might 
ask to have the motherboard added to the DMI-key list.

H. Peter Anvin wrote:
> Ingo Molnar wrote:
>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>
>>> Pavel Machek wrote:
>>>>> this is also something for v2.6.24 merging.
>>>> As much as I like this patch, I do not think it is suitable for
>>>> .24. Too risky, I'd say.
>>>>
>>> No kidding!  We're talking about removing a hack that has been 
>>> successful on thousands of pieces of hardware over 15 years because it 
>>                                                              ^----[*]
>>> breaks ONE machine.
>>
>> [*] "- none of which needs it anymore -"
>>
>> there, fixed it for you ;-)
>>
>> So lets keep this in perspective: this is a hack that only helps on a 
>> very low number of systems. (the PIT of one PII era chipset is known 
>> to be affected)
>
> Yes, but the status quo has been *tested* on thousands of systems and 
> is known to work.  Thus, changing it puts things into unknown 
> territory, even if only a small number of machines actually need the 
> current configuration.
>
> Heck, there are only a small number of 386/486 machines still in 
> operation and being actively updated.
>
>> unfortunately this hack's side-effects are mis-used by an unknown 
>> number of drivers to mask PCI posting bugs. We want to figure out 
>> those bugs (safely and carefully) and we want to remove this hack 
>> from modern machines that dont need it. Doing anything else would be 
>> superstition.
>>
>> anyway, we likely wont be doing anything about this in .24.
>
> Again, 24 is "right out".  25 is a "maybe", IMO.  Rene's fix could be 
> an exception, since it is a DMI-keyed workaround for a specific 
> machine and doesn't change behaviour in general.
>
>     -hpa
>

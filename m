Return-Path: <linux-kernel-owner+w=401wt.eu-S1762407AbXLPVo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762407AbXLPVo1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760030AbXLPVoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:44:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59745 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760022AbXLPVoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:44:15 -0500
Message-ID: <47659BF3.4040100@zytor.com>
Date: Sun, 16 Dec 2007 13:43:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pavel Machek <pavel@ucw.cz>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <20071215230036.GF2434@elf.ucw.cz> <47645D66.4020506@zytor.com> <20071216094029.GD27280@elte.hu>
In-Reply-To: <20071216094029.GD27280@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> Pavel Machek wrote:
>>>> this is also something for v2.6.24 merging.
>>> As much as I like this patch, I do not think it is suitable for
>>> .24. Too risky, I'd say.
>>>
>> No kidding!  We're talking about removing a hack that has been 
>> successful on thousands of pieces of hardware over 15 years because it 
>                                                              ^----[*]
>> breaks ONE machine.
> 
> [*] "- none of which needs it anymore -"
> 
> there, fixed it for you ;-)
> 
> So lets keep this in perspective: this is a hack that only helps on a 
> very low number of systems. (the PIT of one PII era chipset is known to 
> be affected)

Yes, but the status quo has been *tested* on thousands of systems and is 
known to work.  Thus, changing it puts things into unknown territory, 
even if only a small number of machines actually need the current 
configuration.

Heck, there are only a small number of 386/486 machines still in 
operation and being actively updated.

> unfortunately this hack's side-effects are mis-used by an unknown number 
> of drivers to mask PCI posting bugs. We want to figure out those bugs 
> (safely and carefully) and we want to remove this hack from modern 
> machines that dont need it. Doing anything else would be superstition.
> 
> anyway, we likely wont be doing anything about this in .24.

Again, 24 is "right out".  25 is a "maybe", IMO.  Rene's fix could be an 
exception, since it is a DMI-keyed workaround for a specific machine and 
doesn't change behaviour in general.

	-hpa

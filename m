Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZCKCdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZCKCdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 22:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZCKCdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 22:33:40 -0400
Received: from mail-gx0-f167.google.com ([209.85.217.167]:53077 "EHLO
	mail-gx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbZCKCdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 22:33:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hmeZLraSq98FFggGQXLL1fCeVL8lYLJnbd02HFpiRJtaguLIH4a70O3zgziUCmCvh9
         Siwfje3uzBf0IeinTzVDHUp2+9N/11C6T2tXLutRb7sSZneG1Dy+cHrOBz7NYtAP6Et1
         dwyJm/qdkrTpXhkr77x80xY3CQe7c4RlqGB98=
MIME-Version: 1.0
In-Reply-To: <20090310153332.GB23463@elte.hu>
References: <20090310102459.23422.80761.sendpatchset@rx1.opensource.se>
	 <alpine.LFD.2.00.0903101510040.29264@localhost.localdomain>
	 <20090310150415.GL3850@elte.hu>
	 <alpine.LFD.2.00.0903101615540.29264@localhost.localdomain>
	 <20090310153332.GB23463@elte.hu>
Date: Wed, 11 Mar 2009 11:32:52 +0900
Message-ID: <aec7e5c30903101932r4bbd8746tf0bb02e16f62716e@mail.gmail.com>
Subject: Re: [PATCH] Free setup_irq() interrupt V2
From: Magnus Damm <magnus.damm@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 12:33 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> On Tue, 10 Mar 2009, Ingo Molnar wrote:
>> > * Thomas Gleixner <tglx@linutronix.de> wrote:
>> > > On Tue, 10 Mar 2009, Magnus Damm wrote:
>> > > > From: Magnus Damm <damm@igel.co.jp>
>> > > > This patch adds a __free_irq() function for releasing
>> > > > interrupts requested with setup_irq().
>> > >
>> > > I think there is a simpler solution than adding yet another
>> > > function for the confusion of driver writers. See below.
>> >
>> > Uhm, i asked for that solution ;-)
>>
>> Uhm, I missed that :)

Thomas, your suggestion is quite similar to V1. =)

>> I can live with the two functions as well, but then please let us use
>> a function name which is more intuitive than __free_irq().
>>
>> setup_irq()   -> remove_irq()
>> request_irq() -> free_irq()
>
> Sure, that's fine with me.
>
> I almost suggested shutdown_irq() to Magnus originally, then
> went for __free_irq().

How about this change for V2:

Keep __free_irq() but make it static. Let free_irq() and a new
remove_irq() function call __free_irq(). This makes the free functions
similar to setup_irq(), __setup_irq() and request_irq(). The new
remove_irq() function takes interrupt number and a struct irqaction
pointer as arguments - this to match setup_irq().

Sounds ok? If so I'll fix up and repost a V3 against the tip tree.

While at it, what about exporting the setup_irq() and remove_irq() symbols?

You probably dislike it since it may confuse people. I'd like to
export these functions since I have timer code that needs to use
setup_irq() early on (too early for request_irq()), and the same code
can also be compiled as a module. The solution so far has been using
setup_irq()/remove_irq(), but you may have some better suggestions?

Thanks for your help!

Cheers,

/ magnus

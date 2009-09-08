Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbZIHERA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbZIHERA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 00:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZIHEQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 00:16:59 -0400
Received: from mail-iw0-f175.google.com ([209.85.223.175]:44499 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZIHEQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 00:16:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=U9F5R7Q9DV2/8TsGquCA0QcK6xbzA7Y2m14BXKKx2oHuIRxBqWutZtkNx97rjmYG2x
         xvFX6r6UESQOdBk5qEb166uSe3fODXiCpdr3wDvS8ILcx3NPC6LjDS+ckrY7hLZOfet+
         lEbxFXDo68J6AaV6ySz0P4aLI9SiYs50WHa1U=
MIME-Version: 1.0
In-Reply-To: <1252376254.21261.2052.camel@gandalf.stny.rr.com>
References: <43e72e890909071558s637b45c7i10807587dc40e8c4@mail.gmail.com> 
	<20090907171406.6a4b6116@nehalam> <1252376254.21261.2052.camel@gandalf.stny.rr.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 7 Sep 2009 21:16:38 -0700
Message-ID: <43e72e890909072116v33ecafc4ma7f5a68825f14e9@mail.gmail.com>
Subject: Re: Stop using tasklets for bottom halves
To: rostedt@goodmis.org
Cc: Stephen Hemminger <shemminger@vyatta.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Matt Smith <Matt.Smith@atheros.com>, Kevin Hayes <kevin@atheros.com>,
       Bob Copeland <me@bobcopeland.com>, Jouni Malinen <j@w1.fi>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, ic.felix@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 7, 2009 at 7:17 PM, Steven Rostedt<rostedt@goodmis.org> wrote:
> On Mon, 2009-09-07 at 17:14 -0700, Stephen Hemminger wrote:
>> On Mon, 7 Sep 2009 15:58:50 -0700
>> "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
>>
>> > A while ago I had read about an effort to consider removing tasklets
>> > [1] or at least trying to not use them. I'm unaware of the progress in
>> > this respect but since reading that article have always tried to
>> > evaluate whether or not we need tasklets on wireless drivers. I have
>> > also wondered whether work in irq context in other parts of the kernel
>> > can be moved to process context, a curious example being timers. I'll
>> > personally be trying to using only process context on bottom halves on
>> > future drivers but I figured it may be a good time to ask how serious
>> > was avoiding tasklets or using wrappers in the future to avoid irq
>> > context is or is it advised. Do we have a general agreement this is a
>> > good step forward to take? Has anyone made tests or changes on a
>> > specific driver from irq context to process context and proven there
>> > are no significant advantages of using irq context where you would
>> > have expected it?
>> >
>> > Wireless in particular should IMHO not require taskets for anything
>> > time sensitive that I can think about except perhaps changing channels
>> > quickly and to do that appropriately also process pending RX frames
>> > prior to a switch. It remains to be seen experimentally whether or not
>> > using a workqueue for RX processing would affect the time to switch
>> > channels negatively but I doubt it would be significant. I hope to
>> > test that with ath9k_htc.
>> >
>> > What about gigabit or 10 Gigabit Ethernet drivers ? Do they face any
>> > challenges which would yet need to be proven would not face issues
>> > when processing bottom halves in process context?
>> >
>> > [1] http://lwn.net/Articles/239633/
>> >
>> >   Luis
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe netdev" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> Why not use NAPI, which is soft irq? Almost all 1G and 10G drivers
>> use NAPI.
>>
>> Process context is too slow.
>
> Well, I'm hoping to prove the opposite. I'm working on some stuff that I
> plan to present at Linux Plumbers. I've been too distracted by other
> things, but hopefully I'll have some good numbers to present by then.

What day in specific was this planned for at Plumbers?

  Luis

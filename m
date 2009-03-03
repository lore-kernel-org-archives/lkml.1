Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZCCBW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZCCBW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 20:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbZCCBWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 20:22:50 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:51542 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZCCBWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 20:22:49 -0500
MIME-Version: 1.0
In-Reply-To: <200903011020.53130.rjw@sisk.pl>
References: <200902192215.18365.rjw@sisk.pl> <200902282353.39763.rjw@sisk.pl>
	 <d6200be20902281606g1c5db332r9970931d7080717f@mail.gmail.com>
	 <200903011020.53130.rjw@sisk.pl>
Date: Mon, 2 Mar 2009 17:22:46 -0800
Message-ID: <d6200be20903021722y7f085482o66f6dee8c4004acd@mail.gmail.com>
Subject: Re: [RFD] Automatic suspend
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 1, 2009 at 1:20 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> >> I do provide an option to turn off the wakelock stats, which makes
>> >> >> wake_lock/unlock significantly faster, but we never run with wakelock
>> >> >> stats off. Also, it pushes timeout handling to the drivers. I know may
>> >> >> of you don't like timeout support, but ignoring the problem is not a
>> >> >> solution. If each driver that needs timeouts uses its own timer, then
>> >> >> you will often wakeup from idle just to unlock a wakelock that will
>> >> >> not trigger suspend. This wakeup is a thousand times as costly on the
>> >> >> msm platform as a wakelock/unlock pair (with wakelock stats enabled).
>> >> >
>> >> > Well, at least a couple of people told you that the timeouts are hardly
>> >> > acceptable and they told you why.  Please stop repeating the same arguments you
>> >> > have given already for a couple of times.  They're not convincing.
>> >>
>> >> And you keep ignoring them.
>> >
>> > Not ignoring, but considering them as insufficient.  And since they've already
>> > been considered as insufficient, there's no point repeating them over and over
>> > again.  That doesn't make them any better.
>>
>> The problem is that what you consider insufficient is what allows us
>> to ship a product.
>
> This doesn't matter a whit, because the mainline kernel is not just your
> product.

Unless you are saying that changes in the mainline kernel does not
need be usable in practice, then it does matter. If we remove the
feature that allows us to interact with existing code, it will take
much longer before it is usable by anyone.

> By the same rule you could say that every working vendor driver is worth
> merging into the mainline kernel, which clearly is not the case.

Some people seem to think they are.

>
>> >> > I do realize that you consider your current solution as the best thing since
>> >> > the sliced bread, but please accept the fact that the other people think
>> >> > differently.
>> >>
>> >> I certainly do not think my current solution is the best, it is very
>> >> invasive. I do however think your proposed solution is worse. The only
>> >> proposed alternative that we could actually ship a product on today is
>> >> to not use suspend at all.
>> >
>> > Well, I'm sure your code is useful for the Android platform, but the question
>> > is whether we want this code in the mainline kernel.  For now, the answer is
>> > "no, we don't".  Moreover, since you're the one who wants the code to be
>> > merged, it's your burden to make it acceptable for us.  However you're going
>> > to do it is up to you, but certainly trying to force your current code on us
>> > is not going to work.
>>
>> I don't think I am the only one who want this code in the mainline
>> kernel. Many people want to use the android platform, and support in
>> the mainline kernel would be beneficial to some of them. I made many
>> requested changes to my code that provides no benefit to us, but I
>> have not made any changes that breaks our own use.
>
> OK, please resubmit the patches, then.

I submitted them three weeks ago. I'll submit a new set after I rename
the api (presumably to suspend_block(er)) but I would like more
agreement on the timeout issue first.

-- 
Arve Hjønnevåg

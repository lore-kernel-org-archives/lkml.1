Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZCAAGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZCAAGZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 19:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZCAAGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 19:06:17 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:27587 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZCAAGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 19:06:16 -0500
MIME-Version: 1.0
In-Reply-To: <200902282353.39763.rjw@sisk.pl>
References: <200902192215.18365.rjw@sisk.pl> <200902281118.14595.rjw@sisk.pl>
	 <d6200be20902281357r2d3a0075q77055c1781f174d7@mail.gmail.com>
	 <200902282353.39763.rjw@sisk.pl>
Date: Sat, 28 Feb 2009 16:06:12 -0800
Message-ID: <d6200be20902281606g1c5db332r9970931d7080717f@mail.gmail.com>
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

On Sat, Feb 28, 2009 at 2:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> What you are talking about here is mostly an optimization of the
>> >> wakelock api. You have removed timeout support and made each wakelock
>> >> reference counted.
>> >
>> > I also removed the arbitrary number of wakelocks (I really _hate_ the name,
>> > can we please stop using it from now on?).
>>
>> What do you mean by this? You removed the struct wake_lock?
>
> Basically, yes.

Why is this better? If you move the stats into devices and tasks, this
may take up more space than adding an object to the structures or
tasks that you are protecting.


>> >> I do provide an option to turn off the wakelock stats, which makes
>> >> wake_lock/unlock significantly faster, but we never run with wakelock
>> >> stats off. Also, it pushes timeout handling to the drivers. I know may
>> >> of you don't like timeout support, but ignoring the problem is not a
>> >> solution. If each driver that needs timeouts uses its own timer, then
>> >> you will often wakeup from idle just to unlock a wakelock that will
>> >> not trigger suspend. This wakeup is a thousand times as costly on the
>> >> msm platform as a wakelock/unlock pair (with wakelock stats enabled).
>> >
>> > Well, at least a couple of people told you that the timeouts are hardly
>> > acceptable and they told you why.  Please stop repeating the same arguments you
>> > have given already for a couple of times.  They're not convincing.
>>
>> And you keep ignoring them.
>
> Not ignoring, but considering them as insufficient.  And since they've already
> been considered as insufficient, there's no point repeating them over and over
> again.  That doesn't make them any better.

The problem is that what you consider insufficient is what allows us
to ship a product.

>> > I do realize that you consider your current solution as the best thing since
>> > the sliced bread, but please accept the fact that the other people think
>> > differently.
>>
>> I certainly do not think my current solution is the best, it is very
>> invasive. I do however think your proposed solution is worse. The only
>> proposed alternative that we could actually ship a product on today is
>> to not use suspend at all.
>
> Well, I'm sure your code is useful for the Android platform, but the question
> is whether we want this code in the mainline kernel.  For now, the answer is
> "no, we don't".  Moreover, since you're the one who wants the code to be
> merged, it's your burden to make it acceptable for us.  However you're going
> to do it is up to you, but certainly trying to force your current code on us
> is not going to work.

I don't think I am the only one who want this code in the mainline
kernel. Many people want to use the android platform, and support in
the mainline kernel would be beneficial to some of them. I made many
requested changes to my code that provides no benefit to us, but I
have not made any changes that breaks our own use.

> BTW, I think you handled the thing wrong.  If I were you, I wouldn't even try
> to push the code as you did.  I would instead make it as simple as reasonably
> possible so that the basic idea was clear and understandable to everyone.
> Then, if there were any doubts with respect to the basic idea, I'd try to
> clarify them and I'd consider modifying the code to address objections.
> I'd only try to add more features after the basic idea had been accepted.

The basic concept was developed long before android was a public project.

-- 
Arve Hjønnevåg

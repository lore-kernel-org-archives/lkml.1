Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0CDU5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:57:22 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:37598 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab0CDU5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:57:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=boKhnmypZc5fncyk/Tsanvm8tWZ/TX+5hWIsSwCo9hHcYvj4hSktkG+C+30rrF6cj0
         dw4mN5uTe27qiosib7jouYc8eONWU5bAnSQnnBOHnThvJgybdO7EuWRtSh83WhXDBQE3
         TVGzveoMpqm2Rp58TS9dHxgoQHId9Z/pRI6RU=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003041202240.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>
	 <20100304185002.GA23532@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
	 <20100304190450.GA23807@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain>
	 <20100304192524.GA24253@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041131490.3751@localhost.localdomain>
	 <20100304195302.GA24856@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041202240.3751@localhost.localdomain>
Date: Thu, 4 Mar 2010 12:57:19 -0800
Message-ID: <6a89f9d51003041257j39fde3b6y8bd3336d77f7cf7a@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Stephane Marchesin <stephane.marchesin@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 12:07, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 4 Mar 2010, Matthew Garrett wrote:
>>
>> > IOW, we have a real technical problem here. Are you just going to continue
>> > to make excuses about it?
>>
>> I'm not questioning the fact that it would be preferable to provide
>> compatibility. But that compatibility doesn't come for free - someone
>> has to implement it, and when your developer base is almost entirely
>> made up of people who are doing this because they find it fun and
>> interesting rather than because they're paid to, who's going to do it
>> and what functionality is going to be delayed as a result?
>
> The thing is, I violently disagree with your basic premise.
>
> The way things are done now, that developer base actually just makes
> things _harder_ for themselves. They may not be aware that they do so, and
> they may _think_ that it's easier to just ignore versioning, but they are
> wrong.
>
> And I say that from personal experience. Doing incompatible changes in any
> code base makes everything harder. It results in users staying on old
> versions that you _know_ you don't want to support, but because of the
> incompatible change, they can't sanely upgrade.
>
> Seriously.
>
> So I bet we could do that "wrapper nouveau.so" that literally just does
> the "get version, and dlopen the _real_ nouveau-<version>.so".
>
> Quite frankly, I don't know the XAA interfaces (or whatever they are in X
> these days), but somebody who does know them should be able to cook up
> such a wrapper in five minutes (and then spend a day testing it because of
> some silly bug, but whatever..)
>
> Do you seriously think that that wouldn't make life easier EVEN FOR THOSE
> DEVELOPERS that you claim to speak up for?
>

No. It makes our lives much more complicated.

I've worked on the radeon driver before and about half my time was
spent just checking compatibility with multiple kernel/user space
combinations. You have to handle all possible combinations of
DRM+DDX+Mesa drivers, and that gets hairy real quick. Then for nouveau
I decided not to bother until interfaces were stable enough, and I
think all developers agree on that.

I suggest you think about the "do not break user space interfaces"
principle from a graphics developer point of view and what that means
for the user space code. For example, you could take a look at the
radeon DDX or Mesa drivers, which do implement compatibility. In the
long run this leads to little gems like this:
http://cgit.freedesktop.org/mesa/mesa/tree/src/mesa/drivers/dri/r200/r200_state.c#n2148
Obviously even though there is some form of compatibility, not all
user space/kernel combinations are tested.

In short, the "don't break user space interfaces" principle is making
user space code quality worse for everyone. And it makes our lives as
graphics developers pretty miserable actually

Stephane

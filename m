Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab0BDVfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:35:38 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:57983 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab0BDVfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:35:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N88X9JulMay97vipn6eeWBAcvElWQPN3JZvJHggPZXNDaUV7SHWxcynGEL9rJrc4nu
         IGuzkzBXP4mWiO7Pn+ZMJyu/3erjVtrAYvYCSZhPvcEbsaqGxIbIWjvuPiKrKfWvjHb8
         nZyW+KtxWYakqfQHE4eEUc1tuc7OjRG1aAiUg=
MIME-Version: 1.0
In-Reply-To: <20100204132346.85ea0d9f.akpm@linux-foundation.org>
References: <20100204175445.GB27361@elte.hu>
	 <a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com>
	 <20100204190649.GB6665@elte.hu>
	 <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com>
	 <20100204193232.GD6665@elte.hu>
	 <20100204115316.69beee75@jbarnes-piketon>
	 <20100204202254.GA24716@elte.hu>
	 <20100204204829.GA24608@srcf.ucam.org>
	 <20100204210559.GC19050@elte.hu>
	 <20100204132346.85ea0d9f.akpm@linux-foundation.org>
Date: Fri, 5 Feb 2010 07:35:35 +1000
Message-ID: <21d7e9971002041335x34370de5ob03446e6427f65e9@mail.gmail.com>
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch 
	out of staging."
From: Dave Airlie <airlied@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 7:23 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 4 Feb 2010 22:05:59 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
>
>>
>> * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>>
>> > On Thu, Feb 04, 2010 at 09:22:54PM +0100, Ingo Molnar wrote:
>> >
>> > >   " Hey, -rc7 just hung on me after enabling this new .config option it
>> > >     offered for the radeon driver i am using, please add this to the list of
>> > >     regressions. "
>> >
>> > If the same configuration options hang on both an old kernel and a new
>> > kernel, how is that in any plausible way a regression? What's regressed?
>>
>> Regressions are not limited to 'same config' kernels, last i checked. If that
>> has changed (or if i'm misunderstanding it) then it would be nice to hear a
>> clarification about that from Linus.
>>
>> The way i understand it is that there are narrow exceptions from the
>> regression rules, such as completely new drivers for which there can be no
>> prior expectation of stability by users. (but for even them we are generally
>> on the safer side to list bugs in them as regressions as well - especially if
>> we expect many users to enable it.)
>>
>> AFAIK there's no exception for new sub-features of existing facilities or
>> drivers, even if it's default-disabled.
>>
>> This issue materially affects quite a few bugs i'm handling as a maintainer.
>> Many of them are under default-off config options - most new aspects to
>> existing code are introduced in such a way. It would remove quite a bit of
>> urgent-workload from my workflow if i could strike them from Rafael's list
>> and could deprioritize them as "plain bugs", to be fixed as time permits.
>>
>> IMHO it would be rather counter-productive to kernel quality if we did that
>> kind of regression-lawyering though.
>>
>
> Yes, it's mainly semantics.
>
> From the user's point of view
>
> kernel N: boots, works, plays nethack
> kernel N+1: goes splat
>
> That kernel regressed for that user.  He'll shrug and will go back to
> kernel N and we lost an N+1 tester.  And the distros who ship N+1 get a
> lot of hack work to do.

If they used the same .config and it breaks then its a regression
if not its not. both then intel and radeon KMS enable is also quite
clear on the fact that'll it
break your userspace, so I'd hope ppl are reading it.

>
> If the feature is this buggy, it was wrong to make it accessible in Kconfig.

The bug was identified after we enabled the option, we have no record
of a similiar
problem occuring in Fedora or Ubuntu bug trackers, and my future sight
is broken.

>
> Anyway.  The number of DRI regressions which have come in over the past
> few weeks is really quite extraordinary.  We're now showing 31 open
> DRI regressions in bugzilla, but a lot of those are presumably
> defunct.
>
> It's been bad ever since the KMS stuff went in.  That's understandable
> given the magnitude of the change, I guess, but the wheels really seem
> to have falled off in 2.6.32 and 2.6.33.
>

Its not unsurprising, also Intel vs Radeon KMS is an big distinction,
the core KMS
code hasn't seen much in the way of problems its driver related.

The problem is the kernel is now exposed to the sort of things for
years we've had in
userspace, graphics drivers are hard. Add the interactions with ACPI,
crazy BIOS writers,
SMMs, suspend/resume, power management and it just is really really messy.

I know in the Intel driver we've been backing out a lot of the new
features as soon
as we can identify if the hw or sw is at fault and I've been pushing
the Intel guys
to keep on top of the regession list better, hopefully they are doing so.

Also things like the idr change that just bounced in/out broke all of
the GEM drivers
along with AGP changes in the x86 tree that broke shit.

Dave.

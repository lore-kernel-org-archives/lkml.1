Return-Path: <linux-kernel-owner+w=401wt.eu-S934694AbZARRmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934694AbZARRmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 12:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932965AbZARRlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 12:41:52 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:42749 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbZARRlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 12:41:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nnCfadt5y0kLJ7c68f//NWln5XrxHDz3ycThRCRdem1EVIKMd4WjpvhAjY+DiEPBir
         RZrdZOxQ/T9BicN1ktzyhwZJZPq+wD6fPTsP8c+tTjb6OtbgcdLP8RBtr4lGGFqjfyIQ
         PNymdQEoyy5RleAj1rXGV4xtLoMWdnY6mVvuM=
MIME-Version: 1.0
In-Reply-To: <1232296885.3247.17.camel@localhost.localdomain>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
	 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-4-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-5-git-send-email-brgerst@gmail.com>
	 <4972B8AB.8040001@kernel.org>
	 <73c1f2160901172157j6cd731e5s187e98a069a3ab96@mail.gmail.com>
	 <4972C53C.5050509@kernel.org>
	 <73c1f2160901172251t34e824ecue6323ce04fc494e9@mail.gmail.com>
	 <20090118071427.GA29613@elte.hu>
	 <1232296885.3247.17.camel@localhost.localdomain>
Date: Sun, 18 Jan 2009 12:41:50 -0500
Message-ID: <73c1f2160901180941o5ffceaeq3455483cd40fa45f@mail.gmail.com>
Subject: Re: x86/Voyager
From: Brian Gerst <brgerst@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 11:41 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Sun, 2009-01-18 at 08:14 +0100, Ingo Molnar wrote:
>> * Brian Gerst <brgerst@gmail.com> wrote:
>>
>> > On Sun, Jan 18, 2009 at 12:59 AM, Tejun Heo <tj@kernel.org> wrote:
>> > > Brian Gerst wrote:
>> > >> On Sun, Jan 18, 2009 at 12:05 AM, Tejun Heo <tj@kernel.org> wrote:
>> > >>> Hello,
>> > >>>
>> > >>>> --- a/arch/x86/kernel/setup_percpu.c
>> > >>>> +++ b/arch/x86/kernel/setup_percpu.c
>> > >>>> @@ -147,6 +147,9 @@ unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
>> > >>>>  #endif
>> > >>>>  EXPORT_SYMBOL(__per_cpu_offset);
>> > >>>>
>> > >>>> +DEFINE_PER_CPU(int, cpu_number);
>> > >>>> +EXPORT_PER_CPU_SYMBOL(cpu_number);
>> > >>> This is inside CONFIG_HAVE_SETUP_PER_CPU_AREA.  I think voyage would
>> > >>> be unhappy with this change.
>> > >>
>> > >> Is there any specific reason Voyager doesn't use the x86
>> > >> setup_per_cpu_areas() function?  I don't see anything on a quick
>> > >> glance that would not work.  The x86 code is pretty much a superset of
>> > >> the default code in init/main.c.
>> > >
>> > > I have no idea at all.  Given that not many people can test it, I
>> > > figured just leaving it alone would be the best course but if it can
>> > > be merged, all the better.
>> >
>> > Unfortunately Voyager doesn't compile currently for unrelated reasons.
>> >  I'll take a look at incorporating it into these patches, but I can't
>> > even do a compile test right now.
>
> What are "unrelated reasons"?, 2.6.28 compiles and boots for me, except
> some of the compile fixes (which are regressions, by the way) aren't
> included in spite of being sent several times.
>
> I've put them up here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/voyager-2.6.git
>
> I haven't included the cpumask fixes (so it won't compile on 2.6.29-rc2
> yet) because I'll have to try to polish them to fit in with whatever's
> going on.  Plus there's some type of initramfs boot failure that I need
> to investigate.  However, usually I wait until the x86 churn is
> finished, which is a lot later into the -rc cycle than this before
> fixing up all the breakage.
>
>> Peter/James, what's the current status of x86/Voyager cleanups?
>
> The only outstanding problem I can see in 2.6.29 is a cpumask screw up
> caused by Mike Travis ... it looks easily fixable, he just forgot to
> convert voyager.
>
> I have to say that putting the SMP CPU definitions in cpu/common.c
> hedged around with ifdefs for type looks really to be the wrong thing to
> do.  We already have compile selected files with these types, the
> definition should be in there.
>
>> A couple of months ago i made a few suggestions about how to convert
>> Voyager to the cleaner x86_quirks 'quirks HAL' (from the current fragile
>> and hard and expensive to maintain 'compile time HAL'), but it didnt seem
>> to go anywhere. See the discussion of this timeframe:
>>
>>     http://lkml.org/lkml/2008/11/3/53
>>
>> The VisWS subarch (which was a similarly excentric design that was only a
>> PC in terms of having Intel CPUs) has been converted to CONFIG_X86_VISWS
>> already, with arch/x86/kernel/visws_quirks.c holding the optional quirk
>> handlers.
>>
>> The desired end result would be to have a CONFIG_X86_VOYAGER=y build mode
>> that adds the quirk handlers to an otherwise generic kernel, with most of
>> the quirks concentrated into a single arch/x86/kernel/voyager_quirks.c
>> file - instead of having a full subarch for x86/Voyager. Both
>> arch/x86/mach-voyager/ and arch/x86/include/asm/mach-voyager/ would go
>> away in the end - because all functionality is merged into the generic
>> code and the quirks would be in voyager_quirks.c.
>
> You appear to have forgotten that we already had this discussion here:
>
> http://marc.info/?t=122539020300002
>
> But to precis, the bottom line is that I'm concerned about the damage to
> mainline x86 this would cause because voyager is a vastly different
> beast.  We'd be doubling at least the number of function pointer
> indirections, plus the current quirk stuff is inadequate: voyager needs
> boot time separation to handle the unique SUS maps and other things, so
> there'd be a big intrusion into the boot system as well.
>
>> I'd be glad to lend a helping hand both with the patches and with testing
>> on non-Voyager - especially the SMP bits probably need extensions on the
>> x86_quirks side. (And i'm sure the other x86 maintainers would we glad to
>> help out with this process too.)
>>
>> x86/Voyager is the last holdout in this area, and with an active kernel
>> developer like James behind it it ought to be fixable - should James have
>> the time/interest.
>
> But no-one's yet made any argument for why it's a worthwhile thing to be
> doing.
>
>> If there's no time/interest in that then we can temporarily mark Voyager
>> CONFIG_BROKEN until cleanup/fix patches arrive.
>
> It's not broken and I've already sent you the cleanup/fix patches ... I
> can send them directly to Linus as voyager maintainer if you prefer.

The build breakage was due to the cpumask changes I believe, inherited
from -tip.

There is alot of duplicated code in voyager_smp.c that is making it
difficult for me to work on the per-cpu changes.  Do you see any
reason that Voyager can't use the normal x86 setup_per_cpu_areas()
code?

--
Brian Gerst

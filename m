Return-Path: <linux-kernel-owner+w=401wt.eu-S1762471AbZARHOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762471AbZARHOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 02:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbZARHOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 02:14:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57206 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691AbZARHOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 02:14:42 -0500
Date: Sun, 18 Jan 2009 08:14:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <brgerst@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: x86/Voyager
Message-ID: <20090118071427.GA29613@elte.hu>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232115396-26367-1-git-send-email-brgerst@gmail.com> <1232115396-26367-2-git-send-email-brgerst@gmail.com> <1232115396-26367-3-git-send-email-brgerst@gmail.com> <1232115396-26367-4-git-send-email-brgerst@gmail.com> <1232115396-26367-5-git-send-email-brgerst@gmail.com> <4972B8AB.8040001@kernel.org> <73c1f2160901172157j6cd731e5s187e98a069a3ab96@mail.gmail.com> <4972C53C.5050509@kernel.org> <73c1f2160901172251t34e824ecue6323ce04fc494e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73c1f2160901172251t34e824ecue6323ce04fc494e9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Brian Gerst <brgerst@gmail.com> wrote:

> On Sun, Jan 18, 2009 at 12:59 AM, Tejun Heo <tj@kernel.org> wrote:
> > Brian Gerst wrote:
> >> On Sun, Jan 18, 2009 at 12:05 AM, Tejun Heo <tj@kernel.org> wrote:
> >>> Hello,
> >>>
> >>>> --- a/arch/x86/kernel/setup_percpu.c
> >>>> +++ b/arch/x86/kernel/setup_percpu.c
> >>>> @@ -147,6 +147,9 @@ unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
> >>>>  #endif
> >>>>  EXPORT_SYMBOL(__per_cpu_offset);
> >>>>
> >>>> +DEFINE_PER_CPU(int, cpu_number);
> >>>> +EXPORT_PER_CPU_SYMBOL(cpu_number);
> >>> This is inside CONFIG_HAVE_SETUP_PER_CPU_AREA.  I think voyage would
> >>> be unhappy with this change.
> >>
> >> Is there any specific reason Voyager doesn't use the x86
> >> setup_per_cpu_areas() function?  I don't see anything on a quick
> >> glance that would not work.  The x86 code is pretty much a superset of
> >> the default code in init/main.c.
> >
> > I have no idea at all.  Given that not many people can test it, I
> > figured just leaving it alone would be the best course but if it can
> > be merged, all the better.
> 
> Unfortunately Voyager doesn't compile currently for unrelated reasons.
>  I'll take a look at incorporating it into these patches, but I can't 
> even do a compile test right now.

Peter/James, what's the current status of x86/Voyager cleanups?

A couple of months ago i made a few suggestions about how to convert 
Voyager to the cleaner x86_quirks 'quirks HAL' (from the current fragile 
and hard and expensive to maintain 'compile time HAL'), but it didnt seem 
to go anywhere. See the discussion of this timeframe:

    http://lkml.org/lkml/2008/11/3/53

The VisWS subarch (which was a similarly excentric design that was only a 
PC in terms of having Intel CPUs) has been converted to CONFIG_X86_VISWS 
already, with arch/x86/kernel/visws_quirks.c holding the optional quirk 
handlers.

The desired end result would be to have a CONFIG_X86_VOYAGER=y build mode 
that adds the quirk handlers to an otherwise generic kernel, with most of 
the quirks concentrated into a single arch/x86/kernel/voyager_quirks.c 
file - instead of having a full subarch for x86/Voyager. Both 
arch/x86/mach-voyager/ and arch/x86/include/asm/mach-voyager/ would go 
away in the end - because all functionality is merged into the generic 
code and the quirks would be in voyager_quirks.c.

I'd be glad to lend a helping hand both with the patches and with testing 
on non-Voyager - especially the SMP bits probably need extensions on the 
x86_quirks side. (And i'm sure the other x86 maintainers would we glad to 
help out with this process too.)

x86/Voyager is the last holdout in this area, and with an active kernel 
developer like James behind it it ought to be fixable - should James have 
the time/interest.

If there's no time/interest in that then we can temporarily mark Voyager 
CONFIG_BROKEN until cleanup/fix patches arrive.

	Ingo

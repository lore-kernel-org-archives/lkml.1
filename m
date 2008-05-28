Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbYE1DV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbYE1DV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 23:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYE1DVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 23:21:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:17962 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbYE1DVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 23:21:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DwFLSIf9cR6S94LnurFQvqmJ4nC19t5r4ldTABvm163Bi0YYXM2uuKbvjWxacHL4YESB2Ntijax8Fse+E/G2c91bNwU9CxO6ou7DqbUEi7z65lhgLLpVb+FqG6GeqOytloS9HSkOkzDEJRrJxPUqHajXZjlVpafOo/XpXNa8NcA=
Message-ID: <aa79d98a0805272021v7cc73d26p9714d0c5b0b9fc77@mail.gmail.com>
Date: Wed, 28 May 2008 07:21:43 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>, "Sitsofe Wheeler" <sitsofe@yahoo.com>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [REGRESSION][BISECTED][X86] next-20080526 hangs on boot
In-Reply-To: <20080527225042.GG11310@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <g1eg2q$81q$1@ger.gmane.org> <20080526161623.GC7305@cvg>
	 <g1f230$7bl$1@ger.gmane.org> <g1f3ht$b9g$1@ger.gmane.org>
	 <aa79d98a0805262335lf5cd4e1p8f318d45dfe7ff92@mail.gmail.com>
	 <20080527225042.GG11310@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
thanks a lot for checking this!
I'll take a look today evening.

On 5/28/08, Adrian Bunk <bunk@kernel.org> wrote:
> On Tue, May 27, 2008 at 10:35:43AM +0400, Cyrill Gorcunov wrote:
>> On 5/26/08, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
>> > <posted & mailed>
>> >
>> > Sitsofe Wheeler wrote:
>> >
>> > > Cyrill Gorcunov wrote:
>> > >
>> > >> [Sitsofe Wheeler - Mon, May 26, 2008 at 03:04:54PM +0100]
>> > >> | When using a 32 bit linux-next-20080526 the bootup process will
>> > >> hang at
>> > >> | a random point (not even sysrq helps) with no additional output on
>> > >> the
>> > >> | screen (whereas linux-next-20080523 did boot). Mysteriously,
>> > >> booting
>> > >> | with nmi_watchdog=2 allows the boot to finish (booting with
>> > >> | nmi_watchdog=1 still stalls). I have bisected it down to commit
>> > >> | [d1b946b97d71423f365fa797d1428e1847c0bec1]:
>> > >>
>> > >> Hi, so it helps by reverting only that commit? I mean all further
>> > >> commits
>> > >> are still appiled?
>> > >
>> > > Ah that I hadn't tested. I believe I might need to revert
>> > > 4b82b277707a39b97271439c475f186f63ec4692 too if later commits are
>> > > applied
>> > > (but I'm still testing)
>> > >
>> > >> and, btw, could you post your config, please?
>> > >
>> > > http://sucs.org/~sits/test/config-20080526.txt
>> >
>> > OK applying the following patch (which is more or less a revert of
>> > [4b82b277707a39b97271439c475f186f63ec4692]) resolves the problem:
>>...
>>
>> Hi Sitsofe, actually I can't imagine how this revert have helped you
>> from hang. Newly introduced nmi_watchdog_default() didn't change
>> the logic of the code being used before this merge-series.
>>
>> Thomas, Ingo, maybe I've overlooked something (hard to believe ;)?
>> Only the change is the adding of new call for nmi_watchdog_default()
>> which was say 'inlined' before.
>>...
>
> arch/x86/kernel/smpboot.c:native_smp_prepare_cpus() also calls
> the no longer empty nmi_watchdog_default() on 32bit.
>
> cu
> Adrian
>
> --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
>

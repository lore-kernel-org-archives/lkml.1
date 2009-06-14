Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbZFNK4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbZFNK4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbZFNK4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:56:04 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:50237 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbZFNK4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:56:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=P8gXHr2lnKshapHZPh3JLVb/76EsXza7UhO1vP3eClnbZ36Rl703jGodOYqv06Uz2o
         rmEFfCvouazWwWEXiqfK/9T0UV6r9J2QZP1SrMus//Mzwjyl1y/BOaLV63vh+WS2+6OG
         bT62E+mgRCSLNJXUqAnQeSBX9Ut6QDpdSOnDQ=
MIME-Version: 1.0
In-Reply-To: <20090614101111.GG832@linux-sh.org>
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> 
	<8bd0f97a0906130348p474faf57yeb729aa07059c599@mail.gmail.com> 
	<20090614093725.GD832@linux-sh.org> <8bd0f97a0906140255h295b393dl3165fff4c0a6baf6@mail.gmail.com> 
	<20090614101111.GG832@linux-sh.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 14 Jun 2009 06:55:45 -0400
Message-ID: <8bd0f97a0906140355y3661aa89o9a62a89f38fac5a5@mail.gmail.com>
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open 
	when supported
To: Paul Mundt <lethal@linux-sh.org>, akpm <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 06:11, Paul Mundt wrote:
> On Sun, Jun 14, 2009 at 05:55:44AM -0400, Mike Frysinger wrote:
>> On Sun, Jun 14, 2009 at 05:37, Paul Mundt wrote:
>> >> On Fri, Jun 12, 2009 at 07:29, Mike Frysinger wrote:
>> >> If the port does not support HAVE_PERF_COUNTERS, then they can't support
>> >> the perf_counter_open syscall either. ??Rather than forcing everyone to add
>> >> an ignore (or suffer the warning until they get around to implementing
>> >> support), only whine about the syscall when applicable.
>> >
>> > I fail to see why this is necessary? cond_syscall() takes care of this in
>> > the not implemented case, the same as every other syscall backing some
>> > feature that has yet to be implemented.
>>
>> i dont think we should go hassling every arch maintainer when a new
>> syscall is added that requires arch-specific support for optional
>> features (especially when said features are debug in nature).  if
>> wiring up the syscall is the only work because the code is all common
>> (like the pread/pwrite functions), then np of course.
>
> Perhaps not, but I do prefer to have the script whine at me when a new
> syscall pops up, just so I know when I have to start caring about a new
> feature.

assuming you can find any useful info about said feature ;)

> If a generic implementation becomes available, then it can be
> supported without having to backtrack and update place-holders.

this is a good convincing point.  Sam: please drop this patch if you
did get a chance to queue it up.

> These are not things I want to see silenced just because you don't
> presently feel compelled to wire up the entry on your platform.

i disagree, but i guess it doesnt matter if the arch maintainers dont
all agree here.

> Of course if it had been handled properly then the generic software
> counters would have been actually implemented generically and
> subsequently made available from the stub and the HAVE_xxx would be
> reserved for architecture-specific counters. Unfortunately these days
> "generic" generally seems to imply "can be made generic if someone else
> bothers to actually do the work, assuming they can find any documentation
> in the first place".

if we can agree on centralizing arch/Kconfig for HAVE_xxx stubs, we
could add a checkpatch that errors out if said stub lacks a help line
-- the assumption being the help text would point to arch details and
not some other document (design rational, user interface, methodology,
etc...).  of course, this also relies on the assumption of people
filtering via checkpatch.pl ...
-mike

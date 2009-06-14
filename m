Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbZFNLrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbZFNLrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbZFNLr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:47:28 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:39865 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbZFNLr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:47:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=u2JVmR6RmX56a6qrg7fTRfcfYgQiNEGQdDgAFD2h5yrIeDhGYaft2ecH1/g9BZU7VU
         a5gCVsy35f8xPqoEd/UvM8PWokgOpUZ4tMEaaVWk9gDArCHlaraJlpC4bp0E7NtrBhiM
         7qBFCWlnLDQREHKKFYftDg6cti7QgYVcwdW1k=
MIME-Version: 1.0
In-Reply-To: <20090614112002.GA14963@linux-sh.org>
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> 
	<8bd0f97a0906130348p474faf57yeb729aa07059c599@mail.gmail.com> 
	<20090614093725.GD832@linux-sh.org> <8bd0f97a0906140255h295b393dl3165fff4c0a6baf6@mail.gmail.com> 
	<20090614101111.GG832@linux-sh.org> <8bd0f97a0906140355y3661aa89o9a62a89f38fac5a5@mail.gmail.com> 
	<20090614112002.GA14963@linux-sh.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 14 Jun 2009 07:47:10 -0400
Message-ID: <8bd0f97a0906140447v3da94323k413f4319cc06fe53@mail.gmail.com>
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open 
	when supported
To: Paul Mundt <lethal@linux-sh.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 07:20, Paul Mundt wrote:
> On Sun, Jun 14, 2009 at 06:55:45AM -0400, Mike Frysinger wrote:
>> if we can agree on centralizing arch/Kconfig for HAVE_xxx stubs, we
>> could add a checkpatch that errors out if said stub lacks a help line
>> -- the assumption being the help text would point to arch details and
>> not some other document (design rational, user interface, methodology,
>> etc...).  of course, this also relies on the assumption of people
>> filtering via checkpatch.pl ...
>
> arch/Kconfig exists for architecture-specific HAVE_xxx stubs, and ought
> to have some mention of where to look for wiring up said stub. Individual
> features that may or may not be supported by the entire architecture are
> best off defined within the Kconfig they are used in.

off the top of my head, i cant think of any HAVE_xxx stub that doesnt
require some level of arch support.  and since these are things arch
people should be looking at, having them all in arch/Kconfig makes
sense.  although atm, that file seems to also have oprofile options
... but considering what a mess oprofile is in terms of integration
with any piece of the build system, perhaps we should ignore it and
heed it as a warning of how to not do things.

scanning the myriad of options out there shows some variety that
should probably be condensed.  for example, we have:
 - HAVE_xxx - the arch has support for xxx
 - GENERIC_xxx - dual meaning here -- generic support for xxx exists
if you want it, but sometimes it requires the arch to have support for
some piece of xxx first
 - xxx_SUPPORT - the arch has support for xxx
 - ARCH_WANT_xxx - feature xxx exists, iff the arch has support for it
and wants it

i cant think of any place where xxx_SUPPORT shouldnt actually be HAVE_xxx

> Having to hunt down new HAVE_xxx stubs is almost as tedious as having to
> hunt down the required support interface that goes along with them. In
> practice I generally just select HAVE_foo and see where the build blows
> up to figure out what I have to do first. But this of course assumes you
> have some visibility of new HAVE_xxx stubs.

you can search for it with some kconfig interfaces, but in general it
does suck currently.
-mike

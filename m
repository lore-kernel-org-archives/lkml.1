Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZGUPMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZGUPMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZGUPMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:12:47 -0400
Received: from mail-yx0-f202.google.com ([209.85.210.202]:36995 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZGUPMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:12:46 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 11:12:45 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=tTlh15ODZeJL2ZSnaWlK9w10k/ebKGo64+aXdo3apvFEjjy+spR+oRobisDk2kco+V
         Ey9O4LP5tSdyB56i4C8v2OfdXY3SbzdF3MUOagbM/MjxobW2LvzyBvRsd8YEO4ksSJDd
         PMSk/vki08RDMvDi7TLsSFS7aLkVNv7gOS8A0=
MIME-Version: 1.0
Reply-To: john.lanza@linux.com
In-Reply-To: <19045.48361.502946.399660@samba.org>
References: <19013.8005.541836.436991@samba.org>
	 <1247066878.4159.153.camel@mulgrave.site>
	 <20090708163736.0f98e7e0@lxorguk.ukuu.org.uk>
	 <1247069202.4159.212.camel@mulgrave.site>
	 <20090708171848.21633768@lxorguk.ukuu.org.uk>
	 <873a96a23x.fsf@devron.myhome.or.jp>
	 <87hbxhwv0j.fsf@devron.myhome.or.jp>
	 <19045.14307.658887.752950@samba.org> <4A65875D.7030902@panasas.com>
	 <19045.48361.502946.399660@samba.org>
Date: Tue, 21 Jul 2009 11:06:38 -0400
Message-ID: <4bbed3f70907210806v14690311wbd579acae44099a9@mail.gmail.com>
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
From: John Lanza <jdlanza@gmail.com>
To: tridge@samba.org
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I understand the proposal (which I think I do), Tridge is correct.
If a patent prohibits a system from performing steps "A" and "B",
simply separating the steps into separate modules, or utilities, won't
avoid infringement.

I'm happy to answer specific questions, but it might be best to do
that separately from lkml.

johnl

On Tue, Jul 21, 2009 at 9:04 AM, <tridge@samba.org> wrote:
> Hi Boaz,
>
>  > I guess you tried putting a zero at first char and it breaks everybody?
>
> It works with some devices, but with many it doesn't. A space followed
> by a nul works with quite a lot of devices, but not enough (the last
> patch used a space followed by a nul).
>
> I went to a large electronics store and told them I wanted to buy
> devices that didn't work with my computer. They were very helpful, and
> as a result I was able to test a lot of devices. That is what led to
> the design of this patch (plus the feedback from people like Jan and
> his IOneIt MP3 player).
>
>  > I guess (35^6)*8*7 is not that bad
>
> yes, but luckily For the WinXP bluescreen the probability of the crash
> is actually much lower than that figure would give. With the same
> modelling assumptions of WinXP memory slots for 8.3 entries that Paul
> used for the last patch, it comes out as less than a 1 in 10k chance
> for a full directory (ie. 32767 long filenames). For 100 files in a
> directory it is around 1 chance in 10^11. I'm sure Paul will do the
> full expansion and modelling if anyone wants more precise numbers.
>
> For the chkdsk rename, the probability is much easier to calculate as
> it is just the usual birthday expansion (see wikipedia for simple
> formula for that). That is what gives 0.5% for 32767 files in a
> directory, and 4.8x10^-8 for for 100 files.
>
> Basically it won't happen very often. In each case the probability is
> rougly 75x less than it was for the last patch.
>
>  > What if we had a user mode utility that does these short-names
>  > renames that a user can optionally run after umount? since it
>  > only writes the (random) short-names it's also safe.
>
> While I will defer to John Lanza if you want a more complete legal
> view on this, I think it is likely that separating the steps of the
> patent between programs within one system is not a safe enough legal
> strategy to be used.
>
> Please do keep thinking about it though. There could well be some
> simple combination which is legally safe and also technically
> completely satisfactory. If you think you have hit on a winner, you
> may wish to discuss it with John Lanza in private first though, so it
> can be fine tuned before being presented publicly.
>
> Cheers, Tridge
>

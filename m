Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbZGRTL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbZGRTL0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 15:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbZGRTLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 15:11:25 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:55953 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbZGRTLY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 15:11:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=B/UXztmW4z+z7ud6nz5ynkJl+b/xmHjRtCGFSDVmYUX6B2CfUfmoVVLD18Kqbo/XyY
         4ljFRrxIWV2OHyKhMzqqj5DDyLiakJ1V7+sKOtZOgMBPEnzCUOFp3RJW2S50DzD0XutQ
         iCICl/ims9smWduab7mtkuW3AHwpPHVLNOG4g=
MIME-Version: 1.0
In-Reply-To: <20090718103935.GB11381@elf.ucw.cz>
References: <20090709101930.GJ10937@elf.ucw.cz> <20090704024606.GE1345@ucw.cz> 
	<20090701120814.30741.10146.stgit@warthog.procyon.org.uk> 
	<24530.1247050900@redhat.com> <20090704033429.GA1799@ucw.cz> 
	<8bd0f97a0907081148vc716eeepfdaf8178b1ecbce1@mail.gmail.com> 
	<24280.1247137151@redhat.com> <20090711213018.GA1425@ucw.cz> 
	<8bd0f97a0907140515t2bc47674qac75ba93f8c9fdae@mail.gmail.com> 
	<20090718103935.GB11381@elf.ucw.cz>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 18 Jul 2009 15:11:04 -0400
Message-ID: <8bd0f97a0907181211p14881138j93930037529bff67@mail.gmail.com>
Subject: Re: [PATCH] FDPIC: Ignore the loader's PT_GNU_STACK when calculating 
	the stack size
To: Pavel Machek <pavel@ucw.cz>
Cc: David Howells <dhowells@redhat.com>, rgetz@blackfin.uclinux.org,
       lethal@linux-sh.org, gerg@uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 06:39, Pavel Machek wrote:
> On Tue 2009-07-14 08:15:03, Mike Frysinger wrote:
>> On Sat, Jul 11, 2009 at 17:30, Pavel Machek wrote:
>> > On Thu 2009-07-09 11:59:11, David Howells wrote:
>> >> Pavel Machek wrote:
>> >> > > i really dont think this is realistic.  there is exactly one ldso that
>> >> > > everyone uses under FDPIC ELF, and it needs a very minuscule stack.
>> >> >
>> >> > Not very realistic; but that argues that the patch is NOP.
>> >> >
>> >> > And if it _is_ realistic, the patch adds a bug.
>> >>
>> >> No, it doesn't.  The problem is that the loader, when it is linked, is given a
>> >> sillyly large default stack size, and this causes the application to be given a
>> >> much larger stack than is strictly necessary - a stack that is drawn from a
>> >> limited pool of non-pageable RAM and that must be allocated as a contiguous
>> >> lump.
>> >
>> > Fix the loader to only request as big stack as it needs?
>>
>> and what if the loader needs a larger stack when run as an application
>> ?  you could make the same exact argument for every library that an
>> application has a DT_NEEDED tag for, or that it dlopen()'s.  but for
>> the same reasons, it doesnt fly.
>>
>> the only stack that should be checked is what the application itself
>> says it needs.  the ldso has no way of knowing what functions exactly
>> the application in question will be using (whether in the ldso itself
>> or in any library), thus only the application itself knows what the
>> stack usage will look like.
>
> And the application has no way of knowing how much stack this
> particular ldso needs. Too bad, it is all broken.

you're still wrongly assuming the ldso has any idea of what functions
the application will be invoking.  in the nommu embedded world (which
is the *only* place this change matters), reduced stack sizes are not
picked out of a hat.  they're taken based on actual testing/review for
a particular setup.  along that same line, upgrading of complete
systems (kernel/userspace/toolchain) arent dropped in casually -- this
kind of reduced stack review would occur again.  your concern is not
realistic in any way nor applicable in any scenario that matters.
-mike

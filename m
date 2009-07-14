Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbZGNMPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbZGNMPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 08:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZGNMPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 08:15:24 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:37494 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZGNMPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 08:15:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=g0PM86gWjNJcekoY2PEQa8tEnlX/jvjqFd17BLBzPBBC/T8yG1SAXBZ+fGy4/MVJYL
         Yfofavk27vE8JpZf2z5yvioN+t+OqaW+5/fI68htYx8CTusTQTP8zNF0xWBKxIu0kdua
         Lyk25z8Z82faH+6Snk6d+lcx3tJFOlkli4GJY=
MIME-Version: 1.0
In-Reply-To: <20090711213018.GA1425@ucw.cz>
References: <20090709101930.GJ10937@elf.ucw.cz> <20090704024606.GE1345@ucw.cz> 
	<20090701120814.30741.10146.stgit@warthog.procyon.org.uk> 
	<24530.1247050900@redhat.com> <20090704033429.GA1799@ucw.cz> 
	<8bd0f97a0907081148vc716eeepfdaf8178b1ecbce1@mail.gmail.com> 
	<24280.1247137151@redhat.com> <20090711213018.GA1425@ucw.cz>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 14 Jul 2009 08:15:03 -0400
Message-ID: <8bd0f97a0907140515t2bc47674qac75ba93f8c9fdae@mail.gmail.com>
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

On Sat, Jul 11, 2009 at 17:30, Pavel Machek wrote:
> On Thu 2009-07-09 11:59:11, David Howells wrote:
>> Pavel Machek wrote:
>> > > i really dont think this is realistic.  there is exactly one ldso that
>> > > everyone uses under FDPIC ELF, and it needs a very minuscule stack.
>> >
>> > Not very realistic; but that argues that the patch is NOP.
>> >
>> > And if it _is_ realistic, the patch adds a bug.
>>
>> No, it doesn't.  The problem is that the loader, when it is linked, is given a
>> sillyly large default stack size, and this causes the application to be given a
>> much larger stack than is strictly necessary - a stack that is drawn from a
>> limited pool of non-pageable RAM and that must be allocated as a contiguous
>> lump.
>
> Fix the loader to only request as big stack as it needs?

and what if the loader needs a larger stack when run as an application
?  you could make the same exact argument for every library that an
application has a DT_NEEDED tag for, or that it dlopen()'s.  but for
the same reasons, it doesnt fly.

the only stack that should be checked is what the application itself
says it needs.  the ldso has no way of knowing what functions exactly
the application in question will be using (whether in the ldso itself
or in any library), thus only the application itself knows what the
stack usage will look like.
-mike

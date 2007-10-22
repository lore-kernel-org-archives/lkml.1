Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbXJVIA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbXJVIA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 04:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbXJVIAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 04:00:14 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:55365 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbXJVIAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 04:00:12 -0400
X-Greylist: delayed 3389 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2007 04:00:12 EDT
Date: Mon, 22 Oct 2007 03:58:04 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: WANG Cong <xiyou.wangcong@gmail.com>
cc: Sam Ravnborg <sam@ravnborg.org>, Nix <nix@esperi.org.uk>,
       Al Viro <viro@ftp.linux.org.uk>, Jeff Dike <jdike@addtoit.com>,
       Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
In-Reply-To: <20071022074823.GJ2998@hacking>
Message-ID: <Pine.LNX.4.64.0710220356470.5772@localhost.localdomain>
References: <20071021114854.GF2455@hacking> <20071021130848.GA4621@c2.user-mode-linux.org>
 <20071021132031.GI2455@hacking> <20071021154346.GW8181@ftp.linux.org.uk>
 <20071022043746.GF2998@hacking> <20071022052214.GY8181@ftp.linux.org.uk>
 <20071022061245.GG2998@hacking> <87d4v7fy5i.fsf@hades.wkstn.nix>
 <20071022065202.GI2998@hacking> <20071022065943.GC10864@uranus.ravnborg.org>
 <20071022074823.GJ2998@hacking>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-379407579-1193039884=:5772"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-379407579-1193039884=:5772
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 22 Oct 2007, WANG Cong wrote:

> On Mon, Oct 22, 2007 at 08:59:43AM +0200, Sam Ravnborg wrote:
> >On Mon, Oct 22, 2007 at 02:52:02PM +0800, WANG Cong wrote:
> >> On Mon, Oct 22, 2007 at 07:42:33AM +0100, Nix wrote:
> >> >On 22 Oct 2007, WANG Cong uttered the following:
> >> >> I build UML for non-SMP x86. But I don't know about UML_NET_VDE. ;(
> >> >>
> >> >> Errors threw out by gcc (too many) are put here:
> >> >> =09http://wangcong.org/down/errors.txt
> >> >
> >> >It's hard to tell without LOCALE=3DC, but those are the sorts of resu=
lts
> >> >I'd expect if you had run make {old,menu,x}config without specifying
> >> >ARCH=3Dum, so you've configured for one architecture and are now tryi=
ng
> >> >to build another.
> >> >
> >> >Where is the include/asm symlink pointing to in your build tree?
> >>
> >> $ ls -l include/asm
> >> lrwxrwxrwx 1 wangcong wangcong 6 2007-10-22 12:34 include/asm -> asm-u=
m
> >>
> >> OK. Let me do the following:
> >>
> >> =09$ make mrproper
> >
> >Please try
> >make ARCH=3Dum mrproper
> >
> >this will clean up the additional uml symlinks.
> >
>
> Hi, Sam, Al and others.
>
> I just followed what Sam told me, errors are much fewer this time,
> but still exist. Error messages are:
>
>   CC      arch/um/kernel/syscall.o
>   CC      arch/um/kernel/sysrq.o
> arch/um/kernel/sysrq.c: In function =FF=FFshow_stack=FF=FF:
> arch/um/kernel/sysrq.c:63: error: =FF=FFUESP=FF=FF undeclared (first use =
in this function)
> arch/um/kernel/sysrq.c:63: error: (Each undeclared identifier is reported=
 only once
> arch/um/kernel/sysrq.c:63: error: for each function it appears in.)
> make[1]: *** [arch/um/kernel/sysrq.o] Error 1
> make: *** [arch/um/kernel] Error 2
>
> Or I missed something again?
>
> And I use `make defconfig ARCH=3Dum' to generate .config, my tree
> is 2.6.23-git16 (Al, is this OK?).

that looks like a cut-and-paste error since the file
include/asm-um/arch/ptrace-abi.h opens with:

=3D=3D=3D=3D=3D
#ifndef _ASM_X86_PTRACE_ABI_H
#define _ASM_X86_PTRACE_ABI_H

#ifdef __i386__

#define EBX 0
#define ECX 1
#define EDX 2
#define ESI 3
#define EDI 4
#define EBP 5
#define EAX 6
#define DS 7
#define ES 8
#define FS 9
#define GS 10
#define ORIG_EAX 11
#define EIP 12
#define CS  13
#define EFL 14
#define UESP 15
=2E....
=3D=3D=3D=3D=3D

  somehow, that doesn't look right.

rday
--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--8323328-379407579-1193039884=:5772--

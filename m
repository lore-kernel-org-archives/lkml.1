Return-Path: <linux-kernel-owner+w=401wt.eu-S932646AbZJFN5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbZJFN5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932624AbZJFN5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:57:18 -0400
Received: from relay02-haj2.antispameurope.com ([83.246.65.52]:34496 "EHLO
	relay02-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932553AbZJFN5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:57:17 -0400
Date: Tue, 06 Oct 2009 15:55:09 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: Valdis.Kletnieks@vt.edu, shawn.starr@rogers.com
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PROBLEM][2.6.31.1] - Cannot burn DVDs - PIONEER DVD-RW DVR-111D
Message-ID: <4acb4c3d.raY4eflQX5iCgb7k%Joerg.Schilling@fokus.fraunhofer.de>
References: <4ac9d477.7gleZfWVJq3++UDn%Joerg.Schilling@fokus.fraunhofer.de>
 <4aca7014.bWkj1S1Z6N2kt4dr%Joerg.Schilling@fokus.fraunhofer.de>
 <188185.1254800635@turing-police.cc.vt.edu>
 <200910060335.02770.shawn.starr@rogers.com>
In-Reply-To: <200910060335.02770.shawn.starr@rogers.com>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Oct 2009 13:56:32.0021 (UTC) FILETIME=[CF445C50:01CA468C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn Starr <shawn.starr@rogers.com> wrote:

> On October 2, 2009 10:46:49 am Jeff Garzik wrote:
> On October 5, 2009 11:43:55 pm Valdis.Kletnieks@vt.edu wrote:
> > On Tue, 06 Oct 2009 00:15:48 +0200, Joerg Schilling said:
> ...
> > 
> > > You can help: Ask your Linux distributor why he distributes an illegal
> > > and buggy fork instead of the legal original software!
> > 
> > Apparently it's distributed because their legal team doesn't think it's an
> > illegal fork, and it's still buggy because after you relicensed to CDDL,
> >  they felt they couldn't backport your fixes to the original GPL code.
> > 
>
> Listen, I don't care about that who forked what. if wodim or cdrecord is 
> broken in design, then it's time for a cdrecord-ng and start over please.  I 
> don't want to see this bickering anymore.

As mentioned already, wodim is based on a 4+ year old cdrecord source with 
wodim specific bugs added but with not a single additional feature or bug fix 
related to the original software.

I cannot understand why some Linux distibutors still believe that their users 
accept to be forced to use broken forked software while working original 
software with even many new features is available for free.


> We're just damaging users. We really should not be rehashing CD/DVD burning 
> issues over again when there's much, much more pressing issues that need to be 
> fixed.

You could try to help convincing the Linux distributors. The problem with the
hostile downstream started more than 5 years ago, it is sad to see that there is
no mechanism in the OSS world to reliably recover from problems that have been 
caused by hostile downstreams.

> Joerg, For one thing, I want to be able to access the burner devices with 
> their proper /dev name. Just like any other sane unix tool like, even dd. (you 
> used to resist this idea if I remember correctly on MLs) not the SCSI bus IDs, 
> honestly, what are you trying to achieve here?? make it EASY for users, not 
> harder.

You ask me to do something that is not granted to work and that is not compliant
with the ANSI-X10t3 standard. You ask me this although there is absolutely no 
need for a change as the current implementation of cdrecord works nicely on 30
platforms.

------------important-------------->
As cdrecord implements the "auto-target" feature since August 2006 (since 
November 2006 even for Linux), 99% of the users do not need to care about the 
dev= option anymore at all. These users have one single drive that is detected 
automatically by cdrecord and libscg in case you simply omit dev=.
<------------important--------------

Note that cdrecord depends on libscg which is the oldest and most portable 
generic SCSI pass though implementation I am aware of (I wrote the first 
version for SunOS in August 1986). Today (if you count all Microsoft operating 
systems as one only), libscg supports 30 different operating systems. 

Only 9 (counting NetBSD/OpenBSD/DragonFly separately) of the 30 supported 
operating systems allow to specify /dev/something at all for sending SCSI 
commands.

4 of the latter (including FreeBSD) implement the ANSI X10t3 CAM standard that
defines the same addressing scheme as libscg uses.

Even though people believe that Mac OS X is a "UNIX variant", it does not 
implement /dev/* interfaces but something relly strange (see "DeviceKIT"). 

As you see, using /dev/* is only possible on a minority of the supported 
plaforms, so depending on /dev/* is definitely a mistake. As we all know that 
even on Linux, the name of the related /dev/* entries to access the drives 
changed many times in the past, cdrecord is bringing you stability on top of a 
changing platform. Even if dev=/dev/* _may_ work for some of the supported 
devices on Linux, I cannot grant you that it will work in the future.

> Also, maybe if you cooperated a little better we can clean up this stinking 
> pile of mess. 

If you like to address the speudo problems that are mentioned by some Linux 
users, this is obviouyls mainly a missunderstanding of the general constraints
in the background by some people who do know nothing but Linux.

If we look at GNOME, it is unfortunately also a problem of a GUI that likes to 
be portable but that does not look at other possible target platforms while
defining to use Linux only interfaces for important tasks (thus causing 
portability problems). I hope that this is a problem that can be solved by 
talking with each others....

If we look at hald (the Linux variant), this is an application that mainly 
implements an incorrect strategy in order to detect media changes and as a 
result of this incorrect strategy, it interrupts the burning process. These 
problems also could have been avoided if the authors of the Linux hald did ask
me _before_ implementing. It still could be fixed now.

I am cooperating with all people who also like to cooperate and I e.g. annunce 
interface changes for cdrtools to my known "users" (i.e. authors of GUIs and 
other front ends for the cdrtools) at least 3-5 years before I implement them.
I hope that for the future we can again have a good cooperation with the Linux 
kernel development (as we had before ~ 2001).

BTW: As we are on the topic, I would like e.g. to see Linux supporting hard 
links on ISO-9660+Rockridge. Any interest in implementing it? I did make the
implementation for Solaris in 2006, so it would be easy to implement it for 
Linux by just looking at my Solaris "hsfs" implementation.

PP.S. I would also like to see Linux to support the sparse file interface I 
defined together with Sun in 2004. This interface is based on lseek whence
values SEEK_HOLE and SEEK_DATA and on *pathconf(*, _PC_MIN_HOLE_SIZE);
This allows star to create 100% correct copies of sparse files.

In case you don't know: while GNU tar does not implement a single Linux specific
feature, star does implement many Linux specific features.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       joerg.schilling@fokus.fraunhofer.de (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/private/ ftp://ftp.berlios.de/pub/schily

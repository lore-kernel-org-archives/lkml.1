Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZGBJg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZGBJg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbZGBJgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:36:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61310 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZGBJgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:36:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Williams <john.williams@petalogix.com>
Subject: Re: [microblaze-uclinux] [PATCH 03/11] microblaze: fall back on generic header files for the ABI
Date: Thu, 2 Jul 2009 11:36:05 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       John Linn <John.Linn@xilinx.com>, Michal Simek <monstr@monstr.eu>
References: <cover.1245345894.git.arnd@arndb.de> <4A4B49D0.2090101@monstr.eu> <1d3f23370907011552h5b3c96b9h208d5567e7a2a615@mail.gmail.com>
In-Reply-To: <1d3f23370907011552h5b3c96b9h208d5567e7a2a615@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907021136.07426.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+iSduROZ7xSov1lzImdx6eD3Qd3dUHHvq66N8
 PeHuM5QBHAR4YHsTbZJsZvr8sD24MKZacO/CRrkC3EmqOAYQXc
 NBFDmdVbVP4vvZc6UXI5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 July 2009, John Williams wrote:
> However, we've just "broken" the ABI in 2.6.31, if we merge further
> ABI breakage in 2.6.32 it's more pain and confusion.
> 
> So, unless we can merge and validate this ABI breakage during the
> 2.6.31-rc cycle, I think we need to hold on changes that would break
> the ABI again, so soon.
> 
> Longer term there will be a complete redo of glibc up to the latest
> version, which will obviously require a new toolchain for users - I
> think that is the right place to do the next round of ABI breakage.
> 
> Any thoughts?

Normally the rule is to never break the ABI at all, even in a major
update of glibc.

Initially I had hoped that we could do the change before 2.6.30 and
I worked hard on getting the ABI patches to you early enough for
that. After that failed, I made sure that you had everything in
place for 2.6.31 and I believed that Michal said he would integrate
that in the microblaze-mmu merge, before you actually start seeing
users on the mainline kernel.

If we don't get that into 2.6.31 any more (and the chances
have slimmed down a lot after the end of the merge window), I
think we should just declare complete failure and not touch
the ABI any more, however broken it may be. 

In over 14 months, not even the most basic fixes to the ABI
that I mentioned in the first review have been applied:

On Tuesday 15 April 2008, Michal Simek wrote:
> Arnd Bergmann wrote:
> > * Your syscall ABI is largely obsolete. A third of the syscalls you
> > define should not even be there in the first place as they have been
> > replaced by newer versions. E.g. you have select, _newselect and pselect6,
> > where just pselect6 would be sufficient -- you don't need to worry about
> > backwards compatibility if you don't have existing code. A good start
> > would be to take the arch/blackfin syscall list and further reduce it
> > from there. Further examples are:
> > - replace socketcall with separate syscall entry points
> > - replace ipc with a separate entry points
> > - remove all the legacy signal handling from arch/microblaze/kernel/signal.c
> > - remove sys_mmap, sys_olduname and sys_vfork
> > - finally define a generic sys_mmap2 and sys_uname in kernel/ so you don't
> >   need another copy in arch/microblaze/kernel
> > - Use 64 bit off_t, and 32 bit uid_t, gid_t etc.
> 
> This kernel don't need to keep backward compatibility. No one will port to
> previous version. I'll look at your points and I'll send you what I do.

	Arnd <><

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbZIHMzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbZIHMzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 08:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZIHMzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 08:55:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55058 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbZIHMzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 08:55:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: asm-generic update candidates?
Date: Tue, 8 Sep 2009 14:55:45 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-9-generic; KDE/4.3.1; x86_64; ; )
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200909031729.52538.rgetz@blackfin.uclinux.org> <200909041532.50456.arnd@arndb.de> <200909041539.28384.rgetz@blackfin.uclinux.org>
In-Reply-To: <200909041539.28384.rgetz@blackfin.uclinux.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200909081455.45576.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18CaMROAK99mzJsvmuYH6LnQDY4S8uiAS7Wzoh
 MTgQDhTR6wMtRrYLHW1UXa4dyZjVShEQsVIsggW9Yz6aVNw8r0
 1geU1Rj+93Ab6G2UkQp8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 September 2009, Robin Getz wrote:
> On Fri 4 Sep 2009 09:32, Arnd Bergmann pondered:
> > On Thursday 03 September 2009, Robin Getz wrote:
> > Also, my plan is to do one architecture at a time,
> 
> Which arch are you starting with?

I've done patches for microblaze, powerpc and x86, and some arch
maintainers have done more. I'd probably do s390 next and see who
else is submitting patches for their architectures in 2.6.32,
then work on those remaining. Feel free to grab any one whose
maintainer you can get hold of.

> > > Do you keep a list somewhere?
> > 
> > Well, this is how I started out writing doing the common files
> > in the first place. I looked at the most similar files, and then
> > used vimdiff on up to four files at a time, changing them to
> > be exactly identical by editing out all the bitrot.
> > 
> > In general, if a file exists in asm-generic, it should be usable
> > by some of the architectures, if it does not exist then either it
> > is too hard to make a generic version or I have not looked at it
> > yet.
> 
> OK -- here are some identical ones:
> 
> 8253pit.h (alpha and power)

PIT is interesting, there is also 8253.h in some architectures.
This could use a larger rework, I've started on bits of it
and should probably look which patches are still needed.

> fbio.h    (m68k and sparc)

It seems that m68k FB_SUN3 support was removed a long time ago,
so this one is really just sparc specific.

> md.h      (h8300, alpha and m68k)

This file does not appear to be used at all, we should probably
remove it.
 
> I also noticed in Linus's latest (last commit 
> 37d0892c5a94e208cf863e3b7bac014edee4346d):
> 
> cat arch/microblaze/include/asm/ipc.h
> #include <asm-generic/ipc.h>
> 
> but: ls include/asm-generic/ipc.h
> ls: cannot access include/asm-generic/ipc.h: No such file or directory

Adrian Bunk killed that file in asm/ back in 2007, he probably crossed
patches with the microblaze architecture.

	Arnd <><

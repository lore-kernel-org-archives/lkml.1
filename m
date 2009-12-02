Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZLBVjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZLBVjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 16:39:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbZLBVjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 16:39:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51481 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbZLBVjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 16:39:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lior Dotan <liodot@gmail.com>
Subject: Re: Linux 2.6.32-rc8 - T500 fails to suspend to RAM
Date: Wed, 2 Dec 2009 22:39:05 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <4B151FE2.3090807@gmail.com> <200912012246.58383.rjw@sisk.pl> <4B166032.8050005@gmail.com>
In-Reply-To: <4B166032.8050005@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912022239.05528.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 December 2009, Lior Dotan wrote:
> Rafael J. Wysocki wrote:
> > On Tuesday 01 December 2009, Lior Dotan wrote:
> >   
> >> Hi,
> >>
> >> Ever since I've upgraded to rc8, my T500 fails to suspend to RAM for the
> >> second time. Suspending for the first time works ok but when I resume and
> >> later try to suspend again the screen gets blank and the moon LED blinks
> >> forever. rc6 & rc7 as well as 2.6.31 worked great with out a problem.
> >>     
> >
> > Well, I don't see any particular change that might cause the symptoms you
> > describe between -rc7 and -rc8.  If this is 100% reproducible, I guess
> > bisecting is the only option at the moment.
> >   
> I tried bisecting it, not sure if it's any good but this is what I got:

Thanks for the effort.

> ldot@topaz ~/linux/linux-2.6 $ git bisect bad
> Bisecting: 0 revisions left to test after this (roughly 0 steps)
> [1456edbb1476db735715ddcc7ac306de587024eb] kconfig: Make zconf.y work 
> with current bison
> ldot@topaz ~/linux/linux-2.6 $ git bisect log
> git bisect start
> # bad: [648f4e3e50c4793d9dbf9a09afa193631f76fa26] Linux 2.6.32-rc8
> git bisect bad 648f4e3e50c4793d9dbf9a09afa193631f76fa26
> # good: [156171c71a0dc4bce12b4408bb1591f8fe32dc1a] Linux 2.6.32-rc7
> git bisect good 156171c71a0dc4bce12b4408bb1591f8fe32dc1a
> # bad: [b6b24c73d56a166a829318a1f06803ff9b54857b] spi: error status 
> should be negative
> git bisect bad b6b24c73d56a166a829318a1f06803ff9b54857b
> # bad: [82abc2a97a4a3c7635c40e6dff571816062ec506] Merge branch 
> 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2
> git bisect bad 82abc2a97a4a3c7635c40e6dff571816062ec506
> # good: [24dfb2b5867df24ba03b6c4418312e23b1300aa8] Merge branch 
> 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus
> git bisect good 24dfb2b5867df24ba03b6c4418312e23b1300aa8
> # bad: [e8e63cbf9a339c972eeb5ccf8777c8067bdfd869] oss: Mark loadhex 
> static in hex2hex.c
> git bisect bad e8e63cbf9a339c972eeb5ccf8777c8067bdfd869
> # bad: [ad0cd62ab632afe9b562b5f09343c21e1521505d] 
> arch/alpha/boot/tools/objstrip.c: Mark "usage" static
> git bisect bad ad0cd62ab632afe9b562b5f09343c21e1521505d
> # bad: [65166571800af0f63f21e5576d7db12d2bf73790] kconfig: Mark various 
> internal functions static
> git bisect bad 65166571800af0f63f21e5576d7db12d2bf73790

This commit is not very likely to be the source of the issue.

Perhaps one of the commits you marked as 'good' was in fact a bad one.

Best,
Rafael

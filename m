Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbXGODvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbXGODvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 23:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXGODvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 23:51:47 -0400
Received: from [212.12.190.78] ([212.12.190.78]:32819 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752682AbXGODvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 23:51:46 -0400
From: Al Boldi <a1426z@gawab.com>
To: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 0/3][try 1] init: enable system-on-initramfs
Date: Sun, 15 Jul 2007 08:24:20 +0300
User-Agent: KMail/1.5
References: <8GGkX-2Xv-5@gated-at.bofh.it> <E1I9mgG-0000jf-1y@be1.lrz>
In-Reply-To: <E1I9mgG-0000jf-1y@be1.lrz>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707150824.20490.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> On Sat, 14 Jul 2007, H. Peter Anvin wrote:
> > Bodo Eggert wrote:
> > > On Sat, 14 Jul 2007, H. Peter Anvin wrote:
> > >> Bodo Eggert wrote:
> > >>> Setting the name of the rdinit process to the name of the init
> > >>> process in order to select the root device should not be the right
> > >>> knob.
> > >>
> > >> What's wrong with it?
> > >
> > > rdinit is supposed to be the program that mounts, root is supposed to
> > > be whatever is mounted and init is supposed to run the system. Three
> > > different things. Now if you want to change the third, just set the
> > > first to the second ...
> >
> > That only applies to a model that you explicitly doesn't want to use.
>
> I don't want to use rdinit, because there is no task for rdinit(3), and I
> don't want to mount a filesystem(3). But I do want to use init(2).
>
> I have to lie to the kernel saying (2) is (1) in order to trick it into
> beleaving I'd do (3) myself, which I don't, just in order to not do (3).
> If the bug of not calling the security hook would be fixed, this trick
> would use the path where rdinit is expected to trigger the callback, but
> since that rdinit would be no rdinit, that callback would still be wrongly
> skipped. That would not be a bad thing for my setup, but it clearly shows
> this setup to be wrong.
>
> The correct solution is tell the kernel not to do (3) if you don't want
> it to do (3). The rest will work as intended.

Sounds rather confusing.

This is how I see it:

  initrd=initrd.img.gz implies root=rootfs
  rdinit=/bin/sh is the special init=/bin/sh for initrd.

Both initrd/root and rdinit/init must be separate for pivoting to succeed.  
If you want to drop into the initrd (i.e. rootfs), then instruct your 
initrd.img.gz not to pivot (i.e. not over-mount another filesystem).


Thanks!

--
Al


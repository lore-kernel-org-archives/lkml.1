Return-Path: <linux-kernel-owner+w=401wt.eu-S1762874AbXH3WGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762874AbXH3WGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbXH3WF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:05:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:35567 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754817AbXH3WF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:05:57 -0400
X-Authenticated: #12383568
X-Provags-ID: V01U2FsdGVkX19gZ+J7PhZgM1OQikvVBdq1zJci62nhuH2klJ3ktz
	m0HXE7z+kgYTkd
From: Clemens Kolbitsch <clemens.kol@gmx.at>
To: Valdis.Kletnieks@vt.edu
Subject: Re: Forbid deletion of memory mappings
Date: Fri, 31 Aug 2007 00:05:53 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200708301844.10532.clemens.kol@gmx.at> <200708302341.09459.clemens.kol@gmx.at> <30071.1188510621@turing-police.cc.vt.edu>
In-Reply-To: <30071.1188510621@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708310005.53587.clemens.kol@gmx.at>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 August 2007 23:50:21 Valdis.Kletnieks@vt.edu wrote:
> On Thu, 30 Aug 2007 23:41:09 +0200, Clemens Kolbitsch said:
> > On Thursday 30 August 2007 23:34:52 you wrote:
> > > On Thu, 30 Aug 2007, Clemens Kolbitsch wrote:
> > > > is there no way to tell the kernel, that a certain mapping must not
> > > > be removed, no matter what (except of course an explicit call to
> > > > sys_unmap, of course)?
> > >
> > > I don't seem to get what is the issue here. Your mapping is not
> > > removed, only the VMAs are merged together into one larger VMA if they
> > > have neighbouring address ranges and compatible protection bits. See
> > > vma_merge().
> >
> > the thing is that they are not. the kernel chooses to REPLACE my mapping.
> >
> > consider the user-space code:
> >
> > mmap(0xaaaa0000, 0x3000, MAP_FIXED, ...);
> > mmap(0xaaaa1000, 0x4000, MAP_FIXED, ...);
> >
> > here, the second call to mmap will shorten the first mapping to 0x1000
> > bytes and create one big vma with size 0x5000 bytes.
> >
> > is there a way to tell it that the second mmap MUST fail?
>
> There's an LSM exit point for mmap, you could perhaps do something there.
>
> What are you trying to achieve by forcing the second one to fail?

puh... that is a good question :-)

I'm writing my master's thesis on a new model of memory protection and need to 
have every memory mapping in userspace duplicated. I also have kind of a 
second PGD/PTD that allows finding this mirrored mapping.

However, as the number of original mappings grows, I suddenly have the problem 
that the kernel tries to allocate a new mapping and picks the address of a 
mirrored memory page, which it shouldn't.

Honestly, I don't understand why it does so, but it simply does... so 
basically I want these second mappings to stay in memory as long as the 
original page.

What do you mean exactly with

> There's an LSM exit point for mmap, you could perhaps do something there.

??

By the way / @Jiri Kosina:

> Which is exactly in compliance with what POSIX says about MAP_FIXED mmaps 
> - see http://opengroup.org/onlinepubs/007908799/xsh/mmap.html

I know... I'm not even saying that this is a bug... I just wonder if there is 
some way to avoid this problem :-)

Thanks for your help - i really appreciate that!!

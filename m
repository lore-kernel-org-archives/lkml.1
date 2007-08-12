Return-Path: <linux-kernel-owner+w=401wt.eu-S937488AbXHLP2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937488AbXHLP2f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935278AbXHLP2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:28:19 -0400
Received: from [212.12.190.217] ([212.12.190.217]:33099 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S934600AbXHLP2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:28:17 -0400
From: Al Boldi <a1426z@gawab.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [RFD] Layering: Use-Case Composers (was: DRBD - what is it, anyways? [compare with e.g. NBD + MD raid])
Date: Sun, 12 Aug 2007 18:28:03 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, linux-raid@vger.kernel.org
References: <200708121335.17267.a1426z@gawab.com> <20070812115126.GA14770@2ka.mipt.ru>
In-Reply-To: <20070812115126.GA14770@2ka.mipt.ru>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708121828.03184.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> Al Boldi (a1426z@gawab.com) wrote:
> > Look at ZFS; it illegally violates layering by combining md/dm/lvm with
> > the fs, but it does this based on a realistic understanding of the
> > problems involved, which enables it to improve performance, flexibility,
> > and functionality specific to its use case.
> >
> > This implies that there are two distinct forces at work here:
> >
> >   1. Layer components
> >   2. Use-Case composers
> >
> > Layer components should technically not implement any use case (other
> > than providing a plumbing framework), as that would incur unnecessary
> > dependencies, which could reduce its generality and thus reusability.
> >
> > Use-Case composers can now leverage layer components from across the
> > layering hierarchy, to yield a specific use case implementation.
> >
> > DRBD is such a Use-Case composer, as is mdm / dm / lvm and any fs in
> > general, whereas aoe / nbd / loop and the VFS / FUSE are examples of
> > layer components.
> >
> > It follows that Use-case composers, like DRBD, need common functionality
> > that should be factored out into layer components, and then recompose to
> > implement a specific use case.
>
> Out of curiosity, did you try ndb+dm+raid1 compared to drbd and/or zfs
> on top of distributed storage (which is a urprise to me, that holy zfs
> suppors that)?

Actually, I may not have been very clear in my Use-Case composer description 
to mean internal in-kernel Use-Case composer as opposed to external Userland 
Use-Case composer.

So, nbd+dm+raid1 would be an external Userland Use-Case composition, which 
obviously could have some drastic performance issues.

DRBD and ZFS are examples of internal in-kernel Use-Case composers, which 
obviously could show some drastic performance improvements.  

Although you could allow in-kernel Use-Case composers to be run on top of 
Userland Use-Case composers, that wouldn't be the preferred mode of 
operation.  Instead, you would for example recompose ZFS to incorporate an 
in-kernel distributed storage layer component, like nbd.

All this boils down to refactoring Use-Case composers to produce layer 
components with both in-kernel and userland interfaces.  Once we have that, 
it becomes a matter of plug-and-play to produce something awesome like ZFS.


Thanks!

--
Al


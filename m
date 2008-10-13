Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbYJMUlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbYJMUlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbYJMUlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:41:44 -0400
Received: from mail.crca.org.au ([67.207.131.56]:52349 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbYJMUlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:41:42 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] safe resuming: automatically invalidating an
	outdated hibernate snapshot
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Martin Steigerwald <ms@teamix.de>
Cc: tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
In-Reply-To: <200810131335.25793.ms@teamix.de>
References: <200810131335.25793.ms@teamix.de>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Tue, 14 Oct 2008 07:41:37 +1100
Message-Id: <1223930497.11353.16.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin.

On Mon, 2008-10-13 at 13:35 +0200, Martin Steigerwald wrote:
> Am Montag, 13. Oktober 2008 schrieben Sie:
> > Hi Martin.
> 
> Hi Nigel,
> 
> > On Mon, 2008-10-13 at 12:13 +0200, Martin Steigerwald wrote:
> > > Cc to linux-kernel: This is mainly for tuxonice, but it might also be
> > > relevant for other hibernate implementations. Maybe some general
> > > mechanism for checking whether an on disk snapshot of the system is
> > > current would be good - as also the resume parameter could be missing or
> > > wrong or whatnot.
> > >
> > >
> > > Hi!
> > >
> > > Is there a way to automatically invalidate the tuxonice snapshot when a
> > > non tuxonice kernel is booted accidentally? I.e. could tuxonice recognize
> > > when the swap partition has been accessed *after* the snapshot has been
> > > written?
> 
> [...]
> 
> > The simplest way is to mkswap the appropriate partitions from a script
> > run when booting (after we check whether to resume, of course). I
> > believe the hibernate script already has support for this. Maybe
> > pm-utils or such like needs it too?
> 
> Simple idea. But I dislike automatically formatting a partition on each boot. 
> What if the user changes the partition layout and forgets to adapt swap 
> partition / resume parameter? AFAIR only mkfs.xfs really checks whether the 
> partition contains an existing filesystem and even that check does cannot 
> trigger in case an undetected filesystem is on the partition.
> 
> Thus I'd prefer a way to touch the swap partition without destroying its 
> contents and then checking whether it has been touched after the snapshot has 
> been written. I would then like to have it touched on every bootup on the 
> Linux system. Would something along these lines be possible?

The only way around this issue that I can see would be if we could get
the last mount time of each partition without doing any writes to that
partition. We could then record those times in the image header and
compare them at boot. Unfortunately, however - as far as I know -
there's no support for that at the moment.

Regards,

Nigel


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbYJOI03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbYJOI03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 04:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYJOI0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 04:26:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:38650 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751820AbYJOI0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 04:26:20 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19x1gMqkZpxPs+mD8P54UGaEK68rStP2RTwGmRSFe
	EFQ7W//f/NQGsk
Date: Wed, 15 Oct 2008 10:26:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Adrian Bunk <bunk@kernel.org>,
       Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>, lethal@linux-sh.org,
       linux-sh@vger.kernel.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Magnus Damm <damm@igel.co.jp>
Subject: Re: [PATCH] soc-camera: fix compile breakage on SH
In-Reply-To: <aec7e5c30810150103p7ed810ccyc815ad578d64feac@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810151011450.3896@axis700.grange>
References: <20081014183936.GB4710@cs181140183.pp.htv.fi> 
 <Pine.LNX.4.64.0810142335400.10458@axis700.grange> 
 <20081015033303.GC4710@cs181140183.pp.htv.fi>  <20081015052026.GC20183@cs181140183.pp.htv.fi>
  <aec7e5c30810142328n1563163bw636b8baf1a47ad8b@mail.gmail.com> 
 <Pine.LNX.4.64.0810150836100.3896@axis700.grange>
 <aec7e5c30810150103p7ed810ccyc815ad578d64feac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Magnus Damm wrote:

> Hi Guennadi,
> 
> On Wed, Oct 15, 2008 at 3:41 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Hi Magnus
> >
> > On Wed, 15 Oct 2008, Magnus Damm wrote:
> >
> >> Thanks for working on fixing the breakage. I'd prefer to wait a bit
> >> since there are quite a few pinmux patches queued up that may break if
> >> we merge a fix right now. I can fix it up later on.
> >
> > no, I would not leave the kernel in a non-compilable state even if just
> > for one board. Please, test a new version of the patch below. And yes, You
> > will have to rebase your patches, sorry. Another thing, could you also,
> > please, add a license / copyright header to
> > include/media/soc_camera_platform.h?
> 
> I'm not asking you to keep the board broken forever. It's just a
> question of in which order the trees are getting merged. Again, I'd
> rather see that this fix is put _on_top_ of the patches that are
> already queued up in the SuperH tree. Merging it before doesn't help
> anything in my opinion - especially since the change should go though
> the SuperH tree anyway.

I think, compilation-breakage fixes should have higher priority than 
further enhancements. Think about bisection. If you now first commit 
several more patches, you make the interval where the tree is not 
compilable longer, and thus the probabiliy that someone hits it in their 
git.bisect higher. That's why I think any compilation breakage should be 
fixed ASAP. And which changes do you mean specifically? This one:

http://marc.info/?l=linux-sh&m=122346619318532&w=2

Yes, indeed they conflict, but it is trivial to fix. So, I would prefer to 
close the compile-breakage window ASAP, and then trivially update that one 
your patch. Let's see what others say. And as for through which tree it 
should go, if you insist the sh-part going through the sh-tree, then it 
has to be split into two parts - video and sh. Thus extending the 
breakage-window by one commit...

> Feel free to add any header you like. =)

Thanks, but no thanks:-) I cannot add your copyright, at least not without 
your explicit agreement (I think). So, I'd prefer you submit a patch for 
that.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

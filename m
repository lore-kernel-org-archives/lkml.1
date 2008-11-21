Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbYKUNaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbYKUNaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 08:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYKUN34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 08:29:56 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58768 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbYKUN3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 08:29:55 -0500
To: tj@kernel.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net
In-reply-to: <4926B251.6010109@kernel.org> (message from Tejun Heo on Fri, 21
	Nov 2008 22:06:25 +0900)
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations, take
 #2
References: <1227190298-4585-1-git-send-email-tj@kernel.org> <E1L3G3Q-0006SJ-Uc@pomaz-ex.szeredi.hu> <49268876.7080303@kernel.org> <E1L3Tp0-0007dc-3S@pomaz-ex.szeredi.hu> <4926B251.6010109@kernel.org>
Message-Id: <E1L3W52-0007t3-PZ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Nov 2008 14:29:52 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008, Tejun Heo wrote:
> Miklos Szeredi wrote:
> > On Fri, 21 Nov 2008, Tejun Heo wrote:
> >>> I removed ->unrestricted_ioctl() and associated code because it really
> >>> doesn't make any sense: the high level lib won't be used for CUSE
> >>> stuff, otherwise unrestrited ioctls are not allowed (and the interface
> >>> is rather horrible anyway).
> >> Well, CUSE highlevel interface piggy backs on FUSE so it requires
> >> unrestricted_ioctl() there for it and ossp does use it.
> > 
> > I thought it uses the lowlevel interface.  Why doesn't it do that?
> 
> Well, because it's simpler that way and people would be more used to it?
>  It's just easier when you implement a method which returns something
> and looks similar to the respective file operation.

Ah, that.  Yeah, it's more intuitive, but that comes at a price.  I'm
not sure that for CUSE it's worth it.  As I said the biggest feature
is having paths, the others are not that important (like allocating a
buffer for read, that's really not too complex to do in each CUSE
driver).

> > For CUSE there's really no point in going through high level
> > interface, since there's just one file involved, so the path name
> > generation (the main feature of the highlevel lib) doesn't make any
> > sense.
> 
> Well, the choice was mostly for convenience as there also are a few
> places where high level interface wraps things better a bit.  Converting
> wouldn't be difficult.  Do you think it's important?  I think keeping
> things as parallel to FUSE as possible is more important.

I wouldn't care very much, if it weren't for that horrid
unrestricted_ioctl().  Not your fault, the interface is just not well
suited to that.

Miklos

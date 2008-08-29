Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbYH2Iaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbYH2Iaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYH2IaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:30:06 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33035 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbYH2IaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:30:02 -0400
To: tj@kernel.org
CC: miklos@szeredi.hu, greg@kroah.com, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <48B7AF60.8040709@kernel.org> (message from Tejun Heo on Fri, 29
	Aug 2008 10:12:16 +0200)
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org> <48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu> <48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu> <48B6EF98.4070008@kernel.org> <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu> <48B6FFB6.7000104@kernel.org> <E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu> <48B75C94.7030604@kernel.org> <E1KYyt9-0005Ur-Eu@pomaz-ex.szeredi.hu> <48B7AF60.8040709@kernel.org>
Message-Id: <E1KYzMd-0005aR-28@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 29 Aug 2008 10:29:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008, Tejun Heo wrote:
> I first used 'server' for userland [FC]USE server but then I noticed
> there were places in FUSE they were referred as clients so now I use
> 'client' for those and call the app using the FUSE fs the 'caller'.
> What are the established terms?

Umm

 - userspace filesystem
 - filesystem daemon
 - filesystem process
 - server

Yes it's also a client of the fuse device, but that term is confusing.

> Anyways, doing it directly from the server (or is it client) opens up a
> lot of new possibilities to screw up and I'd really much prefer staying
> in similar ballpark with other operations.  Maybe we can restrict it to
> two stages (query size & transfer) and linear consecutive ranges but
> then again adding retry doesn't contribute too much to the complexity.
> Oh.. and BTW, the in-ioctl length coding is not used universally, so it
> can't be depended upon.

I know it's not universal, some horrors I've seen in the old wireless
interfaces.  The question is: do we want to support such "extended"
ioctls?  For exmaple, does OSS have non-conformant ioctls?

> >>  Also, what about containers?  How would it work then?
> > 
> > Dunno.  Isn't there some transformation of pids going on, so that the
> > global namespace can access pids in all containers but under a
> > different alias?  I do hope somethinig like this works, otherwise it's
> > not only fuse that will break.
> 
> I'm not sure either.  Any idea who we should be asking about it?

Serge Hallyn and Eric Biederman.

Miklos

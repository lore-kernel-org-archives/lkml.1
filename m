Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbZGIKfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbZGIKfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbZGIKfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:35:33 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46047 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbZGIKfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:35:32 -0400
To: tj@kernel.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       npiggin@suse.de
In-reply-to: <4A55286A.6040202@kernel.org> (message from Tejun Heo on Thu, 09
	Jul 2009 08:14:50 +0900)
Subject: Re: [PATCH 4/4] FUSE: implement direct mmap
References: <1245317073-24000-1-git-send-email-tj@kernel.org> <1245317073-24000-5-git-send-email-tj@kernel.org> <E1MJPmn-0001Q6-Fj@pomaz-ex.szeredi.hu> <4A48EEDC.807@kernel.org> <E1MMMgq-0002R2-FO@pomaz-ex.szeredi.hu> <4A4F3998.5020805@kernel.org> <E1MNmZM-0001ZB-GR@pomaz-ex.szeredi.hu> <4A55286A.6040202@kernel.org>
Message-Id: <E1MOqyM-00026z-D6@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 09 Jul 2009 12:35:26 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Jul 2009, Tejun Heo wrote:
> >> Using non-swappable memory would be fine for most device emulations
> >> but mapping large amount of pages would be problematic.  Hmmm... this
> >> is difficult.  It's a compromise among flexibility, scalability and
> >> code complexity.
> > 
> > What's the difficulty?
> 
> The desire to avoid pinning all the mapped pages.  :-)
> 
> > Allocating pages, giving them an ID and mapping them into various page
> > tables seems simple in contrast to trying to make a tmpfs file be a
> > fuse file at the same time, which the VM is really not prepared for.
> 
> If pinning all the pages are okay, the above should work fine.

If the page allocation is privileged then I think it's okay.

I have only vague ideas how this "direct mmap" could be used for other
things than sound drivers.  For example there's a significant push
towards making network filesystems coherent.  This is currently not
well supported by fuse and adding coherency guarantees to mmap is
especially tricky.  But I'm not sure it really needs a special mmap
interface, that's just one of the options.

Thoughts?

Thanks,
Miklos

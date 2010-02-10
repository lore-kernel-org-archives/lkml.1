Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab0BJMPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 07:15:39 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41155 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab0BJMPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 07:15:38 -0500
To: Tejun Heo <tj@kernel.org>
CC: miklos@szeredi.hu, mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
In-reply-to: <4B729F07.8020704@kernel.org> (message from Tejun Heo on Wed, 10
	Feb 2010 20:56:55 +0900)
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org>
Message-Id: <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 10 Feb 2010 13:15:28 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Feb 2010, Tejun Heo wrote:
> > Okay, lets be a little clearer.  There are client side maps and server
> > side maps.  Client side maps are naturally aligned (same offset ->
> > same page).
> 
> Same offset -> same page doesn't hold.

Right, I really meant same page -> same offset.  If the same offset is
mapped to multiple pages: no problem.  If the same page is mapped to
multiple offsets, then obviously it's not going to work properly.

> Can you please elaborate how you think the thing can work without
> referencing the proposed implementation?  Let's find out where the
> misundertanding is.

Thinking about it I'm not really sure...

Maybe the problem is that the propsed solution allows too much
freedom.  Normally there's a 1:1 relationship between pages and
offsets.  But we want to break that for CUSE, because two different
mappings of a char dev might point to completely different pages,
right?

When does that happen?  Can it happen that two mappings of the same
file descriptor will have different backing pages?

Thanks,
Miklos

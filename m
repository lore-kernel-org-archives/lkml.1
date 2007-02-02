Return-Path: <linux-kernel-owner+w=401wt.eu-S1946091AbXBBWgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946091AbXBBWgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 17:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946124AbXBBWgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 17:36:53 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49339 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946091AbXBBWgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 17:36:53 -0500
Date: Fri, 2 Feb 2007 22:48:38 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070202224838.6d84d41c@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0702021322310.15057@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	<df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net>
	<20070201083611.GC18233@elte.hu>
	<Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
	<20070202104900.GA13941@elte.hu>
	<Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
	<20070202195932.15b9b4ed@localhost.localdomain>
	<Pine.LNX.4.64.0702021155460.15057@woody.linux-foundation.org>
	<20070202213019.202e8db5@localhost.localdomain>
	<Pine.LNX.4.64.0702021322310.15057@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The brown and sticky will hit the rotating air impeller pretty hard if you
> > are not very careful about how that ends up scheduled
> 
> Why do you think that?
> 
> With cooperative scheduling (like the example Zach posted), there is 
> absolutely no "brown and sticky" wrt any CPU usage. Which is why 
> cooperative scheduling is a *good* thing. If you want to blow up your 
> 1024-node CPU cluster, you'd to it with "real threads".

You end up with a lot more things running asynchronously. In the current
world we see a series of requests for attributes and hopefully we do
readahead and all is neatly ordered. If fibrils are not ordered the same
way then we could make it worse as we might not pick the right readahead
for example.

> Since we'd only create fibrils on a system call entry level, and system 
> calls are independent, how would you do that anyway?

If we stick to that limit it ought to be ok. We've been busy slapping
people who call sys_*, except for internal magic like kernel_thread

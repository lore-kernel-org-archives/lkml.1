Return-Path: <linux-kernel-owner+w=401wt.eu-S965185AbXCGIje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965185AbXCGIje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 03:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965190AbXCGIje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 03:39:34 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:37789 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965185AbXCGIjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 03:39:33 -0500
To: mingo@elte.hu
CC: npiggin@suse.de, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
In-reply-to: <20070307082755.GA25733@elte.hu> (message from Ingo Molnar on
	Wed, 7 Mar 2007 09:27:55 +0100)
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
References: <20070221023656.6306.246.sendpatchset@linux.site> <20070221023735.6306.83373.sendpatchset@linux.site> <20070306225101.f393632c.akpm@linux-foundation.org> <20070307070853.GB15877@wotan.suse.de> <20070307081948.GA9563@wotan.suse.de> <20070307082755.GA25733@elte.hu>
Message-Id: <E1HOrfO-0008AW-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 07 Mar 2007 09:38:34 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > If it doesn't look very impressive, it could be because it leaves all 
> > the old crud around for backwards compatibility (the worst offenders 
> > are removed in patch 6/6).
> > 
> > If you look at the patchset as a whole, it removes about 250 lines, 
> > mostly of (non trivial) duplicated code in filemap.c memory.c shmem.c 
> > fremap.c, that is nonlinear pages specific and doesn't get anywhere 
> > near the testing that the linear fault path does.
> > 
> > A minimal fix for nonlinear pages would have required changing all 
> > ->populate handlers, which I simply thought was not very productive 
> > considering the testing and coverage issues, and that I was going to 
> > rewrite the nonlinear path anyway.
> > 
> > If you like, you can consider patches 1,2,3 as the fix, and ignore 
> > nonlinear (hey, it doesn't even bother checking truncate_count 
> > today!).
> > 
> > Then 4,5,6 is the fault/nonlinear rewrite, take it or leave it. I 
> > thought you would have liked the patches...
> 
> btw., if we decide that nonlinear isnt worth the continuing maintainance 
> pain, we could internally implement/emulate sys_remap_file_pages() via a 
> call to mremap() and essentially deprecate it, without breaking the ABI 
> - and remove all the nonlinear code. (This would split fremap areas into 
> separate vmas)

That would make sense.  Dirty page accounting doesn't work either on
non-linear mappings, and I can't see how that could be fixed in any
other way.

Miklos

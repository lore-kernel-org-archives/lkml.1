Return-Path: <linux-kernel-owner+w=401wt.eu-S1759926AbZA2WeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926AbZA2WeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZA2Wdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:33:51 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:45872 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZA2Wdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:33:51 -0500
Date: Thu, 29 Jan 2009 22:32:54 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0901292200220.17808@blonde.anvils>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com> 
 <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>
 <1233259410.2315.75.camel@lts-notebook> <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Linus Torvalds wrote:
> On Thu, 29 Jan 2009, Linus Torvalds wrote:
> > 
> > THIS PATCH IS TOTALLY UNTESTED!

Sorry, I was away yesterday, and not yet caught up with things today.

I certainly agree that it would be much nicer not to allocated a vma
in one place, then later throw it away on finding it can be merged:
your patch looks a plausible improvement.

The problem has always been that file->f_op->mmap(file, vma) on a
special file can do various strange things, changing surprising
fields of the struct vma passed to it, changing its mergeability.

Now it may well be that every driver which does something strange
there already sets one of the VM_SPECIAL flags which prevent merging,
or can easily be fixed to do so, or otherwise clearly cannot pose a
problem.

But I need to mull it over and do some checking tomorrow:
anything I say tonight, I'd probably change my mind about.

Hugh

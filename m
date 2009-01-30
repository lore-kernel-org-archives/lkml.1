Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZA3Exi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZA3Exi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 23:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZA3Exa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 23:53:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbZA3Ex3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 23:53:29 -0500
Date: Thu, 29 Jan 2009 20:49:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Hugh Dickins <hugh@veritas.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <1233290620.2315.113.camel@lts-notebook>
Message-ID: <alpine.LFD.2.00.0901292047400.3150@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>  <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>  <1233259410.2315.75.camel@lts-notebook>  <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain> 
 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>  <Pine.LNX.4.64.0901292200220.17808@blonde.anvils>  <alpine.LFD.2.00.0901291448360.3054@localhost.localdomain> <1233290620.2315.113.camel@lts-notebook>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Jan 2009, Lee Schermerhorn wrote:
> 
> Just want to note that install_special_mappings()--used for, e.g., the
> vdso--sets VM_DONTEXPAND [one of the VM_SPECIAL flags] which, if we want
> to prevent merging, makes a lot of sense to me.

Yes. VM_DONTEXPAND in many ways really fits the "don't merge" thing, 
because the whole mremap() VM expansion thing is really equivalent to this 
explicit merge.

> It appears that get_user_pages() will balk at addresses in vmas with 
> VM_IO [and VM_PFNMAP] which might not be what one wants.  For example, 
> you can't pre-populate the ptes via make_pages_present() with this flag.

Well, anybody who plays games with vm_pgoff really _should_ be VM_IO. I 
don't see any real reason for it except for having a very special IO 
mapping. Of course, you quite possibly _also_ want VM_DONTEXPAND.

		Linus

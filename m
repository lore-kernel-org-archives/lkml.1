Return-Path: <linux-kernel-owner+w=401wt.eu-S1760521AbZEFQQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521AbZEFQQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757440AbZEFQQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:16:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43143 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535AbZEFQQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:16:10 -0400
Date: Wed, 6 May 2009 09:14:24 -0700
From: Chris Wright <chrisw@redhat.com>
To: Izik Eidus <ieidus@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>, Rik van Riel <riel@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, alan@lxorguk.ukuu.org.uk,
       device@lanana.org, linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 3/6] ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
Message-ID: <20090506161424.GC15712@x200.localdomain>
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com> <1241475935-21162-2-git-send-email-ieidus@redhat.com> <1241475935-21162-3-git-send-email-ieidus@redhat.com> <1241475935-21162-4-git-send-email-ieidus@redhat.com> <4A00DF9B.1080501@redhat.com> <4A014C7B.9080702@redhat.com> <Pine.LNX.4.64.0905061110470.3519@blonde.anvils> <4A01AC5E.6000906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A01AC5E.6000906@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Izik Eidus (ieidus@redhat.com) wrote:
> But why not go go step by step?
> We can first start with this ioctl interface, later when we add swapping  
> to the pages, we can have madvice, and still (probably easily) support  
> the ioctls by just calling from inside ksm the madvice functions for  
> that specific address)

Then we have 2 interfaces to maintain.  Makes more sense to try and get
it right the first time.

> I want to see ksm use madvice, but i believe it require some more  
> changes to mm/*.c, so it probably better to start with merging it when  
> it doesnt touch alot of stuff outisde ksm.c, and then to add swapping  
> and after that add madvice support (when the pages are swappable,  
> everyone can use it)

There's already locking issues w/ using madvise and ksm, so yes,
changes would need to be made.  Some question of how (whether) to handle
registration of unmapped ranges, closest to say ->mm->def_flags=VM_MERGE.
My hunch is there's 2 cases users might care about, a specific range
(qemu-kvm, CERN app, etc) or the entire vma space of a process.  Another
question of what to do w/ VM_LOCKED, should that exclude VM_MERGE or
let user get what asked for?

thanks,
-chris

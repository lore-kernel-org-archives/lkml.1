Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbZEFQy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbZEFQy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbZEFQyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:54:16 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:45921 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbZEFQyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:54:15 -0400
Date: Wed, 6 May 2009 17:36:51 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Chris Wright <chrisw@redhat.com>
cc: Izik Eidus <ieidus@redhat.com>, Rik van Riel <riel@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, alan@lxorguk.ukuu.org.uk, device@lanana.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 3/6] ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
In-Reply-To: <20090506161424.GC15712@x200.localdomain>
Message-ID: <Pine.LNX.4.64.0905061732220.5775@blonde.anvils>
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com>
 <1241475935-21162-2-git-send-email-ieidus@redhat.com>
 <1241475935-21162-3-git-send-email-ieidus@redhat.com>
 <1241475935-21162-4-git-send-email-ieidus@redhat.com> <4A00DF9B.1080501@redhat.com>
 <4A014C7B.9080702@redhat.com> <Pine.LNX.4.64.0905061110470.3519@blonde.anvils>
 <4A01AC5E.6000906@redhat.com> <20090506161424.GC15712@x200.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Chris Wright wrote:
> 
> There's already locking issues w/ using madvise and ksm, so yes,
> changes would need to be made.  Some question of how (whether) to handle
> registration of unmapped ranges, closest to say ->mm->def_flags=VM_MERGE.
> My hunch is there's 2 cases users might care about, a specific range
> (qemu-kvm, CERN app, etc) or the entire vma space of a process.

Good food for thought there, but not on my mind at this moment.

> Another
> question of what to do w/ VM_LOCKED, should that exclude VM_MERGE or
> let user get what asked for?

What's the issue with VM_LOCKED?  We wouldn't want to merge a page
while it was under get_user_pages (unless KSM's own, but ignore that),
but what's the deal with VM_LOCKED?

Is the phrase "covert channel" going to come up somehow?

Hugh

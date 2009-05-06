Return-Path: <linux-kernel-owner+w=401wt.eu-S1760754AbZEFRNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760754AbZEFRNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZEFRNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:13:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45392 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZEFRNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:13:32 -0400
Date: Wed, 6 May 2009 10:09:17 -0700
From: Chris Wright <chrisw@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Chris Wright <chrisw@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, aarcange@redhat.com,
       alan@lxorguk.ukuu.org.uk, device@lanana.org, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 3/6] ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
Message-ID: <20090506170917.GE15712@x200.localdomain>
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com> <1241475935-21162-2-git-send-email-ieidus@redhat.com> <1241475935-21162-3-git-send-email-ieidus@redhat.com> <1241475935-21162-4-git-send-email-ieidus@redhat.com> <4A00DF9B.1080501@redhat.com> <4A014C7B.9080702@redhat.com> <Pine.LNX.4.64.0905061110470.3519@blonde.anvils> <4A01AC5E.6000906@redhat.com> <20090506161424.GC15712@x200.localdomain> <Pine.LNX.4.64.0905061732220.5775@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905061732220.5775@blonde.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hugh Dickins (hugh@veritas.com) wrote:
> On Wed, 6 May 2009, Chris Wright wrote:
> > Another
> > question of what to do w/ VM_LOCKED, should that exclude VM_MERGE or
> > let user get what asked for?
> 
> What's the issue with VM_LOCKED?  We wouldn't want to merge a page
> while it was under get_user_pages (unless KSM's own, but ignore that),
> but what's the deal with VM_LOCKED?
> 
> Is the phrase "covert channel" going to come up somehow?

There's two (still hand wavy) conerns I see there.  First is the security
implication: timing writes to see cow and guess the shared data for
another apps VM_LOCKED region, second is just plain old complaints of
those rt latency sensitive apps that somehow have VM_LOCKED|VM_MERGE
and complain of COW fault time, probably just "don't do that".

thanks,
-chris

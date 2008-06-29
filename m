Return-Path: <linux-kernel-owner+w=401wt.eu-S1760489AbYF2Nvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760489AbYF2Nvp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 09:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbYF2Nve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 09:51:34 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:47653 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbYF2Nvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 09:51:33 -0400
Date: Sun, 29 Jun 2008 14:51:08 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splitlru: memcg swapbacked pages active
In-Reply-To: <20080629213352.37D5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0806291440030.6036@blonde.site>
References: <20080629171251.37CA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <Pine.LNX.4.64.0806291302160.787@blonde.site> <20080629213352.37D5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008, KOSAKI Motohiro wrote:
> 
> Well...
> you are right.

Not proved!  This is all quite complex.  But it looks that way.

> 
> Hmm.. OK, I propse alternative way.
> 
> step1: commit this patch
> step2: implement active/inactive anon balancing routine

That sounds a good plan to me.

> 
> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Thank you for good patch.

Thank you; and please accept my apology for not Cc'ing you on
the patches - I had intended to, but forgot just when sending.

> 
> btw, furtunately, memcg reclaim has some retry.
> thus, lru imbalancing doesn't cause OOM, it only cause small performance degression.
> IMHO your patch doesn't have any risk.

These things can work out so differently in practice than one would
expect.  Tests seem to be chugging along okay with the change in,
but I haven't explicitly tested performance with and without.

It just seems a sensible starting point to have the global and
memcg views in synch: if departing from that proves to work better,
then we should do so later.

I've no view yet on the performance characteristics of any of this,
just focussed on getting tmpfs working correctly again.  The notion
of keeping unevictable pages away from the regularly scanned lists
seems an obvious gain; but the swapbacked/filebacked distinction
is not so obvious to me (and particularly problematic for tmpfs).

Hugh

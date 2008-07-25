Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbYGYLTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbYGYLTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 07:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYGYLTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 07:19:02 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:52301 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751820AbYGYLTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 07:19:00 -0400
X-SourceIP: 62.163.52.83
Subject: Re: [PATCH 30/30] nfs: fix various memory recursions possible with
	swap over NFS.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Neil Brown <neilb@suse.de>
In-Reply-To: <20080725201324.86BE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080725194517.86BB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1216983472.7257.365.camel@twins>
	 <20080725201324.86BE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 13:19:01 +0200
Message-Id: <1216984741.7257.366.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 20:15 +0900, KOSAKI Motohiro wrote:
> > On Fri, 2008-07-25 at 19:46 +0900, KOSAKI Motohiro wrote:
> > > > GFP_NOFS is not enough, since swap traffic is IO, hence fall back to GFP_NOIO.
> > > 
> > > this comment imply turn on GFP_NOIO, but the code is s/NOFS/NOIO/. why?
> > 
> > Does the misunderstanding stem from the use of 'enough'?
> > 
> > GFP_NOFS is _more_ permissive than GFP_NOIO in that it will initiate IO,
> > just not of any filesystem data.
> > 
> 
> 
> > The problem is that previuosly NOFS was correct because that avoids
> > recursion into the NFS code, it now is not, because also IO (swap) can
> > lead to this recursion.
> 
> 
> Thanks nicer explain.
> So, I hope add above 3 line to patch description.

Done, thanks!


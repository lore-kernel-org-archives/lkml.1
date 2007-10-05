Return-Path: <linux-kernel-owner+w=401wt.eu-S1763710AbXJETYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763710AbXJETYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763267AbXJETYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:24:17 -0400
Received: from pat.uio.no ([129.240.10.15]:39730 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762133AbXJETYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:24:16 -0400
Subject: Re: [PATCH] remove throttle_vm_writeout()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       wfg@mail.ustc.edu.cn, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1191612043.6715.139.camel@heimdal.trondhjem.org>
References: <E1IdPla-0002Bd-00@dorka.pomaz.szeredi.hu>
	 <20071004145640.18ced770.akpm@linux-foundation.org>
	 <E1IdZLg-0002Wr-00@dorka.pomaz.szeredi.hu>
	 <20071004160941.e0c0c7e5.akpm@linux-foundation.org>
	 <E1Ida56-0002Zz-00@dorka.pomaz.szeredi.hu>
	 <20071004164801.d8478727.akpm@linux-foundation.org>
	 <E1Idanu-0002c1-00@dorka.pomaz.szeredi.hu>
	 <20071004174851.b34a3220.akpm@linux-foundation.org>
	 <1191572520.22357.42.camel@twins>
	 <E1IdjOa-0002qg-00@dorka.pomaz.szeredi.hu>
	 <1191577623.22357.69.camel@twins>
	 <E1IdkOf-0002tK-00@dorka.pomaz.szeredi.hu>
	 <1191581854.22357.85.camel@twins>
	 <1191606600.6715.94.camel@heimdal.trondhjem.org>
	 <1191609139.6210.4.camel@lappy>
	 <1191612043.6715.139.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Fri, 05 Oct 2007 15:23:16 -0400
Message-Id: <1191612196.6715.142.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, AWL=0.011)
X-UiO-Scanned: C770F94AC24B5BEC770C2CC523E95E279151D06A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 208 total 4317734 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-05 at 15:20 -0400, Trond Myklebust wrote:
> On Fri, 2007-10-05 at 20:32 +0200, Peter Zijlstra wrote:
> > Well, the thing is, we throttle pageout in throttle_vm_writeout(). As it
> > stand we can deadlock there because it just waits for the numbers to
> > drop, and unstable pages don't automagically dissapear. Only
> > write_inodes() - normally called from balance_dirty_pages() will call
> > COMMIT.
> > 
> > So my thought was that calling pageout() on an unstable page would do
> > the COMMIT - we're low on memory, otherwise we would not be paging, so
> > getting rid of unstable pages seems to make sense to me.
> 
> Why not rather track which mappings have large numbers of outstanding
> unstable writes at the VM level, and then add some form of callback to
> allow it to notify the filesystem when it needs to flush them out?
> 
> Cheers
>   Trond

BTW: Please note that at least in the case of NFS, you will have to
allow for the fact that the filesystem may not be _able_ to cause the
numbers to drop. If the server is unavailable, then we're may be stuck
in unstable page limbo for quite some time.

Trond


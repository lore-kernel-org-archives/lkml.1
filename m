Return-Path: <linux-kernel-owner+w=401wt.eu-S1767000AbXDSVat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767000AbXDSVat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 17:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422667AbXDSVat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 17:30:49 -0400
Received: from mx2.netapp.com ([216.240.18.37]:10604 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422636AbXDSVas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 17:30:48 -0400
X-IronPort-AV: i="4.14,428,1170662400"; 
   d="scan'208"; a="52732888:sNHT23517025"
Subject: Re: Failure! Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series
	of issues
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Florin Iucha <florin@iucha.net>
Cc: chuck.lever@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070419195844.GT24044@iucha.net>
References: <20070418123842.GF24044@iucha.net>
	 <1176902131.6796.62.camel@heimdal.trondhjem.org>
	 <20070418134225.GG24044@iucha.net>
	 <1176905506.6796.84.camel@heimdal.trondhjem.org>
	 <20070419015232.GO24044@iucha.net>
	 <1176950713.6422.95.camel@heimdal.trondhjem.org>
	 <462786C9.7090405@oracle.com>
	 <1176995848.6663.1.camel@heimdal.trondhjem.org>
	 <20070419155046.GR24044@iucha.net>
	 <1176998982.6663.10.camel@heimdal.trondhjem.org>
	 <20070419195844.GT24044@iucha.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Thu, 19 Apr 2007 17:30:42 -0400
Message-Id: <1177018242.6628.10.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 19 Apr 2007 21:30:49.0136 (UTC) FILETIME=[FF954B00:01C782C9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 14:58 -0500, Florin Iucha wrote:
> On Thu, Apr 19, 2007 at 12:09:42PM -0400, Trond Myklebust wrote:
> > See
> >    http://client.linux-nfs.org/Linux-2.6.x/2.6.21-rc7/
> > 
> > I'm giving the first 5 patches of that series (i.e.
> > linux-2.6.21-001-cleanup_unstable_write.dif to
> > linux-2.6.21-005-fix_nfsv4_resend.dif) an extra beating since those are
> > the ones that I feel should go into 2.6.21 final in order to fix the
> > read/write regressions that have been reported. They should be identical
> > to the patches that I posted on lkml in the past 3 days.
> > 
> > Please feel free to grab them and give them a test.
> 
> The copy completed some time ago, but now I cannot ssh into the box!
> This is a new development, as before I was always able to ssh into,
> even when the copy slowed down to a trickle.
> 
> I'm far from the machine right now, so I will do some more tests
> tonight, but right now, the new patchset is not good.  What is the
> difference between reverting the patch you sent yesterday and your
> current fifth patch?  I assume the other four are identical, right?

The only difference is the way in which we handle retries of an NFSv4
request: the new patch disconnects if and only if a timeout has
occurred, or the server sends us garbage.

Trond

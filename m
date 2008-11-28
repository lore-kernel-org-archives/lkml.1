Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYK1Ss0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYK1Ss0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 13:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYK1SsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 13:48:14 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:4650 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYK1SsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 13:48:13 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 0/6] fs: Scalability of sockets/pipes
 allocation/deallocation on SMP
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20081128180318.GL10487@elte.hu>
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com>
	 <20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com>
	 <20081121.010508.40225532.davem@davemloft.net>
	 <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com>
	 <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com>
	 <20081121153453.GA23713@elte.hu> <492DDB6A.8090806@cosmosbay.com>
	 <20081128180318.GL10487@elte.hu>
Content-Type: text/plain
Date: Fri, 28 Nov 2008 19:47:56 +0100
Message-Id: <1227898076.7392.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-28 at 19:03 +0100, Ingo Molnar wrote:
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > Hi all
> >
> > Short summary : Nice speedups for allocation/deallocation of sockets/pipes
> > (From 27.5 seconds to 1.6 second)
> 
> Wow, that's incredibly impressive! :-)

Yeah, we got a similar speedup on -rt by pushing those super-block files
list into per-cpu lists and doing crazy locking on them.

Of course avoiding them all together, like done here is a nicer option
but is sadly not a possibility for regular files (until hch gets around
to removing the need for the list).




Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbXD0RrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbXD0RrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbXD0RrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:47:08 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:28420 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbXD0RrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:47:03 -0400
Date: Fri, 27 Apr 2007 19:46:13 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
Subject: Re: [PATCH 0/5] fallocate system call
Message-ID: <20070427174613.GA8228@osiris.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070427121003.GA7808@osiris.boeblingen.de.ibm.com> <20070427144327.GC22949@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070427144327.GC22949@lazybastard.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 04:43:28PM +0200, Jörn Engel wrote:
> On Fri, 27 April 2007 14:10:03 +0200, Heiko Carstens wrote:
> > 
> > After long discussions where at least two possible implementations
> > were suggested that would work on _all_ architectures you chose one
> > which doesn't and causes extra effort.
> 
> I believe the long discussion also showed that every possible
> implementation has drawbacks.  To me this one appeared to be the best of
> many bad choices.

If one insists to have fd at first argument, what is wrong with having
u32 arguments only? It's not that this syscall comes even close to
what can be considered performance critical...

> Is this implementation worse than we thought?

It adds userspace overhead for one architecture. Every *trace and
*libc needs special handling on s390 for this syscall. I would
prefer to avoid this.

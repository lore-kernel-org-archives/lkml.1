Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbZIQSvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbZIQSvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759219AbZIQSvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:51:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:35351 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbZIQSvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:51:08 -0400
Date: Thu, 17 Sep 2009 20:51:06 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, mingo@elte.hu, sachinp@in.ibm.com
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
Message-ID: <20090917185106.GT18404@wotan.suse.de>
References: <1253083059.5478.1.camel@penberg-laptop> <20090917100841.GF13002@csn.ul.ie> <1253183365.4975.20.camel@penberg-laptop> <20090917105707.GA7205@csn.ul.ie> <1253186019.4975.32.camel@penberg-laptop> <20090917111828.GB7205@csn.ul.ie> <20090917114116.GL18404@wotan.suse.de> <20090917181831.GA714@csn.ul.ie> <20090917182842.GS18404@wotan.suse.de> <alpine.DEB.1.10.0909171437180.5220@V090114053VZO-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0909171437180.5220@V090114053VZO-1>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 02:38:08PM -0400, Christoph Lameter wrote:
> On Thu, 17 Sep 2009, Nick Piggin wrote:
> 
> > > This machine has two CPUs (0, 1) and two nodes with actual memory (2,3).
> > > After applying a patch to kmem_cache_create, I see in the console
> > >
> > > MEL::Creating cache pgd_cache CPU 0 Node 0
> > > MEL::Creating cache pmd_cache CPU 0 Node 0
> > > MEL::Creating cache pid_namespace CPU 0 Node 0
> > > MEL::Creating cache shmem_inode_cache CPU 0 Node 0
> > > MEL::Creating cache scsi_data_buffer CPU 1 Node 0
> 
> So we have two nodes 2,3 nothing on node 0 and we are creating caches on
> the node that does not exist? SLQB assumes node 0 is present?

It might do somewhere, but it shouldn't. It will ask for node 0
by default presumably if CPU0 is on node 0, but it should be able
to fall back...


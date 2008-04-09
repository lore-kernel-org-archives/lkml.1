Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYDINMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYDINMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbYDINMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:12:42 -0400
Received: from mx2.netapp.com ([216.240.18.37]:32685 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbYDINMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:12:41 -0400
X-IronPort-AV: E=Sophos;i="4.25,629,1199692800"; 
   d="scan'208";a="25627848"
Subject: Re: [GIT] Please pull NFS client fixes against linux-2.6.25-rc8
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080409082408.GA17458@infradead.org>
References: <1207703414.21370.1.camel@heimdal.trondhjem.org>
	 <20080409082408.GA17458@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Wed, 09 Apr 2008 09:12:38 -0400
Message-Id: <1207746758.8303.4.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 09 Apr 2008 13:12:39.0659 (UTC) FILETIME=[63200BB0:01C89A43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-09 at 04:24 -0400, Christoph Hellwig wrote:
> > +#ifdef CONFIG_MMU
> >  	.mmap		= nfs_file_mmap,
> > +#else
> > +	.mmap		= generic_file_mmap,
> > +#endif
> 
> This is with almost 100% chance wrong.  It might get you a kernel that
> compiles but none where mmap actually works.  Just disable mmap on nfs
> for mmu-less systems until someone hacks up a proper mmu-less mmap
> method for nfs.

That is what this does. For the case of no mmu, generic_file_mmap()
compiles into a 'return -ENOSYS;'

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

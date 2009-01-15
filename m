Return-Path: <linux-kernel-owner+w=401wt.eu-S1762677AbZAOMHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677AbZAOMHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbZAOMHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:07:07 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:47596 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673AbZAOMHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:07:04 -0500
Date: Thu, 15 Jan 2009 13:05:26 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org,
       schwidefsky@de.ibm.com, penberg@cs.helsinki.fi
Subject: Re: [BUILD_FAILURE] next-20090115 - s390x - mm/kmemleak.c
Message-ID: <20090115120526.GD5093@osiris.boeblingen.de.ibm.com>
References: <20090115170415.3edc1df6.sfr@canb.auug.org.au> <20090115103504.GA5178@linux.vnet.ibm.com> <20090115112001.GC5093@osiris.boeblingen.de.ibm.com> <1232020540.32016.19.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232020540.32016.19.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 11:55:40AM +0000, Catalin Marinas wrote:
> On Thu, 2009-01-15 at 12:20 +0100, Heiko Carstens wrote:
> > On Thu, Jan 15, 2009 at 04:05:04PM +0530, Kamalesh Babulal wrote:
> > > Hi Stephen,
> > > 
> > > 	next-20090115 allyesconfig build fails on s390x
> > > 
> > > mm/built-in.o: In function `kmemleak_scan':
> > > mm/kmemleak.c:977: undefined reference to `_sdata'
> > > make: *** [.tmp_vmlinux1] Error 1
> > 
> > A lot of architectures don't have _sdata definined in their linker scripts.
> > On s390 _sdata would be the same as _etext. But that is not necessarily true
> > for all architectures.
> 
> Kmemleak has only been tested on ARM and x86. I can add patches for the
> other architectures so that the compilation is fine but can't really run
> such kernels.

That would be nice. Fixing it so that it actually works (_if_ it does not)
can still be done later.

Btw. you have

/*
 * Stop the automatic memory scanning thread. This function must be called
 * with the kmemleak_mutex held.
 */
void stop_scan_thread(void)
{
...

but call the function unlocked from kmemleak_write. Looks like a bug ;)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYBDEvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYBDEvE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 23:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbYBDEuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 23:50:51 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:39564 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbYBDEun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 23:50:43 -0500
Date: Mon, 4 Feb 2008 10:20:25 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Bastian Blank <bastian@waldi.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-s390@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Fix ext4 bitops
Message-ID: <20080204045025.GA7494@skywalker>
References: <20080201200208.GA28274@wavehammer.waldi.eu.org> <20080201122257.9524c2bb.akpm@linux-foundation.org> <20080201210404.GA31271@wavehammer.waldi.eu.org> <20080203121238.GD18211@osiris.ibm.com> <Pine.LNX.4.64.0802031336240.28712@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802031336240.28712@anakin>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 01:39:02PM +0100, Geert Uytterhoeven wrote:
> On Sun, 3 Feb 2008, Heiko Carstens wrote:
> > On Fri, Feb 01, 2008 at 10:04:04PM +0100, Bastian Blank wrote:
> > > On Fri, Feb 01, 2008 at 12:22:57PM -0800, Andrew Morton wrote:
> > > > On Fri, 1 Feb 2008 21:02:08 +0100
> > > > Bastian Blank <bastian@waldi.eu.org> wrote:
> > > > 
> > > > > Fix ext4 bitops.
> > > > 
> > > > This is incomplete.  Please tell us what was "fixed".
> > > > 
> > > > If it was a build error then please quote the compile error output in the
> > > > changelog, as well as the usual description of what the problem is, and how
> > > > it was fixed.
> > > 
> > > | fs/ext4/mballoc.c: In function 'ext4_mb_generate_buddy':
> > > | fs/ext4/mballoc.c:954: error: implicit declaration of function 'generic_find_next_le_bit'
> > > 
> > > The s390 specific bitops uses parts of the generic implementation.
> > > Include the correct header.
> > 
> > That doesn't work:
> > 
> > fs/built-in.o: In function `ext4_mb_release_inode_pa':
> > mballoc.c:(.text+0x95a8a): undefined reference to `generic_find_next_le_bit'
> > fs/built-in.o: In function `ext4_mb_init_cache':
> > mballoc.c:(.text+0x967ea): undefined reference to `generic_find_next_le_bit'
> > 
> > This still needs generic_find_next_le_bit which comes
> > from lib/find_next_bit.c. That one doesn't get built on s390 since we
> > don't set GENERIC_FIND_NEXT_BIT.
> > Currently we have the lengthly patch below queued.
> 
> Similar issue on m68k. As Bastian also saw it on powerpc, I'm getting the
> impression the ext4 people don't (compile) test on big endian machines?
> 
> Gr{oetje,eeting}s,
> 

I have sent this patches to linux-arch expecting a review from
different arch people. It is true that the patches are tested only on
powerpc, x86-64, x86. That's the primary reason of me sending the
patches to linux-arch.

http://marc.info/?l=linux-arch&m=119503501127737&w=2


-aneesh

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYBDJ3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYBDJ3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 04:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbYBDJ3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 04:29:47 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:48966 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYBDJ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 04:29:45 -0500
Date: Mon, 4 Feb 2008 14:59:34 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Bastian Blank <bastian@waldi.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-s390@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Fix ext4 bitops
Message-ID: <20080204092934.GE7494@skywalker>
References: <20080201200208.GA28274@wavehammer.waldi.eu.org> <20080201122257.9524c2bb.akpm@linux-foundation.org> <20080201210404.GA31271@wavehammer.waldi.eu.org> <20080203121238.GD18211@osiris.ibm.com> <Pine.LNX.4.64.0802031336240.28712@anakin> <20080204045025.GA7494@skywalker> <20080204092436.GB7530@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204092436.GB7530@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 10:24:36AM +0100, Heiko Carstens wrote:
> > > > > | fs/ext4/mballoc.c: In function 'ext4_mb_generate_buddy':
> > > > > | fs/ext4/mballoc.c:954: error: implicit declaration of function 'generic_find_next_le_bit'
> > > > > 
> > > > > The s390 specific bitops uses parts of the generic implementation.
> > > > > Include the correct header.
> > > > 
> > > > That doesn't work:
> > > > 
> > > > fs/built-in.o: In function `ext4_mb_release_inode_pa':
> > > > mballoc.c:(.text+0x95a8a): undefined reference to `generic_find_next_le_bit'
> > > > fs/built-in.o: In function `ext4_mb_init_cache':
> > > > mballoc.c:(.text+0x967ea): undefined reference to `generic_find_next_le_bit'
> > > > 
> > > > This still needs generic_find_next_le_bit which comes
> > > > from lib/find_next_bit.c. That one doesn't get built on s390 since we
> > > > don't set GENERIC_FIND_NEXT_BIT.
> > > > Currently we have the lengthly patch below queued.
> > > 
> > > Similar issue on m68k. As Bastian also saw it on powerpc, I'm getting the
> > > impression the ext4 people don't (compile) test on big endian machines?
> > > 
> > > Gr{oetje,eeting}s,
> > > 
> > 
> > I have sent this patches to linux-arch expecting a review from
> > different arch people. It is true that the patches are tested only on
> > powerpc, x86-64, x86. That's the primary reason of me sending the
> > patches to linux-arch.
> 
> Is there anything special I need to do so the ext4 code actually uses
> ext2_find_next_bit() ? Haven't looked at the ext4 code, but I'd like to
> test if the s390 implementation is ok.

With the latest linus kernel in git you can test it by mounting  ext4

mount -t ext4dev <device> <mntpoint>


-aneesh

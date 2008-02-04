Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbYBDJYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbYBDJYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 04:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYBDJYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 04:24:40 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:15048 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbYBDJYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 04:24:39 -0500
Date: Mon, 4 Feb 2008 10:24:36 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Bastian Blank <bastian@waldi.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-s390@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Fix ext4 bitops
Message-ID: <20080204092436.GB7530@osiris.boeblingen.de.ibm.com>
References: <20080201200208.GA28274@wavehammer.waldi.eu.org> <20080201122257.9524c2bb.akpm@linux-foundation.org> <20080201210404.GA31271@wavehammer.waldi.eu.org> <20080203121238.GD18211@osiris.ibm.com> <Pine.LNX.4.64.0802031336240.28712@anakin> <20080204045025.GA7494@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204045025.GA7494@skywalker>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > | fs/ext4/mballoc.c: In function 'ext4_mb_generate_buddy':
> > > > | fs/ext4/mballoc.c:954: error: implicit declaration of function 'generic_find_next_le_bit'
> > > > 
> > > > The s390 specific bitops uses parts of the generic implementation.
> > > > Include the correct header.
> > > 
> > > That doesn't work:
> > > 
> > > fs/built-in.o: In function `ext4_mb_release_inode_pa':
> > > mballoc.c:(.text+0x95a8a): undefined reference to `generic_find_next_le_bit'
> > > fs/built-in.o: In function `ext4_mb_init_cache':
> > > mballoc.c:(.text+0x967ea): undefined reference to `generic_find_next_le_bit'
> > > 
> > > This still needs generic_find_next_le_bit which comes
> > > from lib/find_next_bit.c. That one doesn't get built on s390 since we
> > > don't set GENERIC_FIND_NEXT_BIT.
> > > Currently we have the lengthly patch below queued.
> > 
> > Similar issue on m68k. As Bastian also saw it on powerpc, I'm getting the
> > impression the ext4 people don't (compile) test on big endian machines?
> > 
> > Gr{oetje,eeting}s,
> > 
> 
> I have sent this patches to linux-arch expecting a review from
> different arch people. It is true that the patches are tested only on
> powerpc, x86-64, x86. That's the primary reason of me sending the
> patches to linux-arch.

Is there anything special I need to do so the ext4 code actually uses
ext2_find_next_bit() ? Haven't looked at the ext4 code, but I'd like to
test if the s390 implementation is ok.

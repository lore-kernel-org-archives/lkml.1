Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYGWUv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYGWUv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbYGWUvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:51:20 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:52180 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbYGWUvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:51:19 -0400
Date: Wed, 23 Jul 2008 23:51:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       mpatocka@redhat.com, Alasdair G Kergon <agk@redhat.com>
Subject: Re: next-20080723: build fails for dm-snapshot.ko
Message-ID: <20080723205102.GC5991@cs181140183.pp.htv.fi>
References: <1216835917.19707.3.camel@dhcppc2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1216835917.19707.3.camel@dhcppc2>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 07:58:37PM +0200, Thomas Meyer wrote:
> 
>   Building modules, stage 2.
> Kernel: arch/x86/boot/bzImage is ready  (#24)
>   MODPOST 1518 modules
> ERROR: "__umoddi3" [drivers/md/dm-snapshot.ko] undefined!
> WARNING: modpost: Found 6 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> 
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=y
> CONFIG_MD_LINEAR=m
> CONFIG_MD_RAID0=m
> CONFIG_MD_RAID1=m
> CONFIG_MD_RAID10=m
> CONFIG_MD_RAID456=m
> CONFIG_MD_RAID5_RESHAPE=y
> CONFIG_MD_MULTIPATH=m
> CONFIG_MD_FAULTY=m
> CONFIG_BLK_DEV_DM=m
> CONFIG_DM_DEBUG=y
> CONFIG_DM_CRYPT=m
> CONFIG_DM_SNAPSHOT=m
> CONFIG_DM_MIRROR=m
> CONFIG_DM_ZERO=m
> CONFIG_DM_MULTIPATH=m
> # CONFIG_DM_DELAY is not set
> CONFIG_DM_UEVENT=y

and CONFIG_LBD=y


In the following code in drivers/md/dm-exception-store.c:persistent_prepare():

                            vvv
        if ((++ps->next_free % stride) == 1)
                ps->next_free++;


Caused by:

commit 7624decba23d3e7a8e7411214501cfaf19041c30
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Wed Jul 23 10:05:33 2008 +1000

    dm-exception-store-64-bit-values
    
    Change uint32_t into chunk_t to remove 32-bit limitation on the
    number of chunks on systems with 64-bit sector numbers.
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Alasdair G Kergon <agk@redhat.com>


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


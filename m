Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbXHWF1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbXHWF1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 01:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbXHWF1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 01:27:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48123 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750815AbXHWF1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 01:27:14 -0400
Message-ID: <46CD1AAE.3020708@sgi.com>
Date: Thu, 23 Aug 2007 15:27:10 +1000
From: Tim Shimmin <tes@sgi.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       xfs-masters@oss.sgi.com
Subject: Re: [BUG] fs/xfs/xfs_bmap_btree.c:2312: error: 'b' undeclared (first
 use in this function) (Was Re: 2.6.23-rc3-mm1)
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC0BC2.7060400@googlemail.com> <46CC0F8A.7040604@googlemail.com>
In-Reply-To: <46CC0F8A.7040604@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Thanks for the patch.
This would be a problem for 32bit machines without large blocksize support
(i.e. in our xfs tests: !XFS_BIG_BLKNOS => (BITS_PER_LONG == 32 && !defined(CONFIG_LBD))
which we obviously didn't do a build test for.

I'll check it into our local tree and push to the master branch for Andrew.

--Tim

Michal Piotrowski wrote:
> Michal Piotrowski pisze:
>> Andrew Morton pisze:
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
>>>
>> /home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c: In function 'xfs_bmbt_set_allf':
>> /home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2312: error: 'b' undeclared (first use in this function)
>> /home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2312: error: (Each undeclared identifier is reported only once
>> /home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2312: error: for each function it appears in.)
>> /home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c: In function 'xfs_bmbt_disk_set_allf':
>> /home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2372: error: 'b' undeclared (first use in this function)
>> make[3]: *** [fs/xfs/xfs_bmap_btree.o] Error 1
>> make[2]: *** [fs/xfs] Error 2
>> make[1]: *** [fs] Error 2
>> make: *** [_all] Error 2
>>
> 
> Build fix.
> 
> Regards,
> Michal
> 
> --
> LOG
> http://www.stardust.webpages.pl/log/
> 
> Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> 
> --- linux-mm-clean/fs/xfs/xfs_bmap_btree.c	2007-08-22 12:20:35.000000000 +0200
> +++ linux-mm/fs/xfs/xfs_bmap_btree.c	2007-08-22 12:15:52.000000000 +0200
> @@ -2309,7 +2309,7 @@ xfs_bmbt_set_allf(
>  		((xfs_bmbt_rec_base_t)blockcount &
>  		(xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
>  #else	/* !XFS_BIG_BLKNOS */
> -	if (ISNULLSTARTBLOCK(b)) {
> +	if (ISNULLSTARTBLOCK(startblock)) {
>  		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
>  			((xfs_bmbt_rec_base_t)startoff << 9) |
>  			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
> @@ -2369,7 +2369,7 @@ xfs_bmbt_disk_set_allf(
>  		 ((xfs_bmbt_rec_base_t)blockcount &
>  		  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
>  #else	/* !XFS_BIG_BLKNOS */
> -	if (ISNULLSTARTBLOCK(b)) {
> +	if (ISNULLSTARTBLOCK(startblock)) {
>  		r->l0 = cpu_to_be64(
>  			((xfs_bmbt_rec_base_t)extent_flag << 63) |
>  			 ((xfs_bmbt_rec_base_t)startoff << 9) |
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


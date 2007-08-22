Return-Path: <linux-kernel-owner+w=401wt.eu-S1760002AbXHVK1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbXHVK1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbXHVK1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:27:42 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:9478 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbXHVK1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:27:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=SfwSdnJndRwVjwqXxrFqPfVjmfOg7QHhPrfHR/aQ5dWp4caob8Cuvy8YTapugdh87S4Awjl4wRLYcuajjtLC3AB4smNUJDmVN+tYJvZJJqIY8wRyAkiOnjw4W6aRivgt0p2azjD6Yh6LxZ/wNYx+HCsWi7rY7kZU9AXRY8PJdfo=
Message-ID: <46CC0F8A.7040604@googlemail.com>
Date: Wed, 22 Aug 2007 12:27:22 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       xfs-masters@oss.sgi.com
Subject: Re: [BUG] fs/xfs/xfs_bmap_btree.c:2312: error: 'b' undeclared (first
 use in this function) (Was Re: 2.6.23-rc3-mm1)
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC0BC2.7060400@googlemail.com>
In-Reply-To: <46CC0BC2.7060400@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski pisze:
> Andrew Morton pisze:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
>>
> 
> /home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c: In function 'xfs_bmbt_set_allf':
> /home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2312: error: 'b' undeclared (first use in this function)
> /home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2312: error: (Each undeclared identifier is reported only once
> /home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2312: error: for each function it appears in.)
> /home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c: In function 'xfs_bmbt_disk_set_allf':
> /home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2372: error: 'b' undeclared (first use in this function)
> make[3]: *** [fs/xfs/xfs_bmap_btree.o] Error 1
> make[2]: *** [fs/xfs] Error 2
> make[1]: *** [fs] Error 2
> make: *** [_all] Error 2
> 

Build fix.

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm-clean/fs/xfs/xfs_bmap_btree.c	2007-08-22 12:20:35.000000000 +0200
+++ linux-mm/fs/xfs/xfs_bmap_btree.c	2007-08-22 12:15:52.000000000 +0200
@@ -2309,7 +2309,7 @@ xfs_bmbt_set_allf(
 		((xfs_bmbt_rec_base_t)blockcount &
 		(xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
 #else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(b)) {
+	if (ISNULLSTARTBLOCK(startblock)) {
 		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			((xfs_bmbt_rec_base_t)startoff << 9) |
 			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
@@ -2369,7 +2369,7 @@ xfs_bmbt_disk_set_allf(
 		 ((xfs_bmbt_rec_base_t)blockcount &
 		  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
 #else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(b)) {
+	if (ISNULLSTARTBLOCK(startblock)) {
 		r->l0 = cpu_to_be64(
 			((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			 ((xfs_bmbt_rec_base_t)startoff << 9) |


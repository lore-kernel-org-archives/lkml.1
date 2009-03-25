Return-Path: <linux-kernel-owner+w=401wt.eu-S1761786AbZCYRJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761786AbZCYRJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760843AbZCYRId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:08:33 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:45085 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760614AbZCYRIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:08:32 -0400
Message-ID: <49CA64BE.2090804@oracle.com>
Date: Wed, 25 Mar 2009 10:07:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: coly.li@suse.de
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reiserfs: select CRC32 and BITREVERSE for REISERFS_FS
 Kconfig entry
References: <49CA629E.7040701@suse.de>
In-Reply-To: <49CA629E.7040701@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49CA64DB.014C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coly Li wrote:
> In patch fs-reiserfs-return-f_fsid-for-statfs2-v2.patch (from mmotm), crc32_le()
> is referenced. If reiserfs is compiled into kernel and crc32_le() is compiled as
> kernel module, there might be a compiling error as:
>     fs/built-in.o: In function `reiserfs_statfs':
>     super.c:(.text+0x7332b): undefined reference to `crc32_le'
>     super.c:(.text+0x7333f): undefined reference to `crc32_le'
> This patch select CRC32 and BITREVERSE for REISERFS_FS Kconfig entry, which
> indicates compiling crc32_le() into kernel.
> 
> Thanks to Randy Dunlap for pointing out this error and providing helpful solution.
> 
> Signed-off-by: Coly Li <coly.li@suse.de>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Tested-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  fs/reiserfs/Kconfig |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/reiserfs/Kconfig b/fs/reiserfs/Kconfig
> index 949b8c6..9712bea 100644
> --- a/fs/reiserfs/Kconfig
> +++ b/fs/reiserfs/Kconfig
> @@ -1,5 +1,7 @@
>  config REISERFS_FS
>  	tristate "Reiserfs support"
> +	select CRC32
> +	select BITREVERSE
>  	help
>  	  Stores not just filenames but the files themselves in a balanced
>  	  tree.  Uses journalling.


-- 
~Randy

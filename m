Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZBDO4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZBDO4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZBDO4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:56:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34043 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbZBDO4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:56:10 -0500
Subject: Re: [PATCH] gfs2/ops_file.c: fix build breakage
From: Steven Whitehouse <swhiteho@redhat.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090204144920.GA13319@orion>
References: <20090204144920.GA13319@orion>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Wed, 04 Feb 2009 14:51:19 +0000
Message-Id: <1233759079.9571.689.camel@quoit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is already a patch queued up in -mm to fix this. The issue is not
that GFS2 should depend upon FILE_LOCKING but that generic_setlease
should be defined so that this reference to it is correct even when
FILE_LOCKING is not selected,

Steve.

On Wed, 2009-02-04 at 17:49 +0300, Alexander Beregalov wrote:
> fs/gfs2/ops_file.c:746: error: 'generic_setlease' undeclared here (not
> in a function)
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
> 
>  fs/gfs2/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
> index 3a981b7..97cefdf 100644
> --- a/fs/gfs2/Kconfig
> +++ b/fs/gfs2/Kconfig
> @@ -7,6 +7,7 @@ config GFS2_FS
>  	select IP_SCTP if DLM_SCTP
>  	select FS_POSIX_ACL
>  	select CRC32
> +	select FILE_LOCKING
>  	help
>  	  A cluster filesystem.
>  


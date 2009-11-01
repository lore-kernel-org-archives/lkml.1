Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbZKARgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbZKARgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 12:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZKARgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 12:36:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752911AbZKARgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 12:36:03 -0500
Date: Sun, 1 Nov 2009 09:35:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Joe Perches <joe@perches.com>, Steven Whitehouse <swhiteho@redhat.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/2] Use unified UUID/GUID definition in gfs2
Message-Id: <20091101093545.a7a4693a.akpm@linux-foundation.org>
In-Reply-To: <1255501807.6047.1193.camel@yhuang-dev.sh.intel.com>
References: <1255501807.6047.1193.camel@yhuang-dev.sh.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009 14:30:07 +0800 Huang Ying <ying.huang@intel.com> wrote:

> Replace u8[16] UUID definition in gfs2.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  fs/gfs2/incore.h            |    3 ++-
>  fs/gfs2/ops_fstype.c        |    2 +-
>  fs/gfs2/sys.c               |   14 ++++----------
>  include/linux/gfs2_ondisk.h |    3 ++-
>  4 files changed, 9 insertions(+), 13 deletions(-)
> 
> --- a/fs/gfs2/incore.h
> +++ b/fs/gfs2/incore.h
> @@ -15,6 +15,7 @@
>  #include <linux/slow-work.h>
>  #include <linux/dlm.h>
>  #include <linux/buffer_head.h>
> +#include <linux/uuid.h>
>  
>  #define DIO_WAIT	0x00000010
>  #define DIO_METADATA	0x00000020
> @@ -483,7 +484,7 @@ struct gfs2_sb_host {
>  
>  	char sb_lockproto[GFS2_LOCKNAME_LEN];
>  	char sb_locktable[GFS2_LOCKNAME_LEN];
> -	u8 sb_uuid[16];
> +	uuid_be sb_uuid;
>  };
>  

Breaks `make headers_check':

include/linux/gfs2_ondisk.h:14: included file 'linux/uuid.h' is not exported

I don't think we want to export linux/uuid.h to userspace.  But
fs/gfs2/incore.h _is_ shared with userspace, and needs linux/uuid.h.

Don't know what to do, so I'll drop the patches.

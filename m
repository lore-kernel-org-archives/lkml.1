Return-Path: <linux-kernel-owner+w=401wt.eu-S1759958AbYAJX2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958AbYAJX2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbYAJX2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:28:15 -0500
Received: from styx.suse.cz ([82.119.242.94]:32946 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752752AbYAJX2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:28:14 -0500
Date: Fri, 11 Jan 2008 00:28:12 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/16] udf: fix udf_debug macro
Message-ID: <20080110232812.GH17430@duck.suse.cz>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com> <1200002792-8449-16-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200002792-8449-16-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 10-01-08 23:06:31, marcin.slusarz@gmail.com wrote:
> udf_debug should be enclosed with do { } while (0)
> to be safely used in code like below:
> if (something)
> 	udf_debug();
> else
> 	anything;
> (Otherwise compiler will not compile it with:
> "error: expected expression before 'else'")
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> CC: Jan Kara <jack@suse.cz>
> ---
>  include/linux/udf_fs.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/udf_fs.h b/include/linux/udf_fs.h
> index 36c684e..c954527 100644
> --- a/include/linux/udf_fs.h
> +++ b/include/linux/udf_fs.h
> @@ -39,11 +39,11 @@
>  
>  #ifdef UDFFS_DEBUG
>  #define udf_debug(f, a...) \
> -	{ \
> +	do { \
>  		printk (KERN_DEBUG "UDF-fs DEBUG %s:%d:%s: ", \
>  			__FILE__, __LINE__, __FUNCTION__); \
>  		printk (f, ##a); \
> -	}
> +	} while (0)
>  #else
>  #define udf_debug(f, a...) /**/
>  #endif
  Actually, in that case you should also change /**/ to
  do {} while (0)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

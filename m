Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab0BAUom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:44:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202Ab0BAUok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:44:40 -0500
Date: Mon, 1 Feb 2010 12:44:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/5] fanotify: fix FMODE_NONOTIFY bit number
Message-Id: <20100201124424.02b7cabf.akpm@linux-foundation.org>
In-Reply-To: <20100130094957.560789869@intel.com>
References: <20100130094515.475881280@intel.com>
	<20100130094957.560789869@intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jan 2010 17:45:16 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> FMODE_NONOTIFY=0x800000 collides with __O_SYNC in sparc,
> so change it to 0x1000000.
> 
> CC: Eric Paris <eparis@redhat.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  include/asm-generic/fcntl.h |    2 +-
>  include/linux/fs.h          |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-mm.orig/include/asm-generic/fcntl.h	2010-01-13 10:16:27.000000000 +0800
> +++ linux-mm/include/asm-generic/fcntl.h	2010-01-30 17:40:48.000000000 +0800
> @@ -5,7 +5,7 @@
>  
>  /*
>   * FMODE_EXEC is 0x20
> - * FMODE_NONOTIFY is 0x800000
> + * FMODE_NONOTIFY is 0x1000000
>   * These cannot be used by userspace O_* until internal and external open
>   * flags are split.
>   * -Eric Paris
> --- linux-mm.orig/include/linux/fs.h	2010-01-30 17:14:14.000000000 +0800
> +++ linux-mm/include/linux/fs.h	2010-01-30 17:41:04.000000000 +0800
> @@ -91,7 +91,7 @@ struct inodes_stat_t {
>  #define FMODE_RANDOM		((__force fmode_t)0x1000)
>  
>  /* File was opened by fanotify and shouldn't generate fanotify events */
> -#define FMODE_NONOTIFY		((__force fmode_t)0x800000)
> +#define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
>  
>  /*
>   * The below are the various read and write types that we support. Some of
> 

Eric, please fix up "vfs: introduce FMODE_NONOTIFY" in your tree?

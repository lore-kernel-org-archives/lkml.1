Return-Path: <linux-kernel-owner+w=401wt.eu-S1751697AbZHSJug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbZHSJug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbZHSJuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:50:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:54017 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbZHSJuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NRp6Uz4cX/BaeITsKW0BI/PtoX5N+ifYQObHAqfDnE2kpuyf2G2yi5m4682OFRUm0K
         Mb7aeC4HMRFxRtn44AJGFLZQkW3QkzJqBrddNFmR75dGaze4bUNZ4iMK4DDTKCIs70Zg
         C4V6fvqMKzJzw1KcHuHs7me2SZL2FJx2annxM=
Date: Wed, 19 Aug 2009 17:52:52 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Alek Du <alek.du@intel.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Makefile: Fix size_append issue for bzip2/lzma kernel
Message-ID: <20090819095252.GB5057@cr0.nay.redhat.com>
References: <20090819173854.2250758f@dxy.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090819173854.2250758f@dxy.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 05:38:54PM +0800, Alek Du wrote:
>From 6d755cbd7a136a4314f6976275aaa6c9d10bf3e4 Mon Sep 17 00:00:00 2001
>From: Alek Du <alek.du@intel.com>
>Date: Wed, 19 Aug 2009 17:18:39 +0800
>Subject: [PATCH] Makefile: Fix size_append issue for bzip2/lzma kernel
>
>The Makefile.lib will call "echo -ne" to append uncompressed kernel size to
>bzip2/lzma kernel image. The "echo" here depends on the shell that /bin/sh pointing
>to. On Ubuntu system, the /bin/sh is pointing to dash, which does not support
>"echo -e" at all. Use /bin/echo instead of shell echo should always be safe.
>
>Signed-off-by: Alek Du <alek.du@intel.com>

Agree.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>


>---
> scripts/Makefile.lib |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
>index 7a77787..c63c941 100644
>--- a/scripts/Makefile.lib
>+++ b/scripts/Makefile.lib
>@@ -208,7 +208,7 @@ cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
> 
> # Bzip2 and LZMA do not include size in file... so we have to fake that;
> # append the size as a 32-bit littleendian number as gzip does.
>-size_append = echo -ne $(shell						\
>+size_append = /bin/echo -ne $(shell						\
> dec_size=0;								\
> for F in $1; do								\
> 	fsize=$$(stat -c "%s" $$F);					\
>-- 
>1.6.0.4
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

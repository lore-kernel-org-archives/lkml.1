Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbYEZKix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbYEZKix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 06:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYEZKiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 06:38:46 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:19968 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbYEZKip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 06:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=w/UsB1L+PQEM1ttT+Ny6KWEvE5SkMn/B9w6OVLy47eFIJesEw+2b724/SjB3Y21qAArNAURHf6ITb+BIXv260nhTvwP/EjqcIh781IzcIpv4q2Y2WHBBd6PgovF/XYqs6nK+0XGHZJIE7LXoOkqSeNCdOFmF5/VP4H+Yp9ujaxE=
Message-ID: <cfd18e0f0805260338o6d95c645oef4cfe10cca971a1@mail.gmail.com>
Date: Mon, 26 May 2008 12:38:43 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: Nadia.Derbey@bull.net
Subject: Re: [PATCH] Restore MSGPOOL original value
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080526091741.735792000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080526091716.087875000@bull.net>
	 <20080526091741.735792000@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 11:17 AM,  <Nadia.Derbey@bull.net> wrote:
> Hi,
>
> When posting:
> [PATCH 1/8] Scaling msgmni to the amount of lowmem
> (see http://article.gmane.org/gmane.linux.kernel/637849/), I have changed the
> MSGPOOL value to make it fit what is said in the man pages (i.e. a size in
> bytes).
>
> But Michael Kerrisk rightly complained that this change could affect the ABI.
> So I'm posting this patch to make MSGPOOL expressed back in Kbytes.
> Michael, on his side, has fixed the man page.
>
> This patch applies to 2.6.26-rc2-mm1.
>
> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
>
> ---
>  include/linux/msg.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-2.6.26-rc2-mm1/include/linux/msg.h
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/include/linux/msg.h       2008-05-26 11:06:53.000000000 +0200
> +++ linux-2.6.26-rc2-mm1/include/linux/msg.h    2008-05-26 11:18:34.000000000 +0200
> @@ -64,11 +64,11 @@ struct msginfo {
>  #define MSGMNB 16384   /* <= INT_MAX */   /* default max size of a message queue */
>
>  /* unused */
> -#define MSGPOOL (MSGMNI * MSGMNB) /* size in bytes of message pool */
> +#define MSGPOOL (MSGMNI * MSGMNB / 1024) /* size in kbytes of message pool */
>  #define MSGTQL  MSGMNB            /* number of system message headers */
>  #define MSGMAP  MSGMNB            /* number of entries in message map */
>  #define MSGSSZ  16                /* message segment size */
> -#define __MSGSEG (MSGPOOL / MSGSSZ) /* max no. of segments */
> +#define __MSGSEG ((MSGPOOL * 1024) / MSGSSZ) /* max no. of segments */
>  #define MSGSEG (__MSGSEG <= 0xffff ? __MSGSEG : 0xffff)
>
>  #ifdef __KERNEL__

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html

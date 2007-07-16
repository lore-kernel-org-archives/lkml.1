Return-Path: <linux-kernel-owner+w=401wt.eu-S1765430AbXGPWEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765430AbXGPWEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760358AbXGPWE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:04:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754947AbXGPWE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:04:29 -0400
Date: Mon, 16 Jul 2007 15:04:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: linux-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] potential parse error, drivers/serial/dz.h
Message-Id: <20070716150421.c21d38c5.akpm@linux-foundation.org>
In-Reply-To: <87k5t05r4a.fsf@wanadoo.fr>
References: <87k5t05r4a.fsf@wanadoo.fr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 17:02:13 +0200
Yoann Padioleau <padator@wanadoo.fr> wrote:

> 
> potential parse error in declaration under a #ifdef.

A certain parse error, I'd say.  How come nobody is reporting it?
 
> Signed-off-by: Yoann Padioleau <padator@wanadoo.fr> 
> 
> 
> diff --git a/drivers/serial/dz.h b/drivers/serial/dz.h
> index 9674d4e..9141c37 100644
> --- a/drivers/serial/dz.h
> +++ b/drivers/serial/dz.h
> @@ -125,8 +125,8 @@ #define DZ_XMIT_SIZE   4096             
>  #define DZ_WAKEUP_CHARS   DZ_XMIT_SIZE/4
>  
>  #ifdef MODULE
> -int init_module (void)
> -void cleanup_module (void)
> +int init_module (void);
> +void cleanup_module (void);
>  #endif
>  
>  #endif /* DZ_SERIAL_H */

I don't think these symbols are actually implemented in anything which
uses this header.  If they _do_ exist then they are awfully named and
should be renamed ASAP.  Or they should be made static.

However I suspect they just don't exist, and this stuff should be simply
deleted.

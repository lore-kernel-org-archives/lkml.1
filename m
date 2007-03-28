Return-Path: <linux-kernel-owner+w=401wt.eu-S933439AbXC1HPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbXC1HPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 03:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933631AbXC1HPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 03:15:01 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:35973 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933439AbXC1HPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 03:15:00 -0400
X-IronPort-AV: i="4.14,338,1170651600"; 
   d="scan'208"; a="25692077:sNHT22160880"
Subject: Re: [PATCH] revoke: generic_file_revoke stub for NOMMU
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <Pine.LNX.4.64.0703280923170.30354@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703261512120.13921@sbz-30.cs.Helsinki.FI>
	 <1175062147.15391.14.camel@roc-desktop>
	 <Pine.LNX.4.64.0703280923170.30354@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 28 Mar 2007 15:15:40 +0800
Message-Id: <1175066140.15391.21.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-28 at 09:24 +0300, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> As NOMMU does not include fs/revoke.c, we need to provide a stub for
> generic_file_revoke() so that filesystems using it compile.
> 
> Cc: Bryan Wu <bryan.wu@analog.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  include/linux/fs.h |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: uml-2.6/include/linux/fs.h
> ===================================================================
> --- uml-2.6.orig/include/linux/fs.h	2007-03-28 09:18:57.000000000 +0300
> +++ uml-2.6/include/linux/fs.h	2007-03-28 09:20:48.000000000 +0300
> @@ -1741,7 +1741,11 @@ extern long do_splice_direct(struct file
>  		size_t len, unsigned int flags);
>  
>  /* fs/revoke.c */
> +#ifdef CONFIG_MMU
>  extern int generic_file_revoke(struct file *);
> +#else
> +#define generic_file_revoke NULL
> +#endif
>  
>  extern void
>  file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);

Cool, you are so quick and your patchbomb tool is very efficient. I will
test it on my side ASAP.

Thanks
-Bryan

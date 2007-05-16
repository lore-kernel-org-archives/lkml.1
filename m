Return-Path: <linux-kernel-owner+w=401wt.eu-S1763105AbXEPTlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763105AbXEPTlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbXEPTlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:41:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47491 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbXEPTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:41:08 -0400
Date: Wed, 16 May 2007 20:41:01 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ALPHA: TITAN - check for allocated memory
Message-ID: <20070516194101.GK4095@ftp.linux.org.uk>
References: <20070516181332.GB16348@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516181332.GB16348@cvg>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 10:13:32PM +0400, Cyrill Gorcunov wrote:
> This patch adds checking for allocated memory
> which is used to hold AGP info. Also some whitespace
> cleanup.

Could you please not do that again?  Whitespace cleanup is nice as a separate
followup, but as it is it just obscures the real changes in patch.  Digging
out

> @@ -767,6 +767,11 @@ titan_agp_info(void)
>  	 * Allocate the info structure.
>  	 */
>  	agp = kmalloc(sizeof(*agp), GFP_KERNEL);
> +	if (agp == NULL) {
> +		printk(KERN_ERR "TITAN - cannot allocate struct of size %d bytes\n",
> +		       sizeof(*agp));
> +		return NULL;
> +	}

out of hundreds of lines in patch just makes review harder.  Incidentally,
%d is not size_t, it's int.  Use %zu, please.

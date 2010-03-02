Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0CBWwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:52:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224Ab0CBWwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:52:39 -0500
Date: Tue, 2 Mar 2010 14:52:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] inflate_fast: sout is already a short so ptr arith
 was off by one.
Message-Id: <20100302145231.5f3f0fb0.akpm@linux-foundation.org>
In-Reply-To: <1267373163-10841-1-git-send-email-Joakim.Tjernlund@transmode.se>
References: <1267373163-10841-1-git-send-email-Joakim.Tjernlund@transmode.se>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Feb 2010 17:06:02 +0100
Joakim Tjernlund <Joakim.Tjernlund@transmode.se> wrote:

> This won't change anything for current code, but post increment
> will break without this fix, should anyone want to try that.
> 

The description is a bit cryptic.  Hopefully you understand what you
mean, but does anyone else?

> diff --git a/lib/zlib_inflate/inffast.c b/lib/zlib_inflate/inffast.c
> index fa62fc7..2c13ecc 100644
> --- a/lib/zlib_inflate/inffast.c
> +++ b/lib/zlib_inflate/inffast.c
> @@ -286,7 +286,7 @@ void inflate_fast(z_streamp strm, unsigned start)
>  		    } else { /* dist == 1 or dist == 2 */
>  			unsigned short pat16;
>  
> -			pat16 = *(sout-2+2*OFF);
> +			pat16 = *(sout-1+OFF);
>  			if (dist == 1) {
>  				union uu mm;
>  				/* copy one char pattern to both bytes */

The code you're altering was changed two months ago by, err, you.  I
don't know if the patch still makes sense in current kernels.

Please don't raise patches against old kernels.  Please check that,
redo the patch, add a changelog which helps non-inffast.c people
understand what it does, then resend?


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbZBCIwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbZBCIwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 03:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZBCIwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 03:52:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbZBCIwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 03:52:03 -0500
Date: Tue, 3 Feb 2009 00:51:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] bio.h: If they MUST be inlined, then use
 __always_inline
Message-Id: <20090203005141.0214d47b.akpm@linux-foundation.org>
In-Reply-To: <1233533251-30240-2-git-send-email-albertito@blitiri.com.ar>
References: <1233533251-30240-1-git-send-email-albertito@blitiri.com.ar>
	<1233533251-30240-2-git-send-email-albertito@blitiri.com.ar>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  1 Feb 2009 22:07:31 -0200 Alberto Bertogli <albertito@blitiri.com.ar> wrote:

> bvec_kmap_irq() and bvec_kunmap_irq() comments say they MUST be inlined,
> so mark them as __always_inline.
> 
> Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
> ---
>  include/linux/bio.h |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 0c8e3fb..713ec6e 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -445,7 +445,8 @@ extern struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly;
>   *
>   * This function MUST be inlined - it plays with the CPU interrupt flags.
>   */
> -static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
> +static __always_inline char *bvec_kmap_irq(struct bio_vec *bvec,
> +		unsigned long *flags)

The comment is wrong - this was a sparc requirement, long since removed.

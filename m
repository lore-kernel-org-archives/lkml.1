Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYGERKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYGERKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYGERK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:10:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55547 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYGERK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:10:26 -0400
Date: Sat, 5 Jul 2008 13:10:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Deinline a few functions in mmap.c
Message-ID: <20080705171024.GA4723@infradead.org>
References: <200807051837.30219.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807051837.30219.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 06:37:30PM +0200, Denys Vlasenko wrote:
>  #if defined(CONFIG_STACK_GROWSUP) || defined(CONFIG_IA64)
>  /*
>   * PA-RISC uses this for its stack; IA64 for its Register Backing Store.
>   * vma is the last one with address > vma->vm_end.  Have to extend vma.
>   */
>  #ifndef CONFIG_IA64
> -static inline
> +static
>  #endif

Unrelated note, but I think this ifdef should go.  We've always prefered
slightly less possible optimizations over horribly ugly ifdefs.


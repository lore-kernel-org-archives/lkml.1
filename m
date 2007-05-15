Return-Path: <linux-kernel-owner+w=401wt.eu-S1760386AbXEOXgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386AbXEOXgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 19:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758137AbXEOXgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:36:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38093 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758118AbXEOXgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:36:42 -0400
Date: Tue, 15 May 2007 16:33:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: mroos@linux.ee, David Miller <davem@davemloft.net>,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: slab hang on boot
Message-Id: <20070515163321.744e2388.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705141642350.13606@schroedinger.engr.sgi.com>
References: <Pine.SOC.4.64.0705142133190.17204@math>
	<20070514.151148.45744375.davem@davemloft.net>
	<Pine.LNX.4.64.0705141642350.13606@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 16:46:17 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> @@ -86,6 +87,9 @@ static inline int kmalloc_index(int size
>  	 */
>  	WARN_ON_ONCE(size == 0);
>  
> +	if (size >= (1UL << KMALLOC_SHIFT_HIGH))
> +		return -1;
> +

I don't quite understand why we did this.  The subsequent logic in
kmalloc_index() should return -1 for this `size' anyway.  If it doesn't,
it's bust, isn't it?

Also, afaict kmalloc_slab() will totally mishandle the -1 return value and
will return a garbage kmem_cache*, via

        return &kmalloc_caches[index];


Could you double-check it all please?

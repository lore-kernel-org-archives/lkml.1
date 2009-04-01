Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbZDAA12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbZDAA12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbZDAA1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:27:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42634 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbZDAA1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:27:16 -0400
Date: Wed, 1 Apr 2009 02:23:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, juan.villacis@intel.com, ak@linux.jf.intel.com
Subject: Re: [patch 4/21] mm: refund memory for a locked buffer
Message-ID: <20090401002334.GD28228@redhat.com>
References: <20090331150319.A12691@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331150319.A12691@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Markus Metzger wrote:
>
> -void release_locked_buffer(void *buffer, size_t size)
> +void refund_locked_buffer_memory(struct mm_struct *mm, size_t size)

Hmm. Again, this is not bisect friendly, afaoics the kernel can't be
compiled with this patch. Irenames release_locked_buffer(), but we still
have callers (fixed by the next patches).

>  void free_locked_buffer(void *buffer, size_t size)
>  {
> -	release_locked_buffer(buffer, size);
> -
> +	refund_locked_buffer_memory(current->mm, size);
>  	kfree(buffer);
>  }

And this one has no callers after the next patches?

Oleg.


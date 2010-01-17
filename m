Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918Ab0AQPnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0AQPnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 10:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239Ab0AQPnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 10:43:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60033 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab0AQPnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 10:43:49 -0500
Date: Sun, 17 Jan 2010 10:43:43 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 06/12] Add get_user_pages() variant that fails if
	major fault is required.
Message-ID: <20100117154343.GA27123@infradead.org>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com> <1262700774-1808-7-git-send-email-gleb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262700774-1808-7-git-send-email-gleb@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 04:12:48PM +0200, Gleb Natapov wrote:
> This patch add get_user_pages() variant that only succeeds if getting
> a reference to a page doesn't require major fault.

>  
> +int get_user_pages_noio(struct task_struct *tsk, struct mm_struct *mm,
> +		unsigned long start, int nr_pages, int write, int force,
> +		struct page **pages, struct vm_area_struct **vmas)
> +{
> +	int flags = FOLL_TOUCH | FOLL_MINOR;
> +
> +	if (pages)
> +		flags |= FOLL_GET;
> +	if (write)
> +		flags |= FOLL_WRITE;
> +	if (force)
> +		flags |= FOLL_FORCE;
> +
> +	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas);

Wouldn't it be better to just export __get_user_pages as a proper user
interface, maybe replacing get_user_pages by it entirely?


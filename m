Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbZJ3VWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbZJ3VWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 17:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932877AbZJ3VWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 17:22:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932872AbZJ3VWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 17:22:31 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org, zach.brown@oracle.com
Subject: Re: [patch] aio: Don't zero out the pages array inside struct dio
References: <x49tyxhroes.fsf@segfault.boston.devel.redhat.com>
	<20091030141811.1c77571b.akpm@linux-foundation.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 30 Oct 2009 17:22:27 -0400
In-Reply-To: <20091030141811.1c77571b.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 30 Oct 2009 14:18:11 -0700")
Message-ID: <x49hbtgr2zw.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> You forgot something:
>
> --- a/fs/direct-io.c~aio-dont-zero-out-the-pages-array-inside-struct-dio-fix
> +++ a/fs/direct-io.c
> @@ -130,6 +130,12 @@ struct dio {
>  	unsigned head;			/* next page to process */
>  	unsigned tail;			/* last valid page + 1 */
>  	int page_errors;		/* errno from get_user_pages() */
> +
> +	/*
> +	 * pages[] (and any fields placed after it) are not zeroed out at
> +	 * allocation time.  Don't add new fields after pages[] unless you
> +	 * wish that they not be zeroed.
> +	 */
>  	struct page *pages[DIO_PAGES];	/* page buffer */
>  };
>  

Yeah, that makes sense.  Thanks for adding it, Andrew.  Oh, and it looks
like I botched the subject line.  It should have read dio, not aio, but
I'm not sure that matters a whole lot.

Cheers,
Jeff

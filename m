Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbXKSVRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbXKSVRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXKSVRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:17:10 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39835 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbXKSVRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:17:09 -0500
Subject: Re: [Patch] mm/sparse.c: Check the return value of
	sparse_index_alloc().
From: Dave Hansen <haveblue@us.ibm.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <clameter@sgi.com>, Andrew Morton <akpm@osdl.org>,
       linux-mm@kvack.org
In-Reply-To: <20071115135428.GE2489@hacking>
References: <20071115135428.GE2489@hacking>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 13:17:02 -0800
Message-Id: <1195507022.27759.146.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-15 at 21:54 +0800, WANG Cong wrote:
> Since sparse_index_alloc() can return NULL on memory allocation failure,
> we must deal with the failure condition when calling it.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: Christoph Lameter <clameter@sgi.com>
> Cc: Rik van Riel <riel@redhat.com>
> 
> ---
> 
> diff --git a/Makefile b/Makefile
> diff --git a/mm/sparse.c b/mm/sparse.c
> index e06f514..d245e59 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -83,6 +83,8 @@ static int __meminit sparse_index_init(unsigned long section_nr, int nid)
>  		return -EEXIST;
> 
>  	section = sparse_index_alloc(nid);
> +	if (!section)
> +		return -ENOMEM;
>  	/*
>  	 * This lock keeps two different sections from
>  	 * reallocating for the same index

Oddly enough, sparse_add_one_section() doesn't seem to like to check
its allocations.  The usemap is checked, but not freed on error.  If you
want to fix this up, I think it needs a little more love than just two
lines.  

Do you want to try to add some actual error handling to
sparse_add_one_section()?

-- Dave


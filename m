Return-Path: <linux-kernel-owner+w=401wt.eu-S1763602AbXGFRSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763602AbXGFRSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbXGFRSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:18:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:25506 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbXGFRSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=tjc2OmPe5obpc5OVd4kJkanytM+UR9b9Cp1FzcbYlMfK8iPqsZ8wzZStoomnloMQLCSlfiDf/Pt5noa3glX0jQQT2P4/8KhL782bcxSRWNKt7IVHmZjX6KskDnMU2faCea7x0ieeZcHI1zoJOErc26F9w0TU7B/yZ/Ys7j0wIoY=
Date: Fri, 6 Jul 2007 21:18:37 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>, riel <riel@redhat.com>
Subject: Re: [PATCH] mm: fixup /proc/vmstat output
Message-ID: <20070706171837.GA5763@martell.zuzino.mipt.ru>
References: <1183721734.7054.102.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183721734.7054.102.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 01:35:34PM +0200, Peter Zijlstra wrote:
> Line up the vmstat_text with zone_stat_item
> 
> enum zone_stat_item {
> 	/* First 128 byte cacheline (assuming 64 bit words) */
> 	NR_FREE_PAGES,
> 	NR_INACTIVE,
> 	NR_ACTIVE,
> 
> We current have nr_active and nr_inactive reversed.

OK with patch, though using initializers canbe handy to prevent such
things in future:

	static const char * const vmstat_text[] = {
		[NR_FREE_PAGES] = "nr_free_pages",
		...

> --- linux-2.6.orig/mm/vmstat.c
> +++ linux-2.6/mm/vmstat.c
> @@ -700,8 +700,8 @@ const struct seq_operations pagetypeinfo
>  static const char * const vmstat_text[] = {
>  	/* Zoned VM counters */
>  	"nr_free_pages",
> -	"nr_active",
>  	"nr_inactive",
> +	"nr_active",
>  	"nr_anon_pages",
>  	"nr_mapped",
>  	"nr_file_pages",


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbYBFGDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbYBFGDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 01:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYBFGDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 01:03:18 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:41544 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbYBFGDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 01:03:16 -0500
Date: Wed, 6 Feb 2008 11:32:56 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Willy Tarreau <w@1wt.eu>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: {2.6.22.y} quicklists must keep even off node pages on the
	quicklists until the TLB flush has been completed.
Message-ID: <20080206060256.GA3836@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <6101e8c40802051306y24cc7740g4c75508035aaefd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40802051306y24cc7740g4c75508035aaefd@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 10:06:02PM +0100, Oliver Pinter wrote:
> it is already im queue for 2.6.23,
> 
> ----8<-----
> >From stable-bounces@linux.kernel.org Sat Dec 22 14:04:08 2007
> From: Christoph Lameter <clameter@sgi.com>
> Date: Sat, 22 Dec 2007 14:03:23 -0800
> Subject: quicklists: do not release off node pages early
> To: torvalds@linux-foundation.org
> Cc: stable@kernel.org, akpm@linux-foundation.org,
> dhaval@linux.vnet.ibm.com, clameter@sgi.com
> Message-ID: <200712222203.lBMM3Nsk021922@imap1.linux-foundation.org>
> 
> 
> From: Christoph Lameter <clameter@sgi.com>
> 
> patch ed367fc3a7349b17354c7acef551533337764859 in mainline.
> 
> quicklists must keep even off node pages on the quicklists until the TLB
> flush has been completed.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  include/linux/quicklist.h |    8 --------
>  1 file changed, 8 deletions(-)
> 
> --- a/include/linux/quicklist.h
> +++ b/include/linux/quicklist.h
> @@ -56,14 +56,6 @@ static inline void __quicklist_free(int
>  	struct page *page)
>  {
>  	struct quicklist *q;
> -	int nid = page_to_nid(page);
> -
> -	if (unlikely(nid != numa_node_id())) {
> -		if (dtor)
> -			dtor(p);
> -		__free_page(page);
> -		return;
> -	}
> 
>  	q = &get_cpu_var(quicklist)[nr];
>  	*(void **)p = q->page;
> 
> ---->8------
> Tested-by: Oliver Pinter <oliver.pntr@gmail.com> (on i386)
> 

Christoph,

Is this one also supposed to be backported?

-- 
regards,
Dhaval

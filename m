Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbYGERzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbYGERzX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757084AbYGERlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:41:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756869AbYGERlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:41:09 -0400
Date: Sat, 5 Jul 2008 10:40:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linuxfoundation.org,
       akpm@linuxfoundation.org, mpm@selenic.com, linux-kernel@vger.kernel.org
Subject: Re: *sigh* /proc/*/pagemap
In-Reply-To: <20080704185312.052e7145.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807051036000.2815@woody.linux-foundation.org>
References: <b6fcc0a0807041807p24cce461m419d7b54fce72d34@mail.gmail.com> <20080704185312.052e7145.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Jul 2008, Andrew Morton wrote:
>  	int pagecount;
>  	int ret = -ESRCH;
> +	static struct mm_walk pagemap_walk;
>  
...
>  
> +	pagemap_walk.pmd_entry = pagemap_pte_range;
> +	pagemap_walk.pte_hole = pagemap_pte_hole;
> +	pagemap_walk.mm = mm;
> +	pagemap_walk.private = &pm;
> +

No can do. You have one single pagemap_walk, but perhaps multiple users, 
who all disagree about what it should contain.

Quite frankly, I think we should just remove the whole f*cking crap. I 
think it's also potentially a security hole to give physical page 
information and swap info - even if it's just your own pages.

Matt, can you explain what the point was of this whole thing? I'm really 
_this_ close to just removing the POS right now. It's been a big source of 
bugs, and it looks entirely pointless.

		Linus

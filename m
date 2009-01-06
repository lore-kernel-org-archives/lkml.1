Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZAFQRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZAFQRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZAFQQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:16:39 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53875 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446AbZAFQQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:16:38 -0500
X-Sasl-enc: JUvt7xXgd+E5CF+KyTCS3JXSsN78/rhvL5BHF2tiSqb2 1231258595
Message-ID: <496383E0.50102@ftml.net>
Date: Tue, 06 Jan 2009 10:16:32 -0600
From: Roman Kononov <kononov@ftml.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Nick Piggin <npiggin@suse.de>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Klotz <peter.klotz@aon.at>, stable@kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Kononov <kernel@kononov.ftml.net>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] mm: fix lockless pagecache reordering bug (was Re: BUG:
 soft lockup - is this XFS problem?)
References: <20090105041959.GC367@wotan.suse.de> <20090105064838.GA5209@wotan.suse.de> <49623384.2070801@aon.at> <20090105164135.GC32675@wotan.suse.de> <alpine.LFD.2.00.0901050859430.3057@localhost.localdomain> <20090105180008.GE32675@wotan.suse.de> <alpine.LFD.2.00.0901051027011.3057@localhost.localdomain> <20090105201258.GN6959@linux.vnet.ibm.com> <alpine.LFD.2.00.0901051224110.3057@localhost.localdomain> <20090105215727.GQ6959@linux.vnet.ibm.com> <20090106020550.GA819@wotan.suse.de>
In-Reply-To: <20090106020550.GA819@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-01-05 20:05 Nick Piggin said the following:
> Subject: mm lockless pagecache barrier fix
>  static inline void *radix_tree_deref_slot(void **pslot)
>  {
> -	void *ret = *pslot;
> +	void *ret = rcu_dereference(*pslot);
>  	if (unlikely(radix_tree_is_indirect_ptr(ret)))
>  		ret = RADIX_TREE_RETRY;
>  	return ret;

3 systems are working fine for a few hours with the patch. They would 
fail within 20 minutes without it.

Thanks.


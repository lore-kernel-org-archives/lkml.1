Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYLBNRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYLBNRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbYLBNRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:17:40 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:42959 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYLBNRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:17:39 -0500
Date: Tue, 2 Dec 2008 07:12:01 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Russ Anderson <rja@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Jones <davej@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/8] badpage: simplify page_alloc flag check+clear
In-Reply-To: <Pine.LNX.4.64.0812020947440.5306@blonde.anvils>
Message-ID: <Pine.LNX.4.64.0812020710371.9474@quilx.com>
References: <Pine.LNX.4.64.0812010032210.10131@blonde.site>
 <Pine.LNX.4.64.0812010038220.11401@blonde.site> <Pine.LNX.4.64.0812010843230.15331@quilx.com>
 <Pine.LNX.4.64.0812012349330.18893@blonde.anvils> <Pine.LNX.4.64.0812012014150.30344@quilx.com>
 <Pine.LNX.4.64.0812020947440.5306@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2008, Hugh Dickins wrote:

> > But they are always clear on free. The checking is irrelevant.
>
> How about CHECK_PAGE_FLAGS_CLEAR_AT_FREE?

Strange name.

> The one I really disliked was "PAGE_FLAGS" for an obscure
> subset of page flags, and have got rid of that.

Good.

> > If (page->flags & (all the flags including dirty and SwapBacked))
> > 	zap-em.
>
> That's exactly what I did, isn't it?

Yes but you added another instance of this. Can you consolidate all the
check and clears into one?


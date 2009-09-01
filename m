Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbZIANso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbZIANso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbZIANsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:48:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37655 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbZIANsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:48:42 -0400
Subject: Re: page allocator regression on nommu
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <12589.1251812805@redhat.com>
References: <20090831102642.GA30264@linux-sh.org>
	 <20090831074842.GA28091@linux-sh.org>
	 <84144f020908310308i48790f78g5a7d73a60ea854f8@mail.gmail.com>
	 <12589.1251812805@redhat.com>
Date: Tue, 01 Sep 2009 16:48:43 +0300
Message-Id: <1251812923.4720.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 14:46 +0100, David Howells wrote:
> From: David Howells <dhowells@redhat.com>
> Subject: [PATCH] NOMMU: Fix error handling in do_mmap_pgoff()
> 
> Fix the error handling in do_mmap_pgoff().  If do_mmap_shared_file() or
> do_mmap_private() fail, we jump to the error_put_region label at which point we
> cann __put_nommu_region() on the region - but we haven't yet added the region
> to the tree, and so __put_nommu_region() may BUG because the region tree is
> empty or it may corrupt the region tree.
> 
> To get around this, we can afford to add the region to the region tree before
> calling do_mmap_shared_file() or do_mmap_private() as we keep nommu_region_sem
> write-locked, so no-one can race with us by seeing a transient region.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Looks sane to me. FWIW:

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

			Pekka


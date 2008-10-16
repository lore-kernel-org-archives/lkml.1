Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbYJPTw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbYJPTw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbYJPTwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:52:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753777AbYJPTwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:52:20 -0400
Message-ID: <48F79B42.3070106@linux-foundation.org>
Date: Thu, 16 Oct 2008 14:51:30 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nathalie Furmento <nathalie.furmento@labri.fr>
Subject: Re: [PATCH 4/5] mm: rework do_pages_move() to work on page_sized
 chunks
References: <48F3AD47.1050301@inria.fr> <48F3AE1D.3060208@inria.fr>
In-Reply-To: <48F3AE1D.3060208@inria.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brice Goglin wrote:

> +	err = -ENOMEM;
> +	pm = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!pm)

ok.... But if you need a page sized chunk then you can also do
	get_zeroed_page(GFP_KERNEL). Why bother the slab allocator for page 		sized
allocations?


> +	chunk_nr_pages = PAGE_SIZE/sizeof(struct page_to_node) - 1;

Blanks missing.



> +		/* fill the chunk pm with addrs and nodes from user-space */
> +		for (j = 0; j < chunk_nr_pages; j++) {

j? So the chunk_start used to be i?


Acked-by: Christoph Lameter <cl@linux-foundation.org>

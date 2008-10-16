Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbYJPVTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbYJPVTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 17:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbYJPVT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 17:19:26 -0400
Received: from iona.labri.fr ([147.210.8.143]:41544 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196AbYJPVTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 17:19:25 -0400
Message-ID: <48F7AFA0.1080100@inria.fr>
Date: Thu, 16 Oct 2008 23:18:24 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nathalie Furmento <nathalie.furmento@labri.fr>
Subject: Re: [PATCH 4/5] mm: rework do_pages_move() to work on page_sized
 chunks
References: <48F3AD47.1050301@inria.fr> <48F3AE1D.3060208@inria.fr> <48F79B42.3070106@linux-foundation.org>
In-Reply-To: <48F79B42.3070106@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
>> +	err = -ENOMEM;
>> +	pm = kmalloc(PAGE_SIZE, GFP_KERNEL);
>> +	if (!pm)
>>     
>
> ok.... But if you need a page sized chunk then you can also do
> 	get_zeroed_page(GFP_KERNEL). Why bother the slab allocator for page 		sized
> allocations?
>   

Right. But why get_zeroed_page()? I don't think I need anything zeroed
(and I needed so, I would have to zero again between each chunk).

alloc_pages(order=0)+__free_pages() is probably good.

>> +		/* fill the chunk pm with addrs and nodes from user-space */
>> +		for (j = 0; j < chunk_nr_pages; j++) {
>>     
>
> j? So the chunk_start used to be i?
>   

The original "i" is somehow "chunk_start+j" now.

Thanks Christoph, I'll send an updated "4/5" patch in the next days.

Brice


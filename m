Return-Path: <linux-kernel-owner+w=401wt.eu-S933274AbXCURtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbXCURtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 13:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933283AbXCURtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 13:49:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933274AbXCURta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 13:49:30 -0400
Message-ID: <460163AA.4050901@redhat.com>
Date: Wed, 21 Mar 2007 12:56:10 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061004)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Nikita Danilov <nikita@clusterfs.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] split file and anonymous page queues #3
References: <46005B4A.6050307@redhat.com>	<17920.61568.770999.626623@gargle.gargle.HOWL>	<460115D9.7030806@redhat.com> <17921.7074.900919.784218@gargle.gargle.HOWL> <46011E8F.2000109@redhat.com> <4601598A.7060904@redhat.com>
In-Reply-To: <4601598A.7060904@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:

> I think you're going to have to use refault rates. AIX 3.5 had
> to add that. Something like:
> 
> if refault_rate(anonymous/mmap) > refault_rate(pagecache)
>    drop a pagecache page
> else
>    drop either

How about the opposite?

If the page cache refault rate is way higher than the
anonymous refault rate, did you favor page cache?

Btw, just a higher fault rate will already make that
cache grow faster than the other, simply because it
will have more allocations than the other cache and
they both get shrunk to some degree...

> You do have anonymous memory and mmapped executables in the same
> queue, right?

Nope.  It is very hard to see the difference between mmapped
executables and mmapped data from any structure linked off
the struct page...

-- 
All Rights Reversed

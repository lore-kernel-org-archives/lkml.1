Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbXIQUrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbXIQUrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbXIQUrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:47:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181AbXIQUrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:47:12 -0400
Message-ID: <46EEE7B7.1070206@redhat.com>
Date: Mon, 17 Sep 2007 16:46:47 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       marc.smith@esmail.mcc.edu
Subject: Re: VM/VFS bug with large amount of memory and file systems?
References: <C2A8AED2-363F-4131-863C-918465C1F4E1@cam.ac.uk>	<1189850897.21778.301.camel@twins>	<20070915035228.8b8a7d6d.akpm@linux-foundation.org>	<13126578-A4F8-43EA-9B0D-A3BCBFB41FEC@cam.ac.uk>	<20070917163257.331c7605@twins>	<46EEB532.3060804@redhat.com> <20070917131526.e8db80fe.akpm@linux-foundation.org>
In-Reply-To: <20070917131526.e8db80fe.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 17 Sep 2007 13:11:14 -0400
> Rik van Riel <riel@redhat.com> wrote:

>> IIRC I simply kept a list of all buffer heads and walked
>> that to reclaim pages when the number of buffer heads is
>> too high (and we need memory).  This list can be maintained
>> in places where we already hold the lock for the buffer head
>> freelist, so there should be no additional locking overhead
>> (again, IIRC).
> 
> Christoph's slab defragmentation code should permit us to fix this:
> grab a page of buffer_heads off the slab lists, trylock the page,
> strip the buffer_heads.  I think that would be a better approach
> if we can get it going because it's more general.

Is the slab defragmentation code in -mm or upstream already
or can I find it on the mailing list?

I've implemented code like you describe already, just give me
a few days to become familiar with the slab defragmentation
code and I'll get you a patch.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.

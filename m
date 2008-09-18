Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbYIRU6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbYIRU6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 16:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbYIRU6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 16:58:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55270 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbYIRU6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 16:58:06 -0400
Message-ID: <48D2BFB8.6010503@redhat.com>
Date: Thu, 18 Sep 2008 16:53:12 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Martin Bligh <mbligh@google.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org> <48D1625C.7000309@redhat.com>	 <48D17A93.4000803@goop.org> <48D29AFB.5070409@linux-foundation.org>	 <48D2A392.6010308@goop.org> <33307c790809181352h14f2cf26kc73de75b939177b5@mail.gmail.com>
In-Reply-To: <33307c790809181352h14f2cf26kc73de75b939177b5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Bligh wrote:
>> Thanks, that was exactly what I was hoping to see.  I didn't see any
>> definitive statements against the patch set, other than a concern that
>> it could make things worse.  Was the upshot that no consensus was
>> reached about how to detect when its beneficial to preallocate anonymous
>> pages?
>>
>> Martin, in that thread you mentioned that you had tried pre-populating
>> file-backed mappings as well, but "Mmmm ... we tried doing this before
>> for filebacked pages by sniffing the
>> pagecache, but it crippled forky workloads (like kernel compile) with the
>> extra cost in zap_pte_range, etc. ".
>>
>> Could you describe, or have a pointer to, what you tried and how it
>> turned out?
> 
> Don't have the patches still, but it was fairly simple - just faulted in
> the next 3 pages whenever we took a fault, if the pages were already
> in pagecache. I would have thought that was pretty lightweight and
> non-invasive, but turns out it slowed things down.
> 
>> Did you end up populating so many (unused) ptes that
>> zap_pte_range needed to do lots more work?
> 
> Yup, basically you're assuming good locality of reference, but it turns
> out that (as davej would say) "userspace sucks".

Well, *most* userspace sucks.  It might still be worthwhile to do this when 
userspace is using madvise().

-- Chris

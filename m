Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbYIRWST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbYIRWST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 18:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYIRWSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 18:18:09 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:24239 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbYIRWSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 18:18:08 -0400
Message-ID: <8f3aa8d60809181518r697b5d7cp9e154fe73f804cc7@mail.gmail.com>
Date: Thu, 18 Sep 2008 15:18:05 -0700
From: "Martin Bligh" <mbligh@mbligh.org>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: Populating multiple ptes at fault time
Cc: "Martin Bligh" <mbligh@google.com>, "MinChan Kim" <minchan.kim@gmail.com>,
       "Chris Snook" <csnook@redhat.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Hugh Dickens" <hugh@veritas.com>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <48D2D22B.2070408@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D142B2.3040607@goop.org> <48D2BFB8.6010503@redhat.com>
	 <33307c790809181411j41a6fc4ev8560a13ed8661ec2@mail.gmail.com>
	 <48D2C46A.5030702@linux-foundation.org>
	 <33307c790809181421k52ed6a36h9d4ee40d5799a536@mail.gmail.com>
	 <48D2C8DD.4040303@linux-foundation.org>
	 <28c262360809181449v1050c1f7ndf17dadba9fac0bf@mail.gmail.com>
	 <48D2CEF3.6060308@linux-foundation.org>
	 <33307c790809181508v2e64c0a4j8f0e93df99673e63@mail.gmail.com>
	 <48D2D22B.2070408@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> My patches were only for anonymous pages not for file backed because readahead
>>> is available for file backed mappings.
>>
>> Do we populate the PTEs though? I didn't think that was batched, but I
>> might well be wrong.
>
> We do not populate the PTEs and AFAICT PTE population was assumed not to be
> performance critical since the backing media is comparatively slow.

I think the times when this matters are things like glibc, which are
heavily shared -
we were only 'prefaulting' when the pagecache was already there. So it's a case
for a "readahead like algorithm", not necessarily a direct hook.

Anonymous pages seem much riskier, as presumably there's a no backing page
except in the fork case.

I presume the reason Jeremy is interested is because his pagefaults are more
expensive than most (under virtualization), so he may well find a
different tradeoff
than I did (try running kernbench?)

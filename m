Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbZEHRlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbZEHRlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 13:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbZEHRl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 13:41:27 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:50991 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbZEHRl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 13:41:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xPpEL4LKkV/i9MxYgJVy2eq3GjlYZsYCmzwNSwmteo9AqfVnLjJYdXvjOB1VVWMrW3
         DN6jbXV/uqe1nOnpE8mllwLxd+6DWVBPWTxUw/A4msRR6rdNHIuLXJbBhcevXA4rFNm4
         Yj1tLulEpjC6QUZwVc1eJM/G+/K8b8iQ6teBs=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0905081022490.23875@qirst.com>
References: <20090430215034.4748e615@riellaptop.surriel.com>
	 <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins>
	 <20090507121101.GB20934@localhost> <20090507151039.GA2413@cmpxchg.org>
	 <20090508030209.GA8892@localhost>
	 <20090508163042.ba4ef116.minchan.kim@barrios-desktop>
	 <20090508080921.GA25411@localhost>
	 <20090508183427.f313770f.minchan.kim@barrios-desktop>
	 <alpine.DEB.1.10.0905081022490.23875@qirst.com>
Date: Sat, 9 May 2009 02:41:26 +0900
X-Google-Sender-Auth: 2a28b4fc062f71ee
Message-ID: <2f11576a0905081041nb26140bx56394f8e232fb59e@mail.gmail.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class 
	citizen
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > > Why did you said that "The page_referenced() path will only cover the ""_text_"" section" ?
>> > > Could you elaborate please ?
>> >
>> > I was under the wild assumption that only the _text_ section will be
>> > PROT_EXEC mapped.  No?
>>
>> Yes. I support your idea.
>
> Why do PROT_EXEC mapped segments deserve special treatment? What about the
> other memory segments of the process? Essentials like stack, heap and
> data segments of the libraries?

Currently, file-backed page and swap-backed page are lived in separate lru.

text section: file
stack: anon
heap: anon
data segment: anon

and, streaming IO problem don't affect swap-backed lru. it's only
file-backed lru problem.

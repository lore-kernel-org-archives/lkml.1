Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbYGUDxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbYGUDxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 23:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932090AbYGUDxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 23:53:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:60532 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbYGUDxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 23:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=kNu8it2Kt8KxtTrdbEgfBXcXr119qRRvg8UBZSvAKKZ0VHf080zy90ItyOaIQrcXCu
         /NxDDxAkDebZE21riuYd18GloIQX1vhlpUfG28eABbsOlTo39emyqm53ajYr+326HxOd
         M2dfvUwaPDFjkGzCGo6g3czZ3TAL9/Mhomcco=
Message-ID: <2f11576a0807202053m858ef54r68e9ba637801e9e0@mail.gmail.com>
Date: Mon, 21 Jul 2008 12:53:23 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] mm: more likely reclaim MADV_SEQUENTIAL mappings
Cc: "Johannes Weiner" <hannes@saeurebad.de>, "Rik van Riel" <riel@redhat.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       Nossum <vegard.nossum@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080720184843.9f7b48e9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87y73x4w6y.fsf@saeurebad.de>
	 <2f11576a0807201709q45aeec3cvb99b0049421245ae@mail.gmail.com>
	 <20080720184843.9f7b48e9.akpm@linux-foundation.org>
X-Google-Sender-Auth: c57ec327508c7432
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

>> in my experience,
>>   - page_referenced_one is performance critical point.
>>     you should test some benchmark.
>>   - its patch improved mmaped-copy performance about 5%.
>>     (Of cource, you should test in current -mm. MM code was changed widely)
>>
>> So, I'm looking for your test result :)
>
> The change seems logical and I queued it for 2.6.28.

Great.

> But yes, testing for what-does-this-improve is good and useful, but so
> is testing for what-does-this-worsen.  How do we do that in this case?

In general, page_referenced_one is important for reclaim throuput.
if crap page_referenced_one changing happend,
system reclaim throuput become slow down.

Of cource, I don't think this patch cause performance regression :-)

So, any benchmark with memcgroup memory restriction is good choice.

btw:
maybe, I will able to post mamped-copy improve mesurement of Johannes's patch
after OLS.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbZELLgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbZELLgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbZELLgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:36:39 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:26414 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbZELLgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FnxBg4Zz1htWB6NtBAqyQL3Y7rd3uuNWLyPUppLw7sxChjxXe9TqOpPe2nh/a2mNkv
         Ipb42Lr/e8hISjUAyb93Uohj/qQAswRcg7GEhn0igjOIbJE9AIgdhAi7LvekBJOdt8h3
         hNqjXzBO2kvyE/34HXXhzlsKLRus7DJO8u7tY=
MIME-Version: 1.0
In-Reply-To: <1242106795.11251.286.camel@twins>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0905101502050.18804@chino.kir.corp.google.com>
	 <20090511142936.dd68005b.akpm@linux-foundation.org>
	 <alpine.DEB.2.00.0905111444070.466@chino.kir.corp.google.com>
	 <20090511151130.9a949cb7.akpm@linux-foundation.org>
	 <1242106795.11251.286.camel@twins>
Date: Tue, 12 May 2009 20:36:38 +0900
X-Google-Sender-Auth: 279d069fe635e387
Message-ID: <2f11576a0905120436k2e846494n802cf4cf6aefec7a@mail.gmail.com>
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, gregkh@suse.de, npiggin@suse.de,
       mel@csn.ul.ie, cl@linux-foundation.org, dave@linux.vnet.ibm.com,
       san@android.com, arve@android.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Not sure it would help since the oom killer will be now be called for such
>> > an allocation and that dumps the stack (and will actually show the order
>> > and gfp flags as well).
>>
>> No, the intent of that warning is to find all call sites which use
>> __GFP_NOFAIL on order>0 so we can hunt down and eliminate them.
>>
>>
>> please review...
>
> Fully agreed, people should use banker's algorithm to guarantee
> progress, not create deadlocks with inf loops.
>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

me too.

>
>> From: Andrew Morton <akpm@linux-foundation.org>
>>
>> __GFP_NOFAIL is a bad fiction.  Allocations _can_ fail, and callers should
>> detect and suitably handle this (and not by lamely moving the infinite
>> loop up to the caller level either).
>>
>> Attempting to use __GFP_NOFAIL for a higher-order allocation is even
>> worse, so add a once-off runtime check for this to slap people around for
>> even thinking about trying it.
>>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Mel Gorman <mel@csn.ul.ie>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

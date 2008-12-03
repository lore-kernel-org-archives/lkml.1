Return-Path: <linux-kernel-owner+w=401wt.eu-S1751914AbYLCPM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbYLCPM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbYLCPMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:12:16 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:24253 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYLCPMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:12:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=cF4uhNQXeRT74hidNPklFVs8ZlWeWIF2GiMATd+CLl0RZOSsypQs58VVAlB/VQ5rsv
         2Yy77EsYRIJb+mkqOi+2Xoi6ivmhAJX9iN6W+asYKjwj1gV2muKQ4MHrutjEHU8UlWdC
         zuUkwqqYdTX1zqCI6t/pFyFXAjhgta2hgosbs=
Message-ID: <2f11576a0812030712t1131c9d2x4dd0fd32eafa66ae@mail.gmail.com>
Date: Thu, 4 Dec 2008 00:12:15 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH] vmscan: improve reclaim throuput to bail out patch
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mel@csn.ul.ie
In-Reply-To: <49368DAF.9060206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49316CAF.2010006@redhat.com>
	 <20081130150849.8140.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081203140419.1D44.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <49368DAF.9060206@redhat.com>
X-Google-Sender-Auth: a60df3b7bbc25fa2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I evaluate rvr bailout and skip-freeing patch in this week conteniously.
>> I'd like to dump first output here.
>>
>>
>>
>> Rik, could you please review following?
>> ==
>> vmscan bail out patch move nr_reclaimed variable to struct scan_control.
>> Unfortunately, indirect access can easily happen cache miss.
>> More unfortunately, Some architecture (e.g. ia64) don't access global
>> variable so fast.
>
> That is amazing.  Especially considering that the scan_control
> is a local variable on the stack.

Ahhhhh, I did want to write "indirect access(or likes global variables)",
but my brain was sucked. sorry.

I'll  post description fixed version soon. thanks.


>> if heavy memory pressure happend, that's ok.
>> cache miss already plenty. it is not observable.
>>
>> but, if memory pressure is lite, performance degression is obserbable.
>
>> about 4-5% degression.
>>
>> Then, this patch introduce temporal local variable.
>
>> OK. the degression is disappeared.
>
> I can't argue with the numbers, though :)
>
> Maybe all the scanning we do ends up evicting the cache lines
> with the scan_control struct in it from the fast part of the
> CPU cache?

Yeah, I think so.


>
>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> Acked-by: Rik van Riel <riel@redhat.com>

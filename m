Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbZD2Huh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbZD2Huh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbZD2HrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:47:21 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:37818 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbZD2HrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:47:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UKG4yhy+FepSMz0ubiwUfzhtbSESiUywtTH6Skm3S3lA76z3riblTIfIeGdIcdWqbN
         K2YkvVgB/Npn6tp3vaMroco8mv6tussnIGXP1fg4Jt9+XM0jyVA5kOrPqZZH/97RxhqH
         6unvIRFvurXpbH0Ysidw0dEeDbQIcGC/SbUoE=
MIME-Version: 1.0
In-Reply-To: <20090428233455.614dcf3a.akpm@linux-foundation.org>
References: <20090428090916.GC17038@localhost> <20090428120818.GH22104@mit.edu>
	 <20090429130430.4B11.A69D9226@jp.fujitsu.com>
	 <20090428233455.614dcf3a.akpm@linux-foundation.org>
Date: Wed, 29 Apr 2009 16:47:18 +0900
X-Google-Sender-Auth: 6574fc51035efa4b
Message-ID: <2f11576a0904290047i1bd8fc6cu7d70a3ac32bf7b5a@mail.gmail.com>
Subject: Re: Swappiness vs. mmap() and interactive response
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <peterz@infradead.org>, Elladan <elladan@eskimo.com>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Mapped page decrease rapidly: not happend (I guess, these page stay in
>>                                           active list on my system)
>> page fault large latency:     happend (latencytop display >200ms)
>
> hm.  The last two observations appear to be inconsistent.

it mean existing process don't slow down. but new process creation is very slow.


> Elladan, have you checked to see whether the Mapped: number in
> /proc/meminfo is decreasing?
>
>>
>> Then, I don't doubt vm replacement logic now.
>> but I need more investigate.
>> I plan to try following thing today and tommorow.
>>
>>  - XFS
>>  - LVM
>>  - another io scheduler (thanks Ted, good view point)
>>  - Rik's new patch
>
> It's not clear that we know what's happening yet, is it?  It's such a
> gross problem that you'd think that even our testing would have found
> it by now :(

Yes, unclear. but various testing can drill down the reason, I think.


> Elladan, do you know if earlier kernels (2.6.26 or thereabouts) had
> this severe a problem?
>
> (notes that we _still_ haven't unbusted prev_priority)

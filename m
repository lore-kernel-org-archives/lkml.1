Return-Path: <linux-kernel-owner+w=401wt.eu-S1030986AbXDWD6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030986AbXDWD6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 23:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030686AbXDWD6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 23:58:32 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:43631 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030991AbXDWD6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 23:58:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=4oHK7YDjGMZBs9upOv/446iCoJeJjR/iyvPJN6TasAwr7ntVE+KIVhRUoxV+NAwTuDF6AZfxTnPMlaEQn/qQkfdUrojGz0KXwkTcO0/AhCaqaCmm/FUwhap268KM3RGey43y4fwfTaigHvGFfh+yM7igoRCpToEg3YC8sTEf+g8=  ;
X-YMail-OSG: z0I2o.sVM1kr7eH0vzPY09mcxuBB0_4vuzh9q1BEYeKak50c_mbrqCuE71eNiGYUg7i0.t.8Uw--
Message-ID: <462C2EDE.4090805@yahoo.com.au>
Date: Mon, 23 Apr 2007 13:58:22 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>,
       jakub@redhat.com, drepper@redhat.com
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
References: <46247427.6000902@redhat.com>	<20070420135715.f6e8e091.akpm@linux-foundation.org>	<462932BE.4020005@redhat.com> <20070420150618.179d31a4.akpm@linux-foundation.org> <4629524C.5040302@redhat.com> <462ACA40.8070407@yahoo.com.au> <462B0156.9020407@redhat.com> <462BFAF3.4040509@yahoo.com.au> <462C2DC7.5070709@redhat.com>
In-Reply-To: <462C2DC7.5070709@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:

> I've added a 5th column, with just your mmap_sem patch and
> without my madv_free patch.  It is run with the glibc patch,
> which should make it fall back to MADV_DONTNEED after the
> first MADV_FREE call fails.

Thanks! (I edited slightly so it doesn't wrap)


>   vanilla   new glibc   madv_free    mmap_sem        both
> threads
>
> 1     610         609         596         534         545
> 2    1032        1136        1196        1180        1200
> 4    1070        1128        2014        2027        2024
> 8    1000        1088        1665        2089        2087
> 16    779        1073        1310        2012        1999
> 
> 
> Not doing the mprotect calls is the big one I guess, especially
> the fact that we don't need to take the mmap_sem for writing.

Yes.


> With both our patches, single and two thread performance with
> MySQL sysbench is somewhat better than with just your patch,
> 4 and 8 thread performance are basically the same and just
> your patch gives a slight benefit with 16 threads.
> 
> I guess I should benchmark up to 64 or 128 threads tomorrow,
> to see if this is just luck or if the cache benefit of doing
> the page faults and reusing hot pages is faster than not
> having page faults at all.
> 
> I should run some benchmarks on other systems, too.  Some of
> these results could be an artifact of my quad core CPU.  The
> results could be very different on other systems...

I'm getting the 16 core box out of retirement as we speak :)

-- 
SUSE Labs, Novell Inc.

Return-Path: <linux-kernel-owner+w=401wt.eu-S939474AbXGUBFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939474AbXGUBFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 21:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759662AbXGUBFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 21:05:47 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:36502 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759508AbXGUBFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 21:05:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=toidSP9h2IBotoFastbutUmxdZVTrajCl2VtYiCqCC/Luqa3W4co3xp0Yk5CTAcFn/Coryj9PQ9jNjxq9Z+UJlHrkKRe7ktAtK74lHrou8Kd4b54JgrLP2ZDYURGNaIezGVJRkjyRyusNS7iyK9edn0Xe8p+KnTR0Kv8kmJ0rf8=  ;
X-YMail-OSG: n87CYxoVM1ncN3fQ78USExwCdnlnC2RhSXZHOZkBF1zMQ_1bCYX3INFT1tt_KCwwx6MXpWHz5Q--
Message-ID: <46A03E63.2080508@yahoo.com.au>
Date: Fri, 20 Jul 2007 14:47:31 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Nishanth Aravamudan <nacc@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Bill Irwin <bill.irwin@oracle.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] hugetlbfs read() support
References: <1184376214.15968.9.camel@dyn9047017100.beaverton.ibm.com> <20070718221950.35bbdb76.akpm@linux-foundation.org> <1184860309.18188.90.camel@dyn9047017100.beaverton.ibm.com> <20070719095850.6e09b0e8.akpm@linux-foundation.org> <20070719170759.GE2083@us.ibm.com>
In-Reply-To: <20070719170759.GE2083@us.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Aravamudan wrote:
> On 19.07.2007 [09:58:50 -0700], Andrew Morton wrote:
> 
>>On Thu, 19 Jul 2007 08:51:49 -0700 Badari Pulavarty <pbadari@us.ibm.com> wrote:
>>
>>
>>>>>+		}
>>>>>+
>>>>>+		offset += ret;
>>>>>+		retval += ret;
>>>>>+		len -= ret;
>>>>>+		index += offset >> HPAGE_SHIFT;
>>>>>+		offset &= ~HPAGE_MASK;
>>>>>+
>>>>>+		page_cache_release(page);
>>>>>+		if (ret == nr && len)
>>>>>+			continue;
>>>>>+		goto out;
>>>>>+	}
>>>>>+out:
>>>>>+	return retval;
>>>>>+}
>>>>
>>>>This code doesn't have all the ghastly tricks which we deploy to
>>>>handle concurrent truncate.
>>>
>>>Do I need to ? Baaahh!!  I don't want to deal with them. 
>>
>>Nick, can you think of any serious consequences of a read/truncate
>>race in there?  I can't..
>>
>>
>>>All I want is a simple read() to get my oprofile working.  Please
>>>advise.
>>
>>Did you consider changing oprofile userspace to read the executable
>>with mmap?
> 
> 
> It's not actually oprofile's code, though, it's libbfd (used by
> oprofile). And it works fine (presumably) for other binaries.

So... what's the problem with changing it? The fact that it is a
library doesn't really make a difference except that you'll also
help everyone else who links with it.

It won't break backwards compatibility, and it will work on older
kernels...

-- 
SUSE Labs, Novell Inc.

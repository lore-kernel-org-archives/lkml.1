Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbXDMAPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbXDMAPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 20:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbXDMAPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 20:15:38 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:20705 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753933AbXDMAPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 20:15:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=0r82WR4eXlrA6Al+46l1m9RW0PzlcX3TUBL/J6mvevPqUbSUQqU9R76zGwqWHeVpl8vQBjl1d4fJ0gm7P99+lwfNW30Jz6UYgOib7CtF4ClkYKrccRVCB7ngFV0fUvnCP9S6Y+mxBIyffr244r7Z+P5dtwPXK2X/UPXRdRgK3wg=  ;
X-YMail-OSG: C8v6pUIVM1mv1u8LcBxr02wXms1dAH5mfmTrD0UdrYfNtRoAyF1UrPpDi6sV9scRr8RQz_13tg--
Message-ID: <461ECB9C.8060000@yahoo.com.au>
Date: Fri, 13 Apr 2007 10:15:24 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: William Lee Irwin III <wli@holomorphy.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <1.486631555@selenic.com>	<20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org>
In-Reply-To: <20070412163235.dd030637.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 12 Apr 2007 16:10:50 -0700
> William Lee Irwin III <wli@holomorphy.com> wrote:

>>+       while (count > 0) {
>>+               chunk = min_t(size_t, count, PAGE_SIZE);
>>+               i = 0;
>>+
>>+               if (pfn == -1) {
>>+                       page[0] = 0;
>>+                       page[1] = 0;
>>+                       ((char *)page)[0] = (ntohl(1) != 1);
> 
> 
> OK.
> 
> 
>>+                       ((char *)page)[1] = PAGE_SHIFT;
> 
> 
> OK.

Shouldn't we just expose page size and endianness by other means? (another file or
syscall).

>>+               for (; i < 2 * chunk / KPMSIZE; i += 2, pfn++) {
>>+                       ppage = pfn_to_page(pfn);
>>+                       if (!ppage) {
>>+                               page[i] = 0;
>>+                               page[i + 1] = 0;
>>+                       } else {
>>+                               page[i] = ppage->flags;
>>+                               page[i + 1] = atomic_read(&ppage->_count);
>>+                       }
>>+               }
> 
> 
> Not a good idea to expose raw flags in this manner - it changes at the drop
> of a hat.  We'd need to also expose the kernel's PG_foo-to-bitnumber
> mapping to make this viable.

I don't think it is viable because that makes the flags part of the
userspace ABI. I wonder what they are needed for.

-- 
SUSE Labs, Novell Inc.

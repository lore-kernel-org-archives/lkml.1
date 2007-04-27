Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbXD0Kik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbXD0Kik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbXD0Kik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:38:40 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:25710 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755530AbXD0Kii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:38:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=heralD2dVgnzW4SNvvw92YPPj4o0JmIvaiX6jWsInqWFPnZKr9nmjlWEJDv4NWbjYm5OYvUiYLrEKu2vH0yYRFBM0wbTK7bkd5e5+806ULencmsQtCn68onGxo6HGqUx1Jk11TltYFIUnpyJ3KaE63Pi7go/gbrdpC7F8dATnPg=  ;
X-YMail-OSG: v8dZYdgVM1nJYGdaqWIpnq52glqUvaEFGTfcrt.izrvcSS9XwjxpdBxh8IZNoaZB_KDa4ZyB8g--
Message-ID: <4631D2A5.8060005@yahoo.com.au>
Date: Fri, 27 Apr 2007 20:38:29 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: David Chinner <dgc@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <46304B9E.5070604@yahoo.com.au> <20070426161152.GC16337@infradead.org>
In-Reply-To: <20070426161152.GC16337@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Apr 26, 2007 at 04:50:06PM +1000, Nick Piggin wrote:
> 
>>Improving the buffer layer would be a good way. Of course, that is
>>a long and difficult task, so nobody wants to do it.
> 
> 
> It's also a stupid idea.  We got rid of the buffer layer because it's
> a complete pain in the ass, and now you want to reintroduce one that's
> even more complex, and most likely even slower than the elegant solution?
> 
> 
>>Well, for those architectures (and this would solve your large block
>>size and 16TB pagecache size without any core kernel changes), you
>>can manage 1<<order hardware ptes as a single Linux pte. There is
>>nothing that says you must implement PAGE_SIZE as a single TLB sized
>>page.
> 
> 
> Well, ppc64 can do that.  And guess what, it really painfull for a lot
> of workloads.  Think of a poor ps3 with 256 from which the broken hypervisor
> already takes a lot away and now every file in the pagecache takes
> 64k, every thread stack takes 64k, etc?  It's good to have variable
> sized objects in places where it makes sense, and the pagecache is
> definitively one of them.

Well, I think 64K is probably too large for a generic Linux config, but
16K is a lot more reasonable and would also nicely cut out most other
higher order allocations too.

The efficiency argument has always been there and is nothing new. Yeah,
I know it can be slightly more efficient to do most hardware operations
in larger chunks, and I didn't ever buy it before or now. Superpages can
also be used to use TLBs more efficiently sometimes, etc etc. This is
coming up now because of some specific big problems that are being
encountered which is absolutely not some fundamental hardware limit we
are seeing approach.

-- 
SUSE Labs, Novell Inc.

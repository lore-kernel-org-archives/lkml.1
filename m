Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbXDZHPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbXDZHPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXDZHPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:15:25 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:30205 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933127AbXDZHPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:15:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=AuxyxpITFweXYU/eVLxETbe2Niv3tZC24gT6nP1eVq+CrR6Mw1JLsofx7rN/R7PVKx1QIxCUHotfIqq1Zlxxm3bqrQofC1VK2BP6179GT49aVhKoAP12qnN8mtc3eAN84BcWKt4tkV8mJzAD2ltguUc17n7uNejmQhorKKZ4Pmc=  ;
X-YMail-OSG: WVpY2PcVM1mX7S5BAoovL0rZHGuU263dkoqt3uBgcMor8EVz3S7sbFS5yl0m8ZIDia2B.fLAfw--
Message-ID: <46305177.7060102@yahoo.com.au>
Date: Thu, 26 Apr 2007 17:15:03 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 26 Apr 2007, Nick Piggin wrote:
> 
> 
>>>>I am working now and again on some code to do this, it is a big job but
>>>>I think it is the right way to do it. But it would take a long time to
>>>>get stable and supported by filesystems...
>>>
>>>Ummm... We already have a radix tree for this???? What more is needed? You
>>>just need to go through all filesystems and make them use extends.
>>
>>I'm talking about block size > page size in the buffer layer.
> 
> 
> I fail to see the point of adding another layer when you already have a 

It isn't another layer. We already have this layer.

> mapping through the radix tree. You just need to change the way the 
> filesystem looks up pages.

You didn't think any of the criticisms of higher order page cache size
were valid?


> What are the exact requirement you are trying to address?

Block size > page cache size.


> You fundamentally cannot address the large blocksize requirements with 4k 
> pages since you simply must have larger contiguous memory.
> 
> Large blocksize means that the device can do I/O on blocks of that size.
> 
> What can be done is to create some kind of fake linearity. At one level 
> the radix tree and the address space already provide that. The radix tree 
> allows you to find the next page etc. Another approach would be to create 
> a virtual address space that fakes linearity even for the processor.
> 
> Then there are ways with I/O mmus to avoid the issues again.
> 
> However, you still have not addressed the underlying problem of the device 
> not being able to do I/O to a larger block of memory.

With iommus and sg lists?

You guys have a couple of problems, firstly you need to have ia64
filesystems accessable to x86_64. And secondly you have these controllers
without enough sg entries for nice sized IOs.

I sympathise, and higher order pagecache might solve these in a way, but
I don't think it is the right way to go, mainly because of the fragmentation
issues.

Increasing PAGE_SIZE, support for block size > page cache size, and getting
io controllers matched to a 4K page size IMO would be some good ways to
solve these problems. I know they are probably harder...

-- 
SUSE Labs, Novell Inc.

Return-Path: <linux-kernel-owner+w=401wt.eu-S933156AbXDZHSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbXDZHSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXDZHSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:18:06 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:45498 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933156AbXDZHSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:18:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ri5I9FUKMFhsiehfWKYn84qDlVUr6FHw1ry70MYFmM6vhctbeUxdlSxgfCkz/ZiJE/ghi/eO4yPRrWb9D8deMnxc+FPnf86Q8vo65j2FusHnzIwvEXgjMkVbaJX2zrve2b98Q8JfCu89rzp97Lr8TKetQ9C+aZX4UR5y/990KIk=  ;
X-YMail-OSG: l6YeXfAVM1knWpKH6kWiZo8MqEjtZlEBR3.6_A_U59morZbjSSjwGOWrHrcFpdGUt4RToW4YVQ--
Message-ID: <46305222.60502@yahoo.com.au>
Date: Thu, 26 Apr 2007 17:17:54 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: David Chinner <dgc@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <20070426070454.GF32602149@melbourne.sgi.com> <46304FAF.7020700@yahoo.com.au> <Pine.LNX.4.64.0704260011140.30731@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704260011140.30731@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 26 Apr 2007, Nick Piggin wrote:
> 
> 
>>>Nick, what's the buffer layer? Are you talking about operations
>>>based on bufferheads?
>>
>>Yeah. Our pgoff_t->sector_t translation.
> 
> 
> Sadly the buffers in the buffer layer still assume contiguous memory. You 
> would have to add a series of pointers there and then add a layer to 
> handle this.

That's the least of the problems with rewriting the buffer layer.

But I maintain that the end result is better than the fragmentation
based approach. A lot of people don't actually want a bigger page
cache size, because they want efficient internal fragmentation as
well, so your radix-tree based approach isn't really comparable.

-- 
SUSE Labs, Novell Inc.

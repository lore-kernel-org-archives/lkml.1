Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbXD0KIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbXD0KIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbXD0KIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:08:49 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:32597 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755549AbXD0KIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:08:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=th8M2P0H0Unq0V+gL0OBBWH014zd/XXwiOwLkXnN8Oto3S2PkEEXfpcLapSN56XBYLsi3PwPURrbdtJuapb/aQuTKB2u6DZF21a5h5P+urdOTVdtFyGWBvVsINXkB1exoztXsVlkVEyP2Eio2ZY1jmkK/XiI5I9BNrDJuVWjEFg=  ;
Message-ID: <4631CBA6.3090902@yahoo.com.au>
Date: Fri, 27 Apr 2007 20:08:38 +1000
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
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <20070426070454.GF32602149@melbourne.sgi.com> <46304FAF.7020700@yahoo.com.au> <Pine.LNX.4.64.0704260011140.30731@schroedinger.engr.sgi.com> <46305222.60502@yahoo.com.au> <Pine.LNX.4.64.0704260022570.31003@schroedinger.engr.sgi.com> <46305894.3050403@yahoo.com.au> <Pine.LNX.4.64.0704261108500.3263@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704261108500.3263@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 26 Apr 2007, Nick Piggin wrote:
> 
> 
>>Christoph Lameter wrote:
>>
>>>On Thu, 26 Apr 2007, Nick Piggin wrote:
>>>
>>>
>>>
>>>>But I maintain that the end result is better than the fragmentation
>>>>based approach. A lot of people don't actually want a bigger page
>>>>cache size, because they want efficient internal fragmentation as
>>>>well, so your radix-tree based approach isn't really comparable.
>>>
>>>
>>>Me? Radix tree based approach? That approach is in the kernel. Do not create
>>>a solution where there is no problem. If we do not want to support large
>>>blocksizes then lets be honest and say so instead of redefining what a block
>>>is. The current approach is fine if one is satisfied with scatter gather and
>>>the VM overhead coming with handling these pages. I fail to see what any of
>>>what you are proposing would add to that.
>>
>>I'm not just making this up. Fragmentation. OK?
> 
> 
> Yes you are. If you want to avoid fragmentation by restricting the OS to 
> 4k alone then the radix tree is sufficient to establish the order of pages 
> in a mapping. The only problem is to get an array of pointers to a 
> sequence of pages together by reading through the radix tree. I do not 
> know what else would be needed.

No. We have avoided fragmentation up until now. We avoid fragmentation like
the plague because it is crap. What _I_ do not want to do is add some
patches that make it work a bit better and everyone think's that's a signal
that it is a good idea to start using higher order allocations wherever
possible.

-- 
SUSE Labs, Novell Inc.

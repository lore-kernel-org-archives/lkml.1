Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbXD0KQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbXD0KQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbXD0KQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:16:06 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:29321 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754168AbXD0KQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:16:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=UETUHnUd963+V+XVNqoSuw0Ek7o54/FoxEHZbv8pp1JjqHEEKfgQTyD9oQPYSx16f6HPNpzrYiJIlrUYlAvdwV2Lzy/MsbcrvsmHlujmwm2g19QuEkTldMnIVv4+s+6426k8keiTuyB40Iza4VUGgR6f4zn28b20kDaZnp+/9Eo=  ;
X-YMail-OSG: cr0rhKQVM1lBDDr1X2ikfuX3OyJPejg6hGuRJrHe9Qme231B1u8P2V6zKvUwxcS8dr7efOrS5g--
Message-ID: <4631CD58.8010103@yahoo.com.au>
Date: Fri, 27 Apr 2007 20:15:52 +1000
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
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com> <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com> <463057D9.9030804@yahoo.com.au> <Pine.LNX.4.64.0704261110480.3263@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704261110480.3263@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 26 Apr 2007, Nick Piggin wrote:
> 
> 
>>>But what do you mean with it? A block is no longer a contiguous section of
>>>memory. So you have redefined the term.
>>
>>I don't understand what you mean at all. A block has always been a
>>contiguous area of disk.
> 
> 
> You want to change the block layer to support larger blocksize than 
> PAGE_SIZE right? So you need to segment that larger block into pieces.

The block is the disk block, which does not get segmented.

What you have is a small layer that tells you which block a pagecache
page points to, and which pagecache page refers to a given block. Just
like we have now only slightly extended.


>>>And you dont care about Mel's work on that level?
>>
>>I actually don't like it too much because it can't provide a robust
>>solution. What do you do on systems with small memories, or those that
>>eventually do get fragmented?
> 
> 
> You could f.e. switch off defragmentation and the large block support?

Ahh, then you reboot your machine to access your other filesystems?


>>Actually, I don't know why people are so excited about being able to
>>use higher order allocations (I would rather be more excited about
>>never having to use them). But for those few places that really need
>>it, I'd rather see them use a virtually mapped kernel with proper
>>defragmentation rather than putting hacks all through the core code.
> 
> 
> Ahh. I knew we were going this way.... Now we have virtual contiguous vs. 
> physical discontiguous.... Yuck hackidihack.

That gives you have the proper infrastructure that is needed to actually
support higher order _physical_ allocations _properly_.

-- 
SUSE Labs, Novell Inc.

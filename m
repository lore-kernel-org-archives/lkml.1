Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbXDZGxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbXDZGxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933127AbXDZGxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:53:51 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:39879 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933133AbXDZGxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:53:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Yd4CXk8/jE/8gthKRuwYNvkpOk9fjic2vyoCNs2VqhlEdxtHGUGYIOEtBtrsksnYFBG7B9bQtu8NUzKYuyOtYmpBfF6OzsJnSkodLbxrP3s/67aEo7CZDwaFHpH+C1vd4DxmOLDw/6O/RLmQ2mxpuvVOw5OIZfBveDXi2czhUSs=  ;
X-YMail-OSG: OCdgNe8VM1kKgFj3V8p3Iwxp5hQXjFSn37Z4zEEUegMlv70imGagzMBNM9hOj9t6GHGWgNm1nA--
Message-ID: <46304C74.9040304@yahoo.com.au>
Date: Thu, 26 Apr 2007 16:53:40 +1000
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
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 26 Apr 2007, Nick Piggin wrote:
> 
> 
>>>The page cache has no problems supporting things with a block
>>>size larger then page size.  Now the block device layer may not
>>>have the code to do the scatter gather into small pages and it
>>>may not handle buffer heads whose data is split between multiple
>>>pages. 
>>
>>Yeah, this patch is not really large blocksize support (which we normally
>>think of as block size > page cache size).
> 
> 
> No? It depends on how you define block size. This patch definitely allows
> a set blocksize function call with a size larger than 4k.

Yeah because it is still <= page cache page size. Anyway, that's just
semantics, it doesn't matter.


>>>I suspect what needs to be fixed is the page cache block device
>>>interface so that we have helper functions that know how to stuff
>>>a single block into several pages.
>>
>>I am working now and again on some code to do this, it is a big job but
>>I think it is the right way to do it. But it would take a long time to
>>get stable and supported by filesystems...
> 
> 
> Ummm... We already have a radix tree for this???? What more is needed? You 
> just need to go through all filesystems and make them use extends.

I'm talking about block size > page size in the buffer layer.

-- 
SUSE Labs, Novell Inc.

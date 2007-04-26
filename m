Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbXDZNxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbXDZNxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbXDZNxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:53:06 -0400
Received: from il.qumranet.com ([82.166.9.18]:46952 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801AbXDZNxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:53:05 -0400
Message-ID: <4630AEBC.4000002@argo.co.il>
Date: Thu, 26 Apr 2007 16:53:00 +0300
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com> <46304D50.1040706@yahoo.com.au> <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com> <46305327.2000206@yahoo.com.au> <Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com> <4630593C.8070905@yahoo.com.au> <20070426092014.GT65285596@melbourne.sgi.com>
In-Reply-To: <20070426092014.GT65285596@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Thu, Apr 26, 2007 at 05:48:12PM +1000, Nick Piggin wrote:
>   
>> Christoph Lameter wrote:
>>     
>>> On Thu, 26 Apr 2007, Nick Piggin wrote:
>>>
>>>
>>>       
>>>> No I don't want to add another fs layer.
>>>>         
>>> Well maybe you could explain what you want. Preferably without redefining 
>>> the established terms?
>>>       
>> Support for larger buffers than page cache pages.
>>     
>
> The problem with this approach is that it turns around the whole
> way we look at bufferheads. Right now we have well defined 1:n
> mapping of page to bufferheads and so we tpyically lock the
> page first them iterate all the bufferheads on the page.
>
> Going the other way, we need to support m:n which we means
> the buffer has to become the primary interface for the filesystem
> to the page cache. i.e. we need to lock the bufferhead first, then
> iterate all the pages on it. This is messy because the cache indexes
> via pages, not bufferheads. hence a buffer needs to point to all the
> pages in it explicitly, and this leads to interesting issues with
> locking.
>   

Why is it necessary to assume that one filesystem block == one buffer?  
Is it for atomicity, efficiency, or something else?


-- 
error compiling committee.c: too many arguments to function


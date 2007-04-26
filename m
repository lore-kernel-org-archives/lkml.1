Return-Path: <linux-kernel-owner+w=401wt.eu-S1031241AbXDZO4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031241AbXDZO4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031239AbXDZO4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:56:54 -0400
Received: from il.qumranet.com ([82.166.9.18]:38965 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031241AbXDZO4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:56:53 -0400
Message-ID: <4630BDB1.8090606@argo.co.il>
Date: Thu, 26 Apr 2007 17:56:49 +0300
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
References: <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com> <46304D50.1040706@yahoo.com.au> <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com> <46305327.2000206@yahoo.com.au> <Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com> <4630593C.8070905@yahoo.com.au> <20070426092014.GT65285596@melbourne.sgi.com> <4630AEBC.4000002@argo.co.il> <20070426143303.GW65285596@melbourne.sgi.com>
In-Reply-To: <20070426143303.GW65285596@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
>> Why is it necessary to assume that one filesystem block == one buffer?  
>> Is it for atomicity, efficiency, or something else?
>>     
>
> By definition, really - each filesystem block has it's own state and
> it's own disk mapping and so we need something to carry that
> information around....
>   

Well, for block sizes > PAGE_SIZE, you can just duplicate the mapping 
information (with an offset-in-block bit field) in each page's struct 
page.  But I see from your other posts that there are atomicity and 
performance reasons as well.

-- 
error compiling committee.c: too many arguments to function


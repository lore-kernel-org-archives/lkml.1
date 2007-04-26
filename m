Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbXDZTAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbXDZTAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXDZTAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:00:43 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33132 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXDZTAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:00:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <m1abwvofke.fsf@ebiederm.dsl.xmission.com>
	<463048FE.5000600@yahoo.com.au>
	<Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com>
	<46304D50.1040706@yahoo.com.au>
	<Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com>
	<46305327.2000206@yahoo.com.au>
	<Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com>
	<4630593C.8070905@yahoo.com.au>
	<20070426092014.GT65285596@melbourne.sgi.com>
	<4630C326.2030906@yahoo.com.au> <20070426174254.GD2017@kernel.dk>
Date: Thu, 26 Apr 2007 12:59:20 -0600
In-Reply-To: <20070426174254.GD2017@kernel.dk> (Jens Axboe's message of "Thu,
	26 Apr 2007 19:42:54 +0200")
Message-ID: <m1vefjj71z.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Fri, Apr 27 2007, Nick Piggin wrote:
>> Why do we limit drivers to 128 sg entries?
>
> No particular reason, except than to avoid 2^bigger order allocations.
> 2MiB requests would require 3 contig pages to setup the sg list, which
> is (probably) a little troublesome especially since it's sometimes
> atomically allocated.
>
> Larger pages are by no means a prerequisite to getting larger requests,
> assuming your hardware can handle the bigger sglist. There are other
> ways of doing that, I've contemplated doing chained sglists and adding
> sg_for_each_segment() macros for iterating these things. Drivers that
> want larger sglists would then be required to update their sg mapping
> loop to use the provided macros. It wouldn't be too hard.

Thanks.  At least in the long term supporting larger scatter gather lists
in the kernel looks like something we need to do assuming bandwidth
goes up exponentially but I/O device latency remains high.

Eric

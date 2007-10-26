Return-Path: <linux-kernel-owner+w=401wt.eu-S1765996AbXJZWyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765996AbXJZWyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbXJZWyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:54:12 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:40487 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbXJZWyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:54:10 -0400
Message-ID: <47227015.6060708@oracle.com>
Date: Fri, 26 Oct 2007 15:54:13 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Karl Schendel <kschendel@datallegro.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Leonid Ananiev <leonid.i.ananiev@linux.intel.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Fix bad data from non-direct-io read after direct-io
 write
References: <47225835.4050309@datallegro.com> <alpine.LFD.0.999.0710261425240.30120@woody.linux-foundation.org> <47226A75.1020008@oracle.com> <alpine.LFD.0.999.0710261541410.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710261541410.30120@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 26 Oct 2007, Zach Brown wrote:
>> I think that test should be changed to
> 
> How about not testing at all? Which was what the old code did.
> 
> Just do the invalidate unconditionally for any writes, and screw the end 
> result of the invalidate, since we cannot afford to overwrite the previous 
> return value anyway in any realistic scenario?

I'm reasonably comfortable with that, sure.  This second invalidation
only catches reads which userspace raced with the write, and that's
already racy by definition.

I can throw together a patch if you haven't already committed one by the
time you read this ;).

- z

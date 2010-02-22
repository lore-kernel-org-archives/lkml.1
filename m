Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab0BVPnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 10:43:10 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:53559 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab0BVPnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 10:43:08 -0500
Message-ID: <4B82A603.9030602@linux.vnet.ibm.com>
Date: Mon, 22 Feb 2010 16:42:59 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, gregkh@novell.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD is
 set"
References: <20100209175707.GB5098@csn.ul.ie> <4B742C2C.5080305@linux.vnet.ibm.com> <20100212100519.GA29085@laptop> <4B796C6D.80800@linux.vnet.ibm.com> <20100216112517.GE1194@csn.ul.ie> <4B7ACC1E.9080205@linux.vnet.ibm.com> <4B7BBCFC.4090101@linux.vnet.ibm.com> <20100218114310.GC32626@csn.ul.ie> <4B7D664C.20507@linux.vnet.ibm.com> <4B7E73BF.5030901@linux.vnet.ibm.com> <20100219151934.GA1445@csn.ul.ie>
In-Reply-To: <20100219151934.GA1445@csn.ul.ie>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
[...]
> 
>> Unfortunately even now knowing the place of the issue so well I don't see
>> the connection to the commits e084b+5f8dcc21
> 
> Still a mystery.
> 
>>  - I couldn't find something but
>> did they change the accounting somewhere or e.g. changed the timing/order
>> of watermark updates and allocations?
>>
> 
> Not that I can think of.
> 
>> Eventually it might come down to a discussion of allocation priorities and
>> we might even keep them as is and accept this issue - I still would prefer
>> a good second chance implementation, other page cache allocation flags or
>> something else that explicitly solves this issue.
>>
> 
> In that line, the patch that replaced congestion_wait() with a waitqueue
> makes some sense.

[...]

> I'll need to do a number of tests before I can move that upstream but I
> don't think it's a merge candidate. Unfortunately, I'll be offline for a
> week starting tomorrow so I won't be able to do the testing.
> 
> When I get back, I'll revisit those patches with the view to pushing
> them upstream. I hate to treat symptoms here without knowing the
> underlying problem but this has been spinning in circles for ages with
> little forward progress :(

I'll continue with some debugging in search for the real reasons, but if 
I can't find a new way to look at it I think we have to drop it for now.

While I hate fixing symptoms too, I completely agree that  it is time to 
bring this fix upstream and in fact into the stable kernel too, to have 
at least a ~98% workaround out there.

I'm looking forward for your revised patch after you are back and I'm 
eager to test this one again.


-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance

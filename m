Return-Path: <linux-kernel-owner+w=401wt.eu-S939240AbZDJSor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939240AbZDJSor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 14:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762038AbZDJSoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 14:44:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:39270 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbZDJSog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 14:44:36 -0400
Message-ID: <49DF935E.8030607@kernel.org>
Date: Fri, 10 Apr 2009 11:43:42 -0700
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unbreak alpha percpu
References: <20090410151224.GM26366@ZenIV.linux.org.uk> <20090410154704.GN26366@ZenIV.linux.org.uk> <alpine.LFD.2.00.0904100915010.4583@localhost.localdomain> <20090410165030.GQ26366@ZenIV.linux.org.uk> <20090410170507.GR26366@ZenIV.linux.org.uk> <20090410171415.GA6033@ZenIV.linux.org.uk> <20090410180532.GA4419@jurassic.park.msu.ru> <alpine.LFD.2.00.0904101118470.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904101118470.4583@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 18:43:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 10 Apr 2009, Ivan Kokshaysky wrote:
>> Actually, all of this has been discussed on lkml; here is the latest
>> variant that makes everybody more or less happy, at least there are
>> no objections from percpu folks and Martin (similar fix should work
>> for s390 as well).
> 
> Is there any reason why this version of DEFINE_PER_CPU_SECTION wouldn't 
> work on _any_ architecture? IOW, do we even need the #ifdef's and 
> per-arch #define?

It should work for all archs but only alpha and s390 require __weak__
and other archs can use actual static or global definitions, but then
again we'll need to add the __per_cpu_multiple_def_ thing to make sure
no two static definitions clash anyway, so there isn't much point in
keeping things separate.

I was waiting for responses on the original thread.  Is everyone okay
with having the 'static per-cpu variables in different compile units
can't have the same name' restriction?

Thanks.

-- 
tejun

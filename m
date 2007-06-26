Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbXFYRcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbXFYRcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 13:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXFYRcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 13:32:13 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:35810 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbXFYRcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 13:32:12 -0400
Message-ID: <46808178.6010402@linux.vnet.ibm.com>
Date: Mon, 25 Jun 2007 23:01:12 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-mm <linux-mm@kvack.org>, Balbir Singh <balbir@in.ibm.com>,
       Pavel Emelianov <xemul@sw.ru>, Paul Menage <menage@google.com>,
       Kirill Korotaev <dev@sw.ru>, devel@openvz.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Roy Huang <royhuang9@gmail.com>,
       Aubrey Li <aubreylee@gmail.com>, riel@redhat.POK.IBM.COM
Subject: Re: [RFC] mm-controller
References: <1182418364.21117.134.camel@twins> <467A5B1F.5080204@linux.vnet.ibm.com> <1182433855.21117.160.camel@twins> <467BFA47.4050802@linux.vnet.ibm.com> <1182788561.6174.70.camel@lappy>
In-Reply-To: <1182788561.6174.70.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2007-06-22 at 22:05 +0530, Vaidyanathan Srinivasan wrote:
> 
>> Merging both limits will eliminate the issue, however we would need
>> individual limits for pagecache and RSS for better control.  There are
>> use cases for pagecache_limit alone without RSS_limit like the case of
>> database application using direct IO, backup applications and
>> streaming applications that does not make good use of pagecache.
> 
> I'm aware that some people want this. However we rejected adding a
> pagecache limit to the kernel proper on grounds that reclaim should do a
> better job.
> 
> And now we're sneaking it in the backdoor.
> 


We'll we are trying to provide a memory controller and page cache is a
part of memory. The page reclaimer does treat page cache separately.
Isn't this approach better than simply extending the vm_swappiness
to per container?


> If we're going to do this, get it in the kernel proper first.
> 

I'm open to this. There were several patches to do this. We can do
this by splitting the LRU list to mapped and unmapped pages or
by trying to balance the page cache by tracking it's usage.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

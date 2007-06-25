Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbXFYSDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbXFYSDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 14:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXFYSCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 14:02:55 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:38964 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbXFYSCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 14:02:54 -0400
Message-ID: <4680033D.4080505@linux.vnet.ibm.com>
Date: Mon, 25 Jun 2007 23:32:37 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
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
> If we're going to do this, get it in the kernel proper first.
> 

Good point.  We should probably revisit this in the context of
containers, virtualization and server consolidation.  Kernel takes the
best decision in the context of overall system performance, but when
we want the kernel to favor certain group of application relative to
others then we hit corner cases.  Streaming multimedia applications
are one of the corner case where the kernel's effort to manage
pagecache does not help overall system performance.

There have been several patches suggested to provide system wide
pagecache limit.  There are some user mode fadvice() based techniques
as well.  However solving the problem in the context of containers
provide certain advantages

* Containers provide task grouping
* Relative priority or importance can be assigned to each group using
resource limits.
* Memory controller under container framework provide infrastructure
for detailed  accounting of memory usage
* Containers and controllers form generalised infrastructure to create
localised VM behavior for a group of tasks

I would see introduction of pagecache limit in containers as a safe
place to add the new feature rather than a backdoor.  Since this
feature has a relatively small user base, it be best left as a
container plugin rather than a system wide tunable.

I am not suggesting against system wide pagecache control.  We should
definitely try to find solutions for pagecache control outside of
containers as well.

--Vaidy


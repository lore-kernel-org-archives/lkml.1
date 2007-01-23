Return-Path: <linux-kernel-owner+w=401wt.eu-S933026AbXAWOhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbXAWOhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933034AbXAWOhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:37:33 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:33885 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010AbXAWOhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:37:32 -0500
Message-ID: <45B61E50.6020607@bull.net>
Date: Tue, 23 Jan 2007 15:40:16 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 6/6] automatic tuning applied to some kernel components
References: <20070116061516.899460000@bull.net>	<20070116063030.761795000@bull.net> <20070122115638.835b26a1.akpm@osdl.org>
In-Reply-To: <20070122115638.835b26a1.akpm@osdl.org>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 23/01/2007 15:38:17,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 23/01/2007 15:38:18,
	Serialize complete at 23/01/2007 15:38:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>On Tue, 16 Jan 2007 07:15:22 +0100 Nadia.Derbey@bull.net wrote:
>>The following kernel components register a tunable structure and call the
>>auto-tuning routine:
>>  . file system
>>  . shared memory (per namespace)
>>  . semaphore (per namespace)
>>  . message queues (per namespace)
> 
> 
> This is the part of the patch series which really matters, and I just don't
> understand it :(
> 
> Why do we want to autotune these things?  What problem is this patch series
> solving?  Please describe this part of the work much, much more completely,
> so we can understand the need to add such a large amount of code to the
> kernel.

1) why these tunables?
The ipc tunables have been selected as "guinea-pig" tunables for the AKT 
framework because they are likely to be often used in data bases. This 
applies to file-max too.
Now, if the framework itself is accepted, the set of impacted tunables 
can easily be enhanced.

2) why autotuning:
There are at least 3 cases where it can be useful
. for workloads that are known to need a big amount of a given resource 
type (say shared memories), but we don't know what the maximum amount 
needed will be
. to solve the case of multiple applications running on a single system, 
and that need the same tunable to be adjusted to feet their needs
. to make a system correctly react to eventual peak loads for a given 
resource usage, i.e. make it tune up *and down* as needed.

In all these cases, the akt framework will enable the kernel to adapt to 
increasing / decreasing resource consumption:
1) avoid allocating "a priori" a big amount of memory that will be used 
only in extreme cases. This is the effect of doing an "echo <huge_value> 
 > /proc/sys/kernel/shmmni"
2) the system will come back to the default values as soon as the peak 
load is over.

> 
> It seems strange that the whole feature is Kconfigurable.  Please also
> explain the thinking behind that.

We wanted to make it configurable because it adds some overhead in terms of
1) generated kernel size
2) instructions added to the resource creation / removal code paths even 
if auto-tuning is not activated for th corresponding tunable -> 
performance impact.

> 
> I suspect the patches would be much simpler if you simply required that all
> these new tunables be of type `long'.  About seven eighths of the code
> would go away.  As would most of those eye-popping macros.
> 

Yes, agree with you: the idea here was to make the framework more 
generic. But I can change that.

Regards,
Nadia





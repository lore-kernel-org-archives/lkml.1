Return-Path: <linux-kernel-owner+w=401wt.eu-S1751451AbXBMSRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbXBMSRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbXBMSRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:17:46 -0500
Received: from dvhart.com ([64.146.134.43]:56478 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbXBMSRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:17:46 -0500
Message-ID: <45D20067.2090803@mbligh.org>
Date: Tue, 13 Feb 2007 10:16:07 -0800
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       bob.picco@hp.com
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
References: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com> <45D1F0B1.3020508@mbligh.org> <200702131845.05913.ak@suse.de> <Pine.LNX.4.64.0702130956540.26309@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702130956540.26309@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 13 Feb 2007, Andi Kleen wrote:
> 
>> Adding NULL tests all over mm for this would seem like a clear case
>> of this to me.
> 
> Maybe there is an alternative. We are free to number the nodes right? 
> How about requiring the low node number to have memory and the high ones 
> do not?
> 
> F.e. have a boundary like
> 
> nr_mem_nodes ?
> 
> Everything above nr_mem_nodes has no memory and cannot be specified in a 
> nodemask. Those nodes would not be visible to user space via memory 
> policies and page migration. So the core mempolicy logic could be left 
> untouched.
> 
> The nodes above nr_mem_nodes would exist purely within the kernel. They 
> would have proximity information (which can be used to determine 
> neighboring memory. More flexible then the current attachment 
> to one fixed memory node) but those node numbers could not be specified as 
> node masks in any memory operations. This would then allow memory less nodes 
> with I/O or cpus. The user would not be aware of these.

What's wrong with just setting the existing counters like
node_spanned_pages / node_present_pages to zero?

M.

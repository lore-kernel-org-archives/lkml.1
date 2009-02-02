Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbZBBUDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbZBBUDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbZBBUDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:03:43 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56909 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbZBBUDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:03:42 -0500
Message-ID: <49875199.3010609@linux.vnet.ibm.com>
Date: Mon, 02 Feb 2009 12:03:37 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Maynard Johnson <mpjohn@us.ibm.com>, carll@us.ibm.com
Subject: Re: Performance counter API review was [patch] Performance Counters
 for Linux, v3
References: <20081211155230.GA4230@elte.hu> <87r64ag68n.fsf@basil.nowhere.org>
In-Reply-To: <87r64ag68n.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
[snip]
> - Global tracing. Right now there seem to be two modi: per task and
> per CPU. But a common variant is global tracing of all CPUs. While this
> could be in theory done right now by attaching to each CPU
> this has the problem that it doesn't interact very well with CPU
> hot plug. The application would need to poll for additional/lost
> CPUs somehow and then re-attach to them (or detach). This would
> likely be quite clumsy and slow. It would be better if the kernel supported 
> that better.
> 
> Or alternative here is to do nothing and keep oprofile for that job
> (which it doesn't do that badly)
> 

This issue is of particular interest to us, from the IBM Power toolchain 
perspective.

Ingo, do you think it would be feasible to add an ability to open a 
single file descriptor that could give global counting (and sampling) on 
all CPU's?  I realize this would entail creating a context per cpu in 
the kernel.

How to present the count data back to user space is another issue.  For 
example, do you sum the counts of a particular event type across all 
CPUs or do you keep them separate, and have the user space app read them 
up per-cpu  (perhaps not knowing exactly which cpu they come from)?

I realize that perfmon doesn't have this ability either, it's currently 
per-cpu as well for global counting.

But it seems as long as you are going so far as providing a thread 
inheritance feature (which I assume uses a summing approach for 
providing counts back to user space), that this "pan-cpu" counting 
feature might not be too difficult to implement.  It sure would simplify 
the life of user space apps, as Andi said.

-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com


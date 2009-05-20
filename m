Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbZETNHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbZETNHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 09:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZETNHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 09:07:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49163 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbZETNHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 09:07:04 -0400
Date: Wed, 20 May 2009 15:13:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Len Brown <lenb@kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH]cpuset: add new API to change cpuset top group's cpus
Message-ID: <20090520131301.GF8684@one.firstfloor.org>
References: <20090519073942.GA10864@sli10-desk.sh.intel.com> <1242722454.26820.461.camel@twins> <20090519084852.GA13682@sli10-desk.sh.intel.com> <1242723364.26820.466.camel@twins> <1242729538.26820.497.camel@twins> <alpine.LFD.2.00.0905191429440.29241@localhost.localdomain> <1242772601.26820.527.camel@twins> <87ljosnfzb.fsf@basil.nowhere.org> <1242821825.26820.583.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242821825.26820.583.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the explanation.

My naive reaction would be to fail if the socket to be taken out
is the only member of some cpuset. Or maybe break affinities in this case.

> You really want to start shrinking the generic computational capacity
> first.

One general issue to remember that if you don't react to the platform hint 
the platform will likely force a lower p-state on you to not exceed
the thermal limits, making everyone slower. 

(this will likely also not make your real time process happy)

So it's a bit more than a hint; it's more like a command "or else"

So it's a good idea to react or at least make at least a reasonable attempt 
to react.

> The thing is, you cannot simply rip cpus out from under a system, people
> might rely on them being there and have policy attached to them -- esp.
> people touching cpusets should know that a machine isn't configured
> homogeneous and any odd cpu will do.

Ok, so do you think it's possible to figure out based on the cpuset
graph / real time runqueue if a socket can be taken out? 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

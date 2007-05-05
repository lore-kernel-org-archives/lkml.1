Return-Path: <linux-kernel-owner+w=401wt.eu-S933864AbXEEQw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864AbXEEQw3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933949AbXEEQw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:52:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49580 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933864AbXEEQw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:52:28 -0400
Date: Sat, 5 May 2007 09:52:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Fenghua Yu <fenghua.yu@intel.com>
cc: akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add percpu smp cacheline align section
In-Reply-To: <20070505001222.GA26142@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0705050951040.27326@schroedinger.engr.sgi.com>
References: <33E1C72C74DBE747B7B59C1740F7443701A2F0AB@orsmsx417.amr.corp.intel.com>
 <20070505001222.GA26142@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Fenghua Yu wrote:

> This is follow-up for Suresh's runqueue align in smp patch at:
> http://www.uwsg.iu.edu/hypermail/linux/kernel/0704.1/0340.html
> 
> The patches place all of smp cacheline aligned percpu data into 
> .data.percpu.cacheline_aligned_in_smp. Other percpu data is still in 
> data.percpu section. The patches can reduce cache line access in SMP and 
> reduce alignment gap waste. The patches also define PERCPU macro for 
> vmlinux.lds.S for code clean up.

Ummm... The per cpu area is for exclusive use of a particular processor. 
If there is contention in the per cpu area then a data object needs to be 
removed from the per cpu area because the object is *not* accessed only 
from a certain cpu.


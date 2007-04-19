Return-Path: <linux-kernel-owner+w=401wt.eu-S2993239AbXDSLzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993239AbXDSLzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 07:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993240AbXDSLzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 07:55:02 -0400
Received: from ns.suse.de ([195.135.220.2]:48720 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993239AbXDSLzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 07:55:01 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: discuss@x86-64.org
Subject: Dropping CONFIG_REORDER on x86-64 for 2.6.22
Date: Thu, 19 Apr 2007 13:54:52 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704191354.52985.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hallo,

I'm thinking about dropping the x86-64 CONFIG_REORDER for 2.6.22. 
The function enabled -ffunction-sections and then tries to reorder
the executable

While that's in theory a worthy goal to save TLB/icache, in practice it 
didn't really work out.

Rationale:
- It cannot be enabled in normal builds because all current lds
become very slow when they have to handle thousands of sections.

- The list of hot functions it needs - arch/x86_64/kernel/functionlist -
hasn't been changed for a long time and is already out of date. 
I also don't know no sane way to keep it uptodate. Profile feedback
at runtime is not practical for the kernel and even if it's questionable
we would find a good training workload. Trying to change the manually
is imho foolish and likely not too useful anyways (if any hot function
is missed the TLB savings will be lost and it is unlikely we can
get 100% coverage) 

- The workloads of the kernel are too diverse to make this concept
really work

So I'm planning to drop the option and arch/x86_64/kernel/functionlist

Comments?

-Andi


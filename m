Return-Path: <linux-kernel-owner+w=401wt.eu-S376179AbXECQVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376179AbXECQVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376189AbXECQVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:21:47 -0400
Received: from mx1.suse.de ([195.135.220.2]:52605 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S376179AbXECQVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:21:46 -0400
To: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Per-CPU data as a structure
References: <16C35E62-A26F-49FC-9CD8-7BADFCD97BA5@ac.upc.edu>
From: Andi Kleen <andi@firstfloor.org>
Date: 03 May 2007 19:19:21 +0200
In-Reply-To: <16C35E62-A26F-49FC-9CD8-7BADFCD97BA5@ac.upc.edu>
Message-ID: <p73ps5hx1t2.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Julio M. Merino Vidal" <jmerino@ac.upc.edu> writes:
 
> Similarly, and if I understood it correctly, the PDA (Per-processor
> Data Area) also aims to do the above, but at the moment it only
> contains some fields and is not defined in all platforms.  There are
> still a lot of usages of the percpu functionality (such as, e.g., in
> kernel/sched.c).

PDA is an earlier version of percpu; it still can be more efficiently
accessed so it is kept for some low level code.
 
> As far as I can tell, the advantage of percpu is that you can define
> new "fields" anywhere in the code and independently from the rest of
> the system. 

- Independent maintenance as you noted
- Fast access and relatively compact code
- Avoids false sharing by keeping cache lines of different CPUs separate
- Doesn't waste a lot of memory in padding like NR_CPUs arrays usually
need to to avoid the previous point.

Any replacement that doesn't have these properties too will probably
be not useful.

-Andi


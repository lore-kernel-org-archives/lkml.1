Return-Path: <linux-kernel-owner+w=401wt.eu-S1762491AbYARP5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762491AbYARP5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760661AbYARP5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:57:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43407 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760337AbYARP5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:57:04 -0500
Date: Fri, 18 Jan 2008 16:56:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, jbeulich@novell.com,
       venkatesh.pallipadi@intel.com
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr
	patch series v3)
Message-ID: <20080118155650.GA20054@elte.hu>
References: <200801161114.239449000@suse.de> <20080118095627.GB30637@elte.hu> <20080118153325.GA11759@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118153325.GA11759@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> hm, i just found a failing 64-bit .config while testing your CPA 
> patchset:
> 
>  [    1.916541] CPA mapping 4k 0 large 2048 gb 0 x 0[0-0] miss 0
>  [    1.919874] Unable to handle kernel paging request at 000000000335aea8 RIP:
>  [    1.919874]  [<ffffffff8021d2d3>] change_page_attr+0x3/0x61
>  [    1.919874] PGD 0
>  [    1.919874] Oops: 0000 [1]
>  [    1.919874] CPU 0
> 
> config and full crash.log attached. Fully reproducible. I've also 
> pushed out the current x86.git with the new CPA bits included.

hm, and your CPA queue is no bisectable, due to:

  Subject: Undo pat cpa patch
  From: Andi Kleen <ak@suse.de>

  Going to implement this differently

    commit 5ec5c5a2302ca8794da03f8bedec931a2a814ae9
    Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Date:   Tue Jan 15 09:36:03 2008 +0100

       patches/x86-pat-cpa_i386.patch

could you please make your queue bisectable?

Also, did you actually try to port your queue ontop of the cleanups 
patch? There's an easy technique: first do an undo patch, then apply 
your patch, then apply the re-do patch. Whatever rejects come from the 
re-do patch can be dropped from the cleanup. Continue with this until 
all patches are covered. Then generate the undo+your-old-patch+redo 
patch into a single your-new-patch.

	Ingo

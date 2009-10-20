Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbZJTHLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbZJTHLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 03:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZJTHLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 03:11:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:37612 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366AbZJTHLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 03:11:23 -0400
Message-ID: <4ADD62CD.3080208@kernel.org>
Date: Tue, 20 Oct 2009 16:12:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jiri Kosina <jkosina@suse.cz>, Jeff Mahoney <jeffm@suse.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
References: <4ADB967A.4080707@suse.com> <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz> <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz> <20091020061557.GE8550@elte.hu> <alpine.LSU.2.00.0910200820500.8582@wotan.suse.de> <20091020063555.GJ8550@elte.hu>
In-Reply-To: <20091020063555.GJ8550@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 20 Oct 2009 07:11:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Ingo Molnar wrote:
> Still looks like a bug if it causes a breakage (linker error) on IA64, 

In a sense, yes.

> and if the 'fix' (i'd call it a workaround) causes a (small but nonzero) 
> performance regression on other architectures.

Yeah, by small amount but also reduces memory usage quite a bit.  For
this case, I think dynamic allocation is actually the right thing to
do.

Extending the first chunk size shouldn't be difficult on ia64 but
other than this, there still is a lot of room left with the current
64k limit, so I think we should be safe for a while.  BTW, I also am
curious how lockdep has been coping with the limit.

Thanks.

-- 
tejun

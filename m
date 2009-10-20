Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbZJTCCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbZJTCCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 22:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbZJTCCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 22:02:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:39321 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758145AbZJTCCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 22:02:11 -0400
Date: Tue, 20 Oct 2009 04:02:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jeff Mahoney <jeffm@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
In-Reply-To: <4ADB967A.4080707@suse.com>
Message-ID: <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz>
References: <4ADB967A.4080707@suse.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Oct 2009, Jeff Mahoney wrote:

> Hi Peter -
> 
> Commit 34d76c41 introduced the update_shares_data percpu, but it ends up
> causing problems on large ia64 machines. Specifically, ia64 is limited
> to 64k in percpu vars and with NR_CPUS=4096, that ends up being 32k by
> itself. It ends up causing link errors since that is how ia64 enforces
> the 64k limit.
> 
> I can take a deeper look at finding a workable solution but thought I'd
> mention it in case you had ideas already.

I am adding some IA64 CCs, as the failure is solely caused by the ia64 
percpu implementation/pagefault handler optimization which requires the 
.percpu section area not be larger than 64k, which blows up with 34d76c41 
and NR_CPUS high enoufh (due to introduction of percpu array being 
size-dependent on NR_CPUS).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.


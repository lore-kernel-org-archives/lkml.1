Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbZBKUJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbZBKUJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 15:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbZBKUJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 15:09:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36633 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbZBKUJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 15:09:47 -0500
Date: Wed, 11 Feb 2009 21:09:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, jeffm@suse.com
Subject: Re: [patch] x86, pat: fix warn_on_once() while mapping 0-1MB range
	with /dev/mem
Message-ID: <20090211200938.GA2421@elte.hu>
References: <1234380023.16238.52.camel@vayu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234380023.16238.52.camel@vayu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x86, pat: fix warn_on_once() while mapping 0-1MB range
> with /dev/mem
> 
> Jeff Mahoney reported:
> > With Suse's hwinfo tool, on -tip:
> > WARNING: at arch/x86/mm/pat.c:637 reserve_pfn_range+0x5b/0x26d()
> 
> reserve_pfn_range() is not tracking the memory range below 1MB
> as non-RAM and as such is inconsistent with similar checks in
> reserve_memtype() and free_memtype()
> 
> Rename the pagerange_is_ram() to pat_pagerange_is_ram() and add the
> "track legacy 1MB region as non RAM" condition.
> 
> And also, fix reserve_pfn_range() to return -EINVAL, when the pfn
> range is RAM. This is to be consistent with this API design.
> 
> Reported-and-tested-by: Jeff Mahoney <jeffm@suse.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> ---

applied to tip:x86/urgent, thanks guys!

	Ingo

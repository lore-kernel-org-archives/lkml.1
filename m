Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbYCUNZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbYCUNZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbYCUNZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:25:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51968 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbYCUNZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:25:13 -0400
Date: Fri, 21 Mar 2008 14:24:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: venkatesh.pallipadi@intel.com
Cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] x86: PAT support updated - v3
Message-ID: <20080321132417.GJ27245@elte.hu>
References: <20080319000012.439150000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319000012.439150000@intel.com>
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


* venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com> wrote:

> Follow up on earlier PAT patch series here: 
> http://lkml.org/lkml/2008/1/10/312
> 
> This patch series adds Page Attribute Table (PAT) support on x86. 
> There have been few changes based on comments for earlier patches and 
> also issues that was seen while the earlier patchset was in mm. The 
> main changes include:
> 
> * Unlike earlier patchset, there are no changes to identity mapping of
>   reserved regions.
> * Unlike earlier patches, there are no chanegs to early ioremap.
> * We look at MTRR setting and PAT request and track the resultant type
>   to avoid aliasing.
> * UC_MINUS in PAT to provide backward compatibility to /dem/mem mmap users.
> 
> In general, we have tried to make patches more simpler and cleaner. 
> Hope is to cause less disruption along the way. The changes/cleaups 
> that went into x86/mm (specifically pageattr.c) has helped us along 
> the way.
> 
> The patchset is against x86 testing from couple of days back.

thanks Venki, i've queued this up so that we can see how well it goes. 
It now looks a lot less dangerous and more compatible than it did before 
- but i'm sure there'll be issues nevertheless :-/

> There are two issues that we are leaving out at the moment to make the patch
> simple. We will be addressing them with incremental patches soon:
> * FB/DRM drivers using pgprot_val and changing protection on their own
>   without using any proper APIs like ioremap. There are few such usages and
>   each one will be addressed separately.
> * To change attributes from WC to WB in a "perfect way", one has to follow
>   certain sequence like make page non-present etc.

hm, until this is done correctly i guess we should disallow WC to WB 
transitions? A good number of erratas apply i suspect :-/

	Ingo

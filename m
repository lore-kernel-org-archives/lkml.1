Return-Path: <linux-kernel-owner+w=401wt.eu-S1764222AbYARVCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764222AbYARVCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761164AbYARVCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:02:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33309 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759066AbYARVCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:02:32 -0500
Date: Fri, 18 Jan 2008 22:02:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
       venkatesh.pallipadi@intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] X86: fix typo PAT to X86_PAT
Message-ID: <20080118210210.GB10717@elte.hu>
References: <20080118123140.GI11044@elte.hu> <20080118182437.GA10167@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118182437.GA10167@redhat.com>
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


* Dave Jones <davej@redhat.com> wrote:

>  > you mean modifies MTRRs? Which code is that? (besides the 
>  > /proc/mtrr userspace API)
> 
> This exclusion is going to be a real pain in the ass for distro 
> kernels. It's impossible for example to build a kernel that will now 
> support the MTRR-alike registers on the AMD K6/early Cyrix etc and 
> also support PAT.
> 
> Additionally, given people tend to update their kernels a lot more 
> often than they update to a whole new version of X, it means until 
> userspace has caught up, we can't ship a kernel with PAT supported, or 
> else X gets a lot slower due to the missing mtrr support.

there's no exclusion enforced right now, and if a CPU is PAT-incapable 
(or if the kernel is booted nopat) then the MTRR bits should be usable. 
But if we boot with PAT enabled, and Xorg gets /proc/mtrr wrong, we'll 
see nasty crashes. If it gets them right, it should all still work just 
fine. Is this ok? Then, in a year or two, distros can disable write 
support to /proc/mtrr. Hm?

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYCZF3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYCZF3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 01:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYCZF3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 01:29:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51588 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbYCZF3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 01:29:40 -0400
Date: Wed, 26 Mar 2008 06:29:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       venkatesh.pallipadi@intel.com, arjan@linux.intel.com,
       bug-track@fisher-privat.net
Subject: Re: [Bug 10328] New: [regression] performance drop for glx
Message-ID: <20080326052911.GA8173@elte.hu>
References: <bug-10328-27@http.bugzilla.kernel.org/> <20080325152809.e2b07251.akpm@linux-foundation.org> <20080326003912.GB3313@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326003912.GB3313@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> fb drivers are using ioremap()/ioremap_nocache(), followed by mtrr_add 
> with WC attribute. Recent changes in page attribute code made both 
> ioremap()/ioremap_nocache() mappings as UC (instead of previous UC-). 
> This breaks the graphics performance, as the effective memory type is 
> UC instead of expected WC.
> 
> The correct way to fix this is to add ioremap_wc() (which uses UC- in 
> the absence of PAT kernel support and WC with PAT) and change all the 
> fb drivers to use this new ioremap_wc() API.
> 
> We can take this correct and longer route for post 2.6.25. For now, 
> revert back to the UC- behavior for ioremap/ioremap_nocache.

thanks Suresh, applied.

	Ingo

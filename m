Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYCDKtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYCDKtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 05:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYCDKtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 05:49:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59545 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbYCDKtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 05:49:12 -0500
Date: Tue, 4 Mar 2008 11:48:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: "Huang, Ying" <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: early_res and find_e820_area for i386?
Message-ID: <20080304104853.GA19022@elte.hu>
References: <1204601883.4707.96.camel@caritas-dev.intel.com> <200803041141.28404.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803041141.28404.ak@suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> On Tuesday 04 March 2008 04:38:03 Huang, Ying wrote:
> 
> > Is it better to implement early_res and find_e820_area on i386? Can 
> > we trust E820 table on i386?
> 
> The 64bit code is certainly more flexible and cleaner, but also much 
> more complicated.. [...]

i disagree, the early_res stuff is still quite unclean, and what we want 
do do is to get rid of it, not promote it into 32-bit code ... (The 
reason we merged the early_res stuff in 2.6.25 was because it was 
certainly cleaner than the horrible open-coded reservations that the 
64-bit code did before. So now we at least have a more less visible 
enumeration of reservations.)
 
The correct and clean clean solution is what hpa mentioned: to do 
reservations in the e820 space. I think hpa has some code for that 
already and we should merge that. Peter?

	Ingo

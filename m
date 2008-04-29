Return-Path: <linux-kernel-owner+w=401wt.eu-S1759765AbYD2Mfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765AbYD2Mfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbYD2Mfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:35:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54723 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759139AbYD2Mff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:35:35 -0400
Date: Tue, 29 Apr 2008 14:35:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] disable softlockup detection at boottime
Message-ID: <20080429123522.GK31271@elte.hu>
References: <20080423201613.GA8546@sgi.com> <20080428165544.GE18210@elte.hu> <20080428185252.GC1167@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428185252.GC1167@sgi.com>
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


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> On Mon, Apr 28, 2008 at 06:55:44PM +0200, Ingo Molnar wrote:
> > 
> > good idea - but why dont you set softlockup_thresh to 0, which is the 
> > "off" switch already? (and that way it can be turned back on later as 
> > well, by the sysadmin.)
> > 
> 
> I'm getting unaligned access errors trying to set it to anything, so 
> it's not working for me currently (2.6.25):
> 
> It's tripping up on the address of 'one', which is an int that is not 
> properly aligned for the unsigned long comparison in 
> proc_doulongvec_minmax on my 64 bit machine.  Also, the value '0' is 
> invalid for softlockup_thresh, correct?
> 
> I temporarily got around these issues with the following hack.

ah, sorry. But ... perhaps using threshold -1 would be the most 
intuitive setting? (for 'infinite timeout' ==> softlockup detector 
turned off) That way it all becomes configurable as part of the 
threshold? No strong opinion though.

	Ingo

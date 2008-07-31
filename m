Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbYGaQ4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbYGaQ4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYGaQzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:55:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59400 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbYGaQzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:55:53 -0400
Date: Thu, 31 Jul 2008 18:55:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Clemens Ladisch <clemens@ladisch.de>, lkml <linux-kernel@vger.kernel.org>,
       bob.picco@hp.com, venkatesh.pallipadi@intel.com,
       Vojtech Pavlik <vojtech@suse.cz>,
       the arch/x86 maintainers <x86@kernel.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [patch 2.6.27-rc1] /dev/hpet - fixes and cleanup
Message-ID: <20080731165519.GA8631@elte.hu>
References: <200807221508.56672.david-b@pacbell.net> <200807280127.22060.david-b@pacbell.net> <488D8D16.7010502@ladisch.de> <200807291247.38869.david-b@pacbell.net> <20080731164658.GG26393@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731164658.GG26393@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> I suspect this is a 2.6.27 change, given its fix nature, but it will 
> need some cooking in linux-next (via auto-timers-next) before this can 
> be sent to Linus.

-tip testing found a build failure caused by this patch:

  drivers/built-in.o: In function `hpet_alloc':
  : undefined reference to `__udivdi3'
  drivers/built-in.o: In function `hpet_alloc':
  : undefined reference to `__umoddi3'

with:

  http://redhat.com/~mingo/misc/config-Thu_Jul_31_18_46_31_CEST_2008.bad

Please send a delta fix, i've already applied your previous patch and 
pushed it out, you can get that tree via:

  http://people.redhat.com/mingo/tip.git/README

... and do something like:

  git-checkout tip/timers/hpet

The last commit is yours.

Thanks,

	Ingo

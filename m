Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYCZWZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYCZWZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYCZWZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:25:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36656 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbYCZWZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:25:03 -0400
Date: Wed, 26 Mar 2008 23:24:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Mayer <ajm@sgi.com>
Cc: torvalds@linux-foundation.org,
       linux-kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86_64: resize NR_IRQS for large machines (re-submit)
Message-ID: <20080326222450.GA11621@elte.hu>
References: <20080326212312.GA27594@elte.hu> <Pine.SGI.3.96.1080326163708.7873204c-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SGI.3.96.1080326163708.7873204c-100000@fergus.americas.sgi.com>
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


* Alan Mayer <ajm@sgi.com> wrote:

> > but it doesnt really depart from the current status quo of huge 
> > [NR_IRQS] arrays either. Patches that make NR_IRQS a variable are 
> > welcome :)
> 
> Good luck with that.  If i come up with something that's elegant 
> enough to make it worth the risk, I'll let you know.  Changing NR_IRQS 
> to a variable touches every arch and a lot of drivers.  Someone is 
> bound to choke on it, so it has to be something worth fighting for.

well, i dont it has to be (or it should be) an all or nothing patch, 
given the complexity and risks involved.

- we should first introduce a nr_irqs variable and a Kconfig switch 
  (say CONFIG_ARCH_HAS_DYNAMIC_NR_IRQS) for architectures to toggle. If 
  the switch is toggled, nr_irqs is a variable, otherwise it's a carbon 
  copy of NR_IRQS. Some array-definition, declaration and initialization 
  wrappers are provided as well.

- then the core code, x86 and most drivers can be converted to nr_irqs.
  The switch might initially even be user-selectable if
  CONFIG_DEBUG_KERNEL, to ease regression testing.

- other architectures will follow one by one, fixing their
  arch-dependent drivers as well in the process

- finally we get rid of the wrappers.

	Ingo

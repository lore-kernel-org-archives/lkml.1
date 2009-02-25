Return-Path: <linux-kernel-owner+w=401wt.eu-S1762284AbZBYMJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284AbZBYMJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 07:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759379AbZBYMJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 07:09:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42926 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbZBYMJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 07:09:22 -0500
Date: Wed, 25 Feb 2009 13:08:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>, Thomas Gleixner <tglx@linutronix.de>,
       H Peter Anvin <hpa@zytor.com>, Keith Packard <keithp@keithp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] gpu/drm, x86, PAT: Add PAT support for
	io_mapping_* interface
Message-ID: <20090225120839.GC14279@elte.hu>
References: <20090225013510.010493000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225013510.010493000@intel.com>
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


* Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> io_mapping_create_wc(), io_mapping_free() and associated map/unmap routines
> are relatively new set of APIs for drivers, that change memory type.
> 
> Currently, these interfaces hardcode WC type on x86 and does not go through
> "PAT enforcement". This patchset adds PAT support for this interface.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

hm, the patches look sane and clean and mostly factor out 
existing code and checks and apply them to the io_mapping_*() 
interfaces - so it's something worth having for .29.

But it's all rather awfully late in the cycle and ioremap type 
of bugs typically have 1-2 rc's of latency to be fully 
discovered.

They will probably fix a few regressions and are easy to revert, 
plus they affect the one driver whose authors wrote these 
facilities:

  drivers/gpu/drm/i915/i915_dma.c
  drivers/gpu/drm/i915/i915_gem.c

so maybe we should try it as it's all a clear step forward. I'll 
give them a spin in tip:x86/urgent. Dunno.

Linus, do you have any preference?

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764454AbZDABb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764454AbZDABb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbZDABbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:31:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:3510 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbZDABbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:31:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,304,1235980800"; 
   d="scan'208";a="399225871"
Subject: Re: PAGE_CACHE_WC strikes again
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090331181251.46cf95b1@hobbes>
References: <1238544647.8369.682.camel@gaiman.anholt.net>
	 <20090331171431.69ad044f@hobbes>
	 <7E82351C108FA840AB1866AC776AEC4657F48B3E@orsmsx505.amr.corp.intel.com>
	 <1238547790.27006.7743.camel@localhost.localdomain>
	 <20090331181251.46cf95b1@hobbes>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 31 Mar 2009 17:30:24 -0800
Message-Id: <1238549424.27006.7757.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 18:12 -0700, Jesse Barnes wrote:
> Right, the drm driver code went in before we had pgprot_writecombine.
> Now that it's available we should definitely use it.  I'm not sure
> about the set_memory_* routines though; we create io mappings in
> i915_dma.c at init time, and I thought we took care of things in
> i915_gem.c but we may need updates there.

Jesse, yes i915_gem.c seems to be doing the right thing.

What about various fault handlers in drm_vm.c like drm_do_vm_shm_fault()
etc. None of these fault handlers require special attributes like wc/uc
etc?

thanks,
suresh


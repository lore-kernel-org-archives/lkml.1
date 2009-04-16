Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZDPX1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZDPX1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZDPX0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:26:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:36055 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbZDPX0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:26:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,200,1239001200"; 
   d="scan'208";a="507157229"
Subject: Re: [PATCH 4/8] irq: only update affinity in chip set_affinity()
 -v3
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <49E68CD8.7060009@kernel.org>
References: <49E68C41.4020801@kernel.org>  <49E68CD8.7060009@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 16 Apr 2009 16:25:38 -0700
Message-Id: <1239924338.27006.8458.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 18:41 -0700, Yinghai Lu wrote:
> Impact: keep affinity consistent
> 
> irq_set_affinity() and move_masked_irq() try to assign affinity
> before calling chip set_affinity(). some archs are assigning again in set_affinity
> again.
> 
> something like:
> cpumask_cpy(desc->affinity, mask);
> desc->chip->set_affinity(mask);
> 
> in the failing path, affinity should not be touched.
> 
> also set_extra_move_desc() ( called by set_affinity)  will rely on the old
> affinity to decide if need to move irq_desc to different node when logical
> flat apic mode is used.
> 
> So try remove those assignment, and make some missed arch to assign affinity
> in their set_affinity.
> 

I don't see any arch specific changes in this patchset regarding this.
Did I miss or currently there are no arch's that needs to get fixed?

thanks,
suresh


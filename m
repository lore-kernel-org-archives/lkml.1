Return-Path: <linux-kernel-owner+w=401wt.eu-S1763079AbXIUWEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763079AbXIUWEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760758AbXIUWEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:04:43 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:17110 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760363AbXIUWEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:04:42 -0400
X-IronPort-AV: E=Sophos;i="4.20,285,1186383600"; 
   d="scan'208";a="222865171"
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix printk levels in intel-rng
X-Message-Flag: Warning: May contain useful information
References: <20070921215351.GH11455@redhat.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 21 Sep 2007 15:04:40 -0700
In-Reply-To: <20070921215351.GH11455@redhat.com> (Dave Jones's message of "Fri, 21 Sep 2007 17:53:51 -0400")
Message-ID: <ada7imjy8sn.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Sep 2007 22:04:40.0698 (UTC) FILETIME=[68844DA0:01C7FC9B]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > [   41.250634] intel_rng: Firmware space is locked read-only. <4>intel_rng: If you can't or
 > [   41.250638]  don't want to <4>intel_rng: disable this in firmware setup, and <4>intel_rng: if
 > [   41.250639]  you are certain that your <4>intel_rng: system has a functional
 > [   41.250641]  RNG, try<4>intel_rng: using the 'no_fwh_detect' option.
 > [   41.250706] agpgart: AGP aperture is 128M @ 0xe8000000

 >  			KERN_WARNING PFX "Firmware space is locked read-only. If you can't or\n"
 > -			KERN_WARNING PFX "don't want to disable this in firmware setup, and if\n"
 > -			KERN_WARNING PFX "you are certain that your system has a functional\n"
 > -			KERN_WARNING PFX "RNG, try using the 'no_fwh_detect' option.\n";
 > +			PFX "don't want to disable this in firmware setup, and if\n"
 > +			PFX "you are certain that your system has a functional\n"
 > +			PFX "RNG, try using the 'no_fwh_detect' option.\n";

I think Alan already fixed this in f3dc8c18 -- notice that your
screwed-up message has the <4> after eg read-only, and the current
code doesn't line-wrap there.

 - R.

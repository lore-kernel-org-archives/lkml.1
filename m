Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbZCZJKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbZCZJKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbZCZJJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:09:47 -0400
Received: from mga05.intel.com ([192.55.52.89]:42781 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758065AbZCZJJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:09:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,425,1233561600"; 
   d="scan'208";a="676135708"
Message-ID: <49CB4677.9010403@linux.intel.com>
Date: Thu, 26 Mar 2009 10:10:15 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 1/3] x86, mce: Add mce_threshold option for intel
 cmci
References: <49CB3F24.8040804@jp.fujitsu.com>
In-Reply-To: <49CB3F24.8040804@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> This patch adds a kernel parameter "mce_threshold=n" to enable us
> to change the default threshold for CMCI(Corrected Machine Check
> Interrupt) that recent Intel processor supports.

I intentionally didn't implement this because it seemed not needed.

Any threshold in the actual error reporting should be implemented
in the user space processing backend, but not in the CPU, because
they typically need to be more fine grained than just per bank,
and the CPU cannot do that.

The only potential reason for implementing this threshold at the
CPU level is if someone is concerned about CPU consumption during error storms.
But then the threshold should be dynamically adjusted based on the
current rate, otherwise it doesn't help.

But I didn't do this so far because I didn't want to overengineer
and in general if you have a error storm you're likely soon dead
anyways.

Also even if this was implemented a boot option would seem
like the wrong interface compared to sysfs.

Can you please describe your rationale for this more clearly?

-Andi


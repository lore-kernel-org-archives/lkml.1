Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbZCALkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbZCALkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 06:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbZCALkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 06:40:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36985 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbZCALkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 06:40:06 -0500
Date: Sun, 1 Mar 2009 12:39:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [TIP,regression,i915] /dev/dri/card0 is no longer present
Message-ID: <20090301113948.GA3602@elte.hu>
References: <20090301110455.GA18547@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090301110455.GA18547@silver.sucs.org>
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


* Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> Hi,
> 
> With the latest -tip /dev/dri/card0 is MIA on my EeePC 900. A bisection
> has tracked the probem down to the following commit:
> 
> commit 17581ad812a9abb0182260374ef2e52d4a808a64
> Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Date:   Tue Feb 24 17:35:14 2009 -0800
> 
>     gpu/drm, x86, PAT: PAT support for io_mapping_*
> 
>     Make io_mapping_create_wc and io_mapping_free go through PAT to make sure
>     that there are no memory type aliases.
> 
>     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>     Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>     Cc: Dave Airlie <airlied@redhat.com>
>     Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>     Cc: Eric Anholt <eric@anholt.net>
>     Cc: Keith Packard <keithp@keithp.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Reverting this made /dev/dri/card0 reappear. Here is the 
> bisection log:

Thanks, i've reverted the commit for now. Could you please send 
a 'dmesg' from the bootup with the failed driver? By all 
likelyhood an ioremap failure causes a driver failure.

	Ingo

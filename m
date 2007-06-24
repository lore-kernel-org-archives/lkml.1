Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbXFXA4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbXFXA4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 20:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbXFXA4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 20:56:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:13212 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbXFXA4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 20:56:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,455,1175497200"; 
   d="scan'208";a="99522446"
Date: Sat, 23 Jun 2007 17:51:40 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>, linux-kernel@vger.kernel.org,
       ak@suse.de
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070624005140.GC25516@linux-os.sc.intel.com>
References: <20070606231642.GH13751@tree.beaverton.ibm.com> <20070619204929.GM9751@tree.beaverton.ibm.com> <20070619220812.GG7160@linux-os.sc.intel.com> <200706240154.53351.rjw@sisk.pl> <20070623165841.1c8f705c.akpm@linux-foundation.org> <m1abuq89ke.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1abuq89ke.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 06:45:05PM -0600, Eric W. Biederman wrote:
> 
> Hmm.  It looks like Siddha sent the wrong version of the patch.
> The working tested version had an additional test to ensure
> the mask and unmask methods were implemented.
> 
> i.e.
> +		if (irq_desc[irq].chip->mask)
> +			irq_desc[irq].chip->mask(irq);
> and
> 
> +		if (irq_desc[irq].chip->unmask)
> +			irq_desc[irq].chip->unmask(irq);
> +
> 
> Siddha think you can resend the correct version.

Eric, In this version, I added the irq_has_action() check and hence
removed the check which ensures the presence for mask/unmask. My tests
showed that it was working fine. May be I am missing something.

> 
> Rafael.  Think you can add those two ifs and see if you test bed box
> works?
> 
> I'm still not convinced that we can make fixup_irqs work in general
> but if we aren't going to yank it we should at least make it
> consistent with the rest of the code.

I agree.

thanks,
suresh

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYIWSeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYIWSeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYIWSeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:34:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:44313 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbYIWSeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:34:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,294,1220252400"; 
   d="scan'208";a="339649771"
Date: Tue, 23 Sep 2008 11:34:12 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH -tip/master] x86: io-apic - interrupt remapping fix
Message-ID: <20080923183411.GD25045@linux-os.sc.intel.com>
References: <20080919123320.GF7222@lenovo> <20080923005737.GA25045@linux-os.sc.intel.com> <20080923011620.GB25045@linux-os.sc.intel.com> <20080923045637.GA7172@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923045637.GA7172@localhost>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 09:56:37PM -0700, Cyrill Gorcunov wrote:
> [Suresh Siddha - Mon, Sep 22, 2008 at 06:16:21PM -0700]
> | On Mon, Sep 22, 2008 at 05:57:38PM -0700, Siddha, Suresh B wrote:
> | > On Fri, Sep 19, 2008 at 05:33:20AM -0700, Cyrill Gorcunov wrote:
> | > > Interrupt remapping could lead to NULL dereference in case of
> | > > kzalloc failed and memory leak in other way. So fix the
> | > > both cases.
> | > >
> | > > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> | > > ---
> | > >
> | > > Ingo, the patch is on top of applied one.
> | > >
> | > > If I remember correctly Suresh was involved in
> | > > this - so I think he could take a look and review
> | > > the patch (please).
> | > >
> | >
> | > Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> |
> | oops. Cyrill some typo here:
> |
> | +       for (; apic > 0; apic--)
> | +               kfree(early_ioapic_entries[apic]);
> | +       kfree(early_ioapic_entries[apic]);
> |
> 
> Hi Suresh, thanks for review!
> 
> Well it's not typo actually :) Of course it could
> be like
> 
>         for (--apic; apic > 0; apic--)
> or
>         for (apic--; apic > 0; apic--)
> 
> but it will be a rpoblem in case if apic = 0 and
> if someday apic would be unsigned int. So I prefered
> to have _one_ kfree(NULL) call instead :)
> 
> I hope i didn't miss anything.

This is too confusing. Please change it to something simple, like:

	for (i = 0; i < apic; i++)
		kfree(early_ioapic_entries[i]);

or

	for (apic = 0; apic < nr_ioapics; apic++)
		kfree(early_ioapic_entries[apic]);

thanks,
suresh

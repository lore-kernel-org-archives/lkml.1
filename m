Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbYIWE4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbYIWE4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 00:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYIWE4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 00:56:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:53336 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYIWE4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 00:56:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J4VKqh+20ybvJOgdjpwV3bNunXabPFf8L2/BI2mFg7O2NjmqdmTODudMP8mBbOvBl9
         XsBG2X5wE91/vgVw2hKpE2ByxWIJ8Zgn+tyNGZ1ns+M6UHnFZ32kMYMUlLGdV77M2w6h
         +w+O2keXNQaIR6ta/3PKLRQzWipvixxCg1Wcg=
Date: Tue, 23 Sep 2008 08:56:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH -tip/master] x86: io-apic - interrupt remapping fix
Message-ID: <20080923045637.GA7172@localhost>
References: <20080919123320.GF7222@lenovo> <20080923005737.GA25045@linux-os.sc.intel.com> <20080923011620.GB25045@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923011620.GB25045@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Suresh Siddha - Mon, Sep 22, 2008 at 06:16:21PM -0700]
| On Mon, Sep 22, 2008 at 05:57:38PM -0700, Siddha, Suresh B wrote:
| > On Fri, Sep 19, 2008 at 05:33:20AM -0700, Cyrill Gorcunov wrote:
| > > Interrupt remapping could lead to NULL dereference in case of
| > > kzalloc failed and memory leak in other way. So fix the
| > > both cases.
| > >
| > > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > > ---
| > >
| > > Ingo, the patch is on top of applied one.
| > >
| > > If I remember correctly Suresh was involved in
| > > this - so I think he could take a look and review
| > > the patch (please).
| > >
| > 
| > Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
| 
| oops. Cyrill some typo here:
| 
| +       for (; apic > 0; apic--)
| +               kfree(early_ioapic_entries[apic]);
| +       kfree(early_ioapic_entries[apic]);
|

Hi Suresh, thanks for review!

Well it's not typo actually :) Of course it could
be like

	for (--apic; apic > 0; apic--)
or
	for (apic--; apic > 0; apic--)

but it will be a rpoblem in case if apic = 0 and
if someday apic would be unsigned int. So I prefered
to have _one_ kfree(NULL) call instead :)

I hope i didn't miss anything.

		- Cyrill -

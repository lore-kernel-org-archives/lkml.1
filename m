Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbZFXVYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbZFXVYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbZFXVY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:24:26 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52259 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbZFXVY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:24:26 -0400
Date: Wed, 24 Jun 2009 14:24:24 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Gary Hade <garyhade@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
Message-ID: <20090624212424.GH7239@us.ibm.com>
References: <alpine.LFD.2.00.0906241715500.2767@localhost.localdomain> <1245859068.3216.5.camel@localhost.localdomain> <20090624161306.GC7239@us.ibm.com> <1245861219.3216.15.camel@localhost.localdomain> <20090624094411.08fc66e6@jbarnes-g45> <20090624175513.GE7239@us.ibm.com> <20090624112849.55b38fff@jbarnes-g45> <alpine.LFD.2.00.0906242043230.2767@localhost.localdomain> <20090624194839.GG7239@us.ibm.com> <4A4286F8.9020501@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4286F8.9020501@lwfinger.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 03:05:12PM -0500, Larry Finger wrote:
> Gary Hade wrote:
> > On Wed, Jun 24, 2009 at 08:45:31PM +0200, Thomas Gleixner wrote:
> >> Can we just bring the limit check back and increase the number for now
> >> until folks come up with a better solution ?
> > 
> > Another possible option is leaving in the limit check (still valid
> > IMO for correct behavior of previous 'pci=use_crs') and reverting
> >  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9e9f46c44e487af0a82eb61b624553e2f7118f5b
> > until the better solution for the fixed size array issue is
> > available.
> 
> Either increasing PCI_BUS_NUM_RESOURCES from 16 to 20 or 24

Yes, it looks to me like 20 might be the absolute minimum
that your system could tolerate.  The big mystery is how much
to increase it so we don't see the same problem on other
systems where _CRS may return some unknown amount more that
the 17 resources that are being returned on your system.

> or reverting f9cde5f will work for my system.

This would not be good without also reverting
9e9f46c44e487af0a82eb61b624553e2f7118f5b since devices
below the transparent bridge on your's and other's systems
may have trouble getting the resources they need.

Removing the check would only hide possibly more insidious
and difficult to debug problems that could show up later.
This was the main reason I provided the patch.  This kind
of check should have actually existed prior to
9e9f46c44e487af0a82eb61b624553e2f7118f5b when 'pci=use_crs'
was needed to enable use of the _CRS data.

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc


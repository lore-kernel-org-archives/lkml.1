Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbYAJJzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbYAJJzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758812AbYAJJzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:55:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:56815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758787AbYAJJzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:55:03 -0500
Date: Thu, 10 Jan 2008 10:55:01 +0100
From: Andi Kleen <ak@suse.de>
To: Dave Airlie <airlied@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080110095501.GL25945@bingen.suse.de>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu> <21d7e9970801100144x63b02e1bga548acd3c5bed441@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970801100144x63b02e1bga548acd3c5bed441@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 07:44:03PM +1000, Dave Airlie wrote:
> >
> > finally managed to get the time to review your CPA patchset, and i
> > fundamentally agree with most of the detail changes done in it. But here
> > are a few structural high-level observations:
> >
> > - firstly, there's no rationale given. So we'll change ioremap()/etc.
> >   from doing a cflush-range instruction instead of a WBINVD. But why?
> >   WBINVD isnt particular fast (takes a few msecs), but why is that a
> >   problem? Drivers dont do high-frequency ioremap-ing. It's typically
> >   only done at driver/device startup and that's it. Whether module load
> >   time takes 1254 msecs instead of 1250 msecs is no big deal.
> 
> read graphics drivers, even though I think we may avoid the whole path

You mean avoid change_page_attr() ? 

> if we can and end up doing some of this in the drivers
> when they know more about the situation so can avoid safeties..

Please explain, but it sounds very dubious.

> but I still see this being used in AGP a fair bit at some point on
> some drivers..

Well GARTs and those are widely used even without AGP busses.

-Andi

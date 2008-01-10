Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbYAJKUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbYAJKUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbYAJKU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:20:29 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:51877 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbYAJKU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:20:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gST1FjElLY4w11PW7kSmIjEyC4PTx3nywKnR5Sq4/nmOby3Nk55tyFwm28hupuOQ5soC+Vb1HWQOxYKDMxoqsdNB6sOD0nM1jVk04LFDmRPX2yzmJdqkTXDLISilDxUC+b2yzKBuMkxRmflAXLRESF2GJHEFexR4HKZFu26LORg=
Message-ID: <21d7e9970801100220p406b25d8qf523388042531855@mail.gmail.com>
Date: Thu, 10 Jan 2008 20:20:26 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: CPA patchset
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, "Arjan van de Ven" <arjan@infradead.org>,
       "Dave Jones" <davej@redhat.com>
In-Reply-To: <20080110095501.GL25945@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu>
	 <21d7e9970801100144x63b02e1bga548acd3c5bed441@mail.gmail.com>
	 <20080110095501.GL25945@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 10, 2008 7:55 PM, Andi Kleen <ak@suse.de> wrote:
> On Thu, Jan 10, 2008 at 07:44:03PM +1000, Dave Airlie wrote:
> > >
> > > finally managed to get the time to review your CPA patchset, and i
> > > fundamentally agree with most of the detail changes done in it. But here
> > > are a few structural high-level observations:
> > >
> > > - firstly, there's no rationale given. So we'll change ioremap()/etc.
> > >   from doing a cflush-range instruction instead of a WBINVD. But why?
> > >   WBINVD isnt particular fast (takes a few msecs), but why is that a
> > >   problem? Drivers dont do high-frequency ioremap-ing. It's typically
> > >   only done at driver/device startup and that's it. Whether module load
> > >   time takes 1254 msecs instead of 1250 msecs is no big deal.
> >
> > read graphics drivers, even though I think we may avoid the whole path
>
> You mean avoid change_page_attr() ?

yes in some cases...

>
> > if we can and end up doing some of this in the drivers
> > when they know more about the situation so can avoid safeties..
>
> Please explain, but it sounds very dubious.

So on Intel 9xx hardware we know how to flush the whole pipe from chip
to chipset to RAM, so when in the Intel
 driver we can leave pages mapped cached, and just flush all stages
before having the GPU access them,

This is only possible as long as we know all the parts involved, for
example on AMD we have problems with that
over-eager prefetching so for drivers on AMD chipsets we have to do
something else more than likely using change_page_attr.

>
> Well GARTs and those are widely used even without AGP busses.

Yes mainly we have used this scheme with Intel GARTs (also the only
driver we have done with the new GPU system) by working closely with
Intel engineers..

Dave.

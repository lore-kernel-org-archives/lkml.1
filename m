Return-Path: <linux-kernel-owner+w=401wt.eu-S1760825AbZF2PqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825AbZF2PqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760764AbZF2Ppx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:45:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33908 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760746AbZF2Ppv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:45:51 -0400
Date: Mon, 29 Jun 2009 18:45:52 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH v3] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090629154552.GB8122@redhat.com>
References: <20090629132926.GB20289@redhat.com> <1246287519.27006.10660.camel@localhost.localdomain> <20090629151016.GA8122@redhat.com> <1246288505.27006.10666.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246288505.27006.10666.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 08:15:05AM -0700, Suresh Siddha wrote:
> On Mon, 2009-06-29 at 08:10 -0700, Gleb Natapov wrote:
> > On Mon, Jun 29, 2009 at 07:58:39AM -0700, Suresh Siddha wrote:
> > > Thinking more, probably we shouldn't remove this dependency. This might
> > > encourage people (knowingly or unknowingly) to enable x2apic without
> > > interrupt-remapping. Can we remove this? KVM mode will still work even
> > > if we fail to enable interrupt-remapping. So this shouldn't be an issue,
> > > correct?
> > > 
> > Yes, KVM will still work. I don't have strong fillings one way or the
> > other, but why mandate an option that is no longer mandatory. What
> > others think?
> 
> Only under the presence of KVM we are breaking this dependency. And
> typically the same kernel runs natively and under the presence of kvm
> correct. So thats why we shouldn't break this dependency.
> 
OK, I'll drop Kconfig part in the next version. Unless someone will
object till tomorrow. 

> 
> > > >  	ioapic_entries = alloc_ioapic_entries();
> > > >  	if (!ioapic_entries) {
> > > > -		pr_info("Allocate ioapic_entries failed: %d\n", ret);
> > > > -		goto end;
> > > > +		 pr_info("Allocate ioapic_entries failed\n");
> > > > +		 return;
> > > 
> > > 
> > > We should go to ir_failed ..
> > Why? There is not more ir_failed.
> 
> oops. Not literally. We should goto the point where we should report the
> x2apic or ir enabling failed and check for x2apic pre-enabled etc at the
> end.
> 
Ah, OK.

--
			Gleb.

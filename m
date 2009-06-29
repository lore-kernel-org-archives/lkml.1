Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbZF2PSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbZF2PSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZF2PSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:18:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:10692 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbZF2PSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:18:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,309,1243839600"; 
   d="scan'208";a="470513962"
Subject: Re: [PATCH v3] enable x2APIC without interrupt remapping under KVM
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Gleb Natapov <gleb@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
In-Reply-To: <20090629151016.GA8122@redhat.com>
References: <20090629132926.GB20289@redhat.com>
	 <1246287519.27006.10660.camel@localhost.localdomain>
	 <20090629151016.GA8122@redhat.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 29 Jun 2009 08:15:05 -0700
Message-Id: <1246288505.27006.10666.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 08:10 -0700, Gleb Natapov wrote:
> On Mon, Jun 29, 2009 at 07:58:39AM -0700, Suresh Siddha wrote:
> > Thinking more, probably we shouldn't remove this dependency. This might
> > encourage people (knowingly or unknowingly) to enable x2apic without
> > interrupt-remapping. Can we remove this? KVM mode will still work even
> > if we fail to enable interrupt-remapping. So this shouldn't be an issue,
> > correct?
> > 
> Yes, KVM will still work. I don't have strong fillings one way or the
> other, but why mandate an option that is no longer mandatory. What
> others think?

Only under the presence of KVM we are breaking this dependency. And
typically the same kernel runs natively and under the presence of kvm
correct. So thats why we shouldn't break this dependency.


> > >  	ioapic_entries = alloc_ioapic_entries();
> > >  	if (!ioapic_entries) {
> > > -		pr_info("Allocate ioapic_entries failed: %d\n", ret);
> > > -		goto end;
> > > +		 pr_info("Allocate ioapic_entries failed\n");
> > > +		 return;
> > 
> > 
> > We should go to ir_failed ..
> Why? There is not more ir_failed.

oops. Not literally. We should goto the point where we should report the
x2apic or ir enabling failed and check for x2apic pre-enabled etc at the
end.


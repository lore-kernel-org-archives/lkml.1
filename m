Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab0CDFgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 00:36:53 -0500
Received: from mga10.intel.com ([192.55.52.92]:49074 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751699Ab0CDFgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 00:36:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,579,1262592000"; 
   d="scan'208";a="777818139"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] [PATCH 5/7] xen: Make event channel work with PV extension of HVM
Date: Thu, 4 Mar 2010 13:37:26 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>, linux-kernel@vger.kernel.org,
       "xen-devel" <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com> <1267436315-24486-6-git-send-email-sheng@linux.intel.com> <4B8C6C0D.3070005@goop.org>
In-Reply-To: <4B8C6C0D.3070005@goop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003041337.26229.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 March 2010 09:38:21 Jeremy Fitzhardinge wrote:
> On 03/01/2010 01:38 AM, Sheng Yang wrote:
> > +
> > +		x86_platform.calibrate_tsc = xen_tsc_khz;
> > +		x86_platform.get_wallclock = xen_get_wallclock;
> > +		x86_platform.set_wallclock = xen_set_wallclock;
> > +
> > +		pv_apic_ops = xen_apic_ops;
> > +#ifdef CONFIG_X86_LOCAL_APIC
> > +		/*
> > +		 * set up the basic apic ops.
> > +		 */
> > +		set_xen_basic_apic_ops();
> > +		apic->write = xen_hvm_pv_evtchn_apic_write;
> 
> I'd just change the xen_apic_write to remove the WARN_ON, since you
> don't seem to care about it either.

So which code base I should make these patches against? We expect the patchset 
can be accepted in the Linux upstream soon after you pick it up.
> 
> >
> > -	exit_idle();
> > -	irq_enter();
> > +	/*
> > +	 * If is PV featured HVM, these have already been done
> > +	 */
> > +	if (likely(!xen_hvm_pv_evtchn_enabled())) {
> > +		exit_idle();
> > +		irq_enter();
> > +	}
> 
> In that case, rather than putting this conditional in the hot path, make
> an inner __xen_evtchn_do_upcall which is wrapped by the PV and HVM
> variants which do the appropriate things.  (And drop the pt_regs arg, I
> think.)

Seems we still need pt_regs to for handle_irq()?

-- 
regards
Yang, Sheng

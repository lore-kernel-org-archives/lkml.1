Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab0CBBZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 20:25:08 -0500
Received: from mga05.intel.com ([192.55.52.89]:4843 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751412Ab0CBBZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 20:25:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,563,1262592000"; 
   d="scan'208";a="777064484"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] [PATCH 0/7][v4] PV extension of HVM (Hybrid) for Xen
Date: Tue, 2 Mar 2010 09:26:03 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>, linux-kernel@vger.kernel.org,
       "xen-devel" <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com> <4B8C5ED9.1040109@goop.org>
In-Reply-To: <4B8C5ED9.1040109@goop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003020926.03512.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 March 2010 08:42:01 Jeremy Fitzhardinge wrote:
> On 03/01/2010 01:38 AM, Sheng Yang wrote:
> > I'd like to have your comments on this patch series. We think the patches
> > are prepared for check in pv_ops domU tree.
> >
> > The PV extension of HVM is started from real mode like HVM guest, but
> > also with a a range of PV features(e.g. PV halt, PV timer, event channel,
> > as well as PV drivers). So guest with this feature can takes the
> > advantages of both H/W virtualization and Para-Virtualization.

Thanks for the comments!
> 
> The PV device side of this has a lot of overlap with the older PV driver
> for HVM domains code.  Aside perhaps for the details of how
> interrupts/events are actually delivered, that seems like a completely
> distinct piece of work which could be done separately.

Yes. PV driver is not our core target. So leave it a little late is fine.

> Also, I'd like to see a clearer statement of what you're specifically
> trying to optimise for here.  What is inefficient in an unmodified HVM
> domain, and how do your patches address these things.  What measurements
> have you made?

The key issue we want to address is the overhead of LAPIC, especially EOI and 
other actions resulted in explicit vmexit. That is the overhead we want to 
eliminate. And evtchn seems like a perfect choice to us.

> 
> > The first two of the patchset imported several header file from Jeremy's
> > tree and Xen tree, respect to Jeremy and Keir's works.
> >
> > The whole patchset based on Linux upstream.
> >
> > You need a line like:
> >
> > cpuid = [ '0x40000002:edx=0x3' ]
> >
> > in HVM configuration file to expose hybrid feature to guest, and
> >
> > CONFIG_XEN
> >
> > in the guest kernel configuration file to enable the hybrid support.
> >
> > And the compiled image can be used as native/pv domU/hvm guest/pv feature
> > hvm kernel.
> >
> > Current the patchset support x86_64 only.
> 
> Please add a new config option for the new code, and make it dependent
> on x86-64, rather than scattering random #ifdef CONFIG_X86_64s around
> the code.  Make sure all the code is controlled by this CONFIG variable
> so it disappears in a 32-bit build (ideally by putting it into a new
> file where possible, and only building it when enabled).

Sure.
> 
> > I've discussed the vector-evtchn mapping with Stefano, and we agreed on
> > that it's more complex than we thought, and can't brought much benefit
> > for pvops domU. So there is no major change in this update.
> >
> > Change from v3:
> > 1. Rebase to Linux 2.6.33 release.
> 
> Why 2.6.33?  I'm currently working on 2.6.32; I intend to move to .33
> shortly, but .32 is a much more convenient base (particularly if you're
> interested in getting these changes into any distro kernels).
> 
> I rebased it to .32 without much effort.

OK.
> 
> 
> I'll make specific comments in the patches.

Thanks

-- 
regards
Yang, Sheng

> 
>      J
> 

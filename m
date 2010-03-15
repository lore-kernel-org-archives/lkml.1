Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936191Ab0COL74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 07:59:56 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:6965 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936177Ab0COL7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 07:59:55 -0400
X-IronPort-AV: E=Sophos;i="4.49,643,1262563200"; 
   d="scan'208";a="9945525"
Date: Mon, 15 Mar 2010 12:04:16 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Sheng Yang <sheng@linux.intel.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH][v9 4/6] xen/hvm: Xen PV extension of HVM
 initialization
In-Reply-To: <201003150945.09548.sheng@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1003151108151.27222@kaball-desktop>
References: <1268362647-5317-1-git-send-email-sheng@linux.intel.com> <1268362647-5317-5-git-send-email-sheng@linux.intel.com> <4B9AA5A9.20609@goop.org> <201003150945.09548.sheng@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010, Sheng Yang wrote:
> > > +#ifdef CONFIG_XEN_HVM_PV
> > > +
> > > +#define XEN_HVM_PV_CLOCK_ENABLED   (1u<<  0)
> > 
> > Why is this flag needed?  As far as I understand it, there's no real
> > underlying hypervisor change needed to make HVM access to pv clock
> > possible; its just a field in the shared_info's vcpu struct after all.
> > Even if you enable this feature unconditionally, the user can still
> > control whether the Xen clocksource is used with the "clocksource="
> > kernel command-line parameter.
> 
> But we should make sure Xen have ability to support such kind of operation. 
> The CPUID would show if Xen have such ability, and if it does, the feature 
> would be enabled unconditionally. Guest kernel always enable all features it 
> can do unconditionally, but Xen should offer the support for them.
>  

In my opinion once the guest knows that is running on Xen HVM (that is
from xen_cpuid_base() or xen_para_available()) it should assume
that the pv clocksource is available, therefore XEN_HVM_PV_CLOCK_ENABLED
should not be needed.
In other words the mere presence of Xen should imply
XEN_HVM_PV_CLOCK_ENABLED.


> > Also, there's nothing about this which is 64-bit specific is there?
> 
> 64 bit things are mostly evtchn/interrupt related. I think no such limit here. 
> But I think it's better to do it step by step, so leave it after evtchn 
> solution settled.
> 

Do you mean write generic code now, then introduce the 64 bit
limitation later? Or the other way around?
I don't have a strong opinion here so I am OK with both approaches, but
I would prefer to add the limitation later (maybe we'll be able to make
it work on 32 bit too...).


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab0BILxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 06:53:05 -0500
Received: from smtp.citrix.com ([66.165.176.89]:27767 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab0BILw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 06:52:59 -0500
X-IronPort-AV: E=Sophos;i="4.49,436,1262581200"; 
   d="scan'208";a="7119844"
Subject: Re: [PATCH 5/7] xen: Make event channel work with PV featured HVM
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Sheng Yang <sheng@linux.intel.com>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1265616354-7384-6-git-send-email-sheng@linux.intel.com>
References: <1265616354-7384-1-git-send-email-sheng@linux.intel.com>
	 <1265616354-7384-6-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 9 Feb 2010 11:52:56 +0000
Message-ID: <1265716376.24394.32669.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 08:05 +0000, Sheng Yang wrote:
> +       if (xen_hvm_pv_evtchn_enabled()) {
> +               if (enable_hvm_pv(HVM_PV_EVTCHN))
> +                       return -EINVAL;
> +[...]
> +               callback_via = HVM_CALLBACK_VECTOR(X86_PLATFORM_IPI_VECTOR);
> +               set_callback_via(callback_via);
> +
> +               x86_platform_ipi_callback = do_hvm_pv_evtchn_intr; 

Why this indirection via X86_PLATFORM_IPI_VECTOR?

Apart from that why not use CALLBACKOP_register subop CALLBACKTYPE_event
pointing to xen_hypervisor_callback the same as a full PV guest?

This would remove all the evtchn related code from HVMOP_enable_pv which
I think should be eventually unnecessary as an independent hypercall
since all HVM guests should simply be PV capable by default -- the
hypervisor only needs to track if the guest has made use of specific PV
functionality, not the umbrella "is PV" state.

Ian.



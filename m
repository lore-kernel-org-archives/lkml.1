Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab0CBJWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 04:22:21 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:13329 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab0CBJWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 04:22:19 -0500
X-IronPort-AV: E=Sophos;i="4.49,565,1262581200"; 
   d="scan'208";a="86274862"
Subject: Re: [Xen-devel] [PATCH 3/7] xen/hvm: Xen PV extension of  HVM
 initialization
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Sheng Yang <sheng@linux.intel.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <201003020938.53630.sheng@linux.intel.com>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>
	 <1267436315-24486-4-git-send-email-sheng@linux.intel.com>
	 <4B8C63B0.2090507@goop.org>  <201003020938.53630.sheng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 2 Mar 2010 09:22:15 +0000
Message-ID: <1267521735.11737.23107.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 01:38 +0000, Sheng Yang wrote:
> 
> A annoy thing in pv drivers is that it would test if the domain type
> is _NOT_ XEN_NATIVE. So set the domain to XEN_HVM_DOMAIN would result
> in PV driver initialization then probably panic. 

What _actually_ panics?

Registration of the frontend devices should be completely harmless
(apart from a little wasted RAM) unless a xenbus driver manages to come
up and enumerate the xen bus and cause the ->probe function run.

You should be gating the xenbus startup on the availability of PV
functionality not the individual driver registrations. This keeps the
test in a single easy to maintain place.

Compare with pci_register_driver and all of the callers of that function
-- not a single one of them has an "is_pci_available" test anywhere.

Ian.


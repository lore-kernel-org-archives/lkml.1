Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0BBQsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 11:48:19 -0500
Received: from mga06.intel.com ([134.134.136.21]:56335 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756295Ab0BBQsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 11:48:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,391,1262592000"; 
   d="scan'208";a="592496225"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [PATCH 6/6] xen/hybrid: Enable grant table and xenbus
Date: Wed, 3 Feb 2010 00:46:41 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-17-generic; KDE/4.3.2; x86_64; ; )
Cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1265098747-10117-1-git-send-email-sheng@linux.intel.com> <201002022124.41019.sheng@linux.intel.com> <1265127844.24394.613.camel@zakaz.uk.xensource.com>
In-Reply-To: <1265127844.24394.613.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002030046.41799.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 February 2010 00:24:04 Ian Campbell wrote:
> On Tue, 2010-02-02 at 13:24 +0000, Sheng Yang wrote:
> > I am not sure if I understand you right, but I think the issue is,
> > there is no PVonHVM drivers in Linux upstream. The drivers are
> > currently maintained by OSVs, and the one in Xen upstream code only
> > support 2.6.18. So I didn't take them into consideration at the time.
> 
> True, but this is something which should be taken care of by the core
> Xen-aware code not something which should be pushed down into each
> driver.
> 
> Someone who wants to add PVonHVM functionality shouldn't have to go and
> remove a bunch of conditionals from each driver (or worse add
> alternative clauses to each check!).
> 
> > I think the "xen_evtchn_enable()" looks much better. Would replace
> > these ugly lines in the next version.
> 
> I think it would be cleaner to encapsulate this in the evtchn code
> rather than leaking platform knowledge into each driver. IOW the evtchn
> functions should return failure if event channels are not enabled and
> the driver should cope with this gracefully.

Agree. That what I suppose to do. What the drivers should only know is, if 
event channel is enabled. 

> Or perhaps at the xenbus driver level we should be deciding whether or
> not we have enough paravirtualisation to be worth probing the drivers at
> all?

I think current scheme is direct enough for now. We can improve it later.

-- 
regards
Yang, Sheng

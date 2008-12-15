Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbYLOQpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbYLOQpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 11:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbYLOQpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 11:45:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:31006 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103AbYLOQpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 11:45:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,224,1228118400"; 
   d="scan'208";a="474112869"
Subject: Re: [RFC PATCH 09/12] clocksource: allow usage independent of
	timekeeping.c
From: Patrick Ohly <patrick.ohly@intel.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
In-Reply-To: <1229358410.8699.13.camel@jstultz-laptop>
References: <1229352899-31330-1-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-2-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-3-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-4-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-5-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-6-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-7-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-8-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-9-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-10-git-send-email-patrick.ohly@intel.com>
	 <1229358410.8699.13.camel@jstultz-laptop>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 17:45:00 +0100
Message-Id: <1229359500.18038.234.camel@ecld0pohly>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-15 at 16:26 +0000, John Stultz wrote:
[cyclecounter/timecounter]
> Nice. The cyclecounter struct can work as a good base that I can shift
> the clocksource bits over to as I clean that up.
> 
> We will probably want to split this out down the road, but for now its
> small enough and related enough that I think its fine in the
> clocksource.h/c.
> 
> Also since Magnus has been working on it, does enable/disable accessors
> in the cyclecounter struct make sense for your hardware as well?

I don't think so. The usage model of the cyclecounter is that the
hardware is owned by someone who initializes and controls it, including
enable/disable. The abstract API with the read method is just there so
that common utility code can access the hardware in a uniform way.

For example, the igb driver owns and uses the NIC time register.
Disabling the NIC timer should be done together with disabling the NIC.
This is different from traditional clocksources which are independent
and controlled by the timing subsystem.

> Also the corner cases on overflows (how we manage the state, should
> reads be deferred for too long) will need to be addressed, but I guess
> we can solve that when it becomes an issue. Just to be clear: none of
> the hardware you're submitting this round has wrapping issues?

It has 64 bit registers, so there is indeed no wrapping issue.

> Otherwise,
> Acked-by: John Stultz <johnstul@us.ibm.com>

Thanks, will add that.

Can you (or someone else) also look at clocksync.[ch]? David wanted to
have that independently reviewed, too, before including it in
netdev-next.



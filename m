Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZAaORZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZAaORZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 09:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZAaORQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 09:17:16 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45870 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZAaORP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 09:17:15 -0500
Date: Sat, 31 Jan 2009 14:17:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH B 04/10] OMAP3 PRCM: add DPLL1-5 powerdomains, clockdomains; mark clocks
Message-ID: <20090131141703.GJ1394@n2100.arm.linux.org.uk>
References: <20090128024301.27240.39391.stgit@localhost.localdomain> <20090128024415.27240.58514.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128024415.27240.58514.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 07:44:18PM -0700, Paul Walmsley wrote:
> Each DPLL exists in its own powerdomain (cf 34xx TRM figure 4-18) and
> clockdomain; so, create powerdomain and clockdomain structures for them.
> Mark each DPLL clock as belonging to their respective DPLL clockdomain.
> cf. 34xx TRM Table 4-27 (among other references).

I don't really see the need to mark all these clocks as having a domain.
Yes, it makes sense to mark the actual DPLL clocks themselves with the
relevent DPLL domain.  However, it makes no sense to mark the children
as well.

Why?  When we enable a clock, we walk up the tree enabling the domains
first.  So, even if we're enabling a child clock, we will walk the tree
up to the DPLL and enable the clock domain before we do anything at all.

Sure, if a clock has a multiplexer and that multiplexer is in a different
clock domain from its parent, it makes sense to.  But otherwise it doesn't.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZA2RmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZA2RmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZA2RmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:42:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46054 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZA2RmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:42:04 -0500
Date: Thu, 29 Jan 2009 17:41:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 08/14] OMAP clock: move rate recalc, propagation code up to plat-omap/clock.c
Message-ID: <20090129174153.GH18233@n2100.arm.linux.org.uk>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192748.29333.5856.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128192748.29333.5856.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:27:51PM -0700, Paul Walmsley wrote:
> Previously the individual clock recalculation functions handled their
> own rate recalculation.  This can be handled in the clk_set_rate(),
> clk_set_parent(), and recalculate_root_clocks() functions in
> plat-omap/clock.c.  Removes duplicate code and clarifies the role of the
> recalc functions.

I must say that this commit looks very much like a combination of
my commits from November:

[ARM] omap: move clock propagation into core omap clock code
[ARM] omap: remove unnecessary calls to propagate_rate()
[ARM] omap: move propagate_rate() calls into generic omap clock code

which do basically the same thing a little more efficiently, and an
additional patch from you to call ->recalc after set_rate or
reparenting a clock.

So I think I can drop everything from this apart from the additional
recalc calls, and the removal of those omap2_dpllcore_recalc() calls.

Please confirm my suspicions.

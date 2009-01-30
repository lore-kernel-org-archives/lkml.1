Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZA3IxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZA3IxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZA3Iw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:52:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50796 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbZA3Iw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:52:58 -0500
Date: Fri, 30 Jan 2009 08:52:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 08/14] OMAP clock: move rate recalc, propagation code up to plat-omap/clock.c
Message-ID: <20090130085249.GB6864@n2100.arm.linux.org.uk>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192748.29333.5856.stgit@localhost.localdomain> <20090129174153.GH18233@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0901300135560.26985@utopia.booyaka.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901300135560.26985@utopia.booyaka.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 01:42:52AM -0700, Paul Walmsley wrote:
> I haven't looked closely at your above three patches for this, but plan to 
> do so later today.
> 
> Regarding provenance, the patches that I sent you were developed 
> independently, for clock notifier support.  Ultimately, I have no personal 
> attachment as to whose patches for this go in, if all technical aspects 
> are equal.

There's one bug that your version highlights in mine - the virtual mpu
clock in omap1 touches the DPLL and repropagates that rate.  I've
removed that repropagation, so that needs fixing.

However, this raises a question: why is the virtual mpu clock touching
some other part of the clock tree.  I wonder whether this should be
handled a different way, though the first thing that needs answering is
why we have this alias for 'arm_ck' ?

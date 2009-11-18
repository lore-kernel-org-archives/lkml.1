Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbZKRGBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbZKRGBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 01:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZKRGBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 01:01:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:47938 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbZKRGBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 01:01:47 -0500
Subject: Re: [PATCH 0/4] powerpc: Fix minor build issues on 2.6.32-rc7
 without CONFIG_XICS set
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: michael@ellerman.id.au
Cc: Mel Gorman <mel@csn.ul.ie>, linuxppc-dev@ozlabs.org,
       Michael Neuling <mikey@neuling.org>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1258462358.24093.83.camel@concordia>
References: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
	 <1258461544.24093.72.camel@concordia> <1258462358.24093.83.camel@concordia>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 17:00:56 +1100
Message-ID: <1258524056.2140.662.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 23:52 +1100, Michael Ellerman wrote:
> 
> In fact this series makes me wonder whether we can drop support for a
> single kernel image with pseries XICS & MPIC support.

Nope. Not happening. We should just hide CONFIG_XICS just like
CONFIG_MPIC, it should be select'ed by the platform (which today is only
pseries but that might change).

> If we could drop that requirement we could have a single set of names,
> ie. API, for the irq routines and build either the XICS or MPIC
> versions.

And so we would have the ability to build a kernel that supports in a
single binary every platform, as is the case today, ie, pseries,
powermac, pa6t, cell, etc... _BUT_ for pseries support, we would have to
choose at compile time whether to support old or new machines ? Sounds
backward to me :-)

> That would avoid all the code that needs a setup_foo_xics() and
> setup_foo_mpic() - it'd just be setup_foo(), implemented by either the
> XICS or MPIC code.

And that would save us what ? one page on a pSeries machine ? yeah !

Cheers,
Ben.


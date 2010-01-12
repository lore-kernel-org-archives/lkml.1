Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878Ab0ALJNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab0ALJNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563Ab0ALJNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:13:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41742 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab0ALJNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:13:32 -0500
Date: Tue, 12 Jan 2010 09:13:24 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC,PATCH 0/7 v2] Common struct clk implementation
Message-ID: <20100112091324.GC26435@n2100.arm.linux.org.uk>
References: <1263279511.160127.576969496193.0.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263279511.160127.576969496193.0.gpush@pororo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 05:58:31PM +1100, Jeremy Kerr wrote:
> The first two patches are for the architecture-independent kernel code,
> introducing the common clk API. The remaining patches are specific to
> the ARM 'versatile' and 'realview' platforms.

You're still only touching the "easy" platforms (as I pointed out
previously).  This is no real test of the new implementation.  To make
a decision on this based upon the easy implementations would be
completely wreckless.

As I said previously:

> Having struct clk be a set of function pointers gets really expensive on
> some platforms due to the shere number of struct clks - about 900; this
> will be a bar to them adopting this not only due to the size but the
> problems of ensuring correct initialisation.
> 
> Conversely, having those platforms use a pointer to a set of clk operations
> structures is also prohibitive - some operations such as enable and disable
> can be common, but the rest are extremely variable.

The 900 figure was the result of a bad grep - it's more around 220
for one OMAP CPU - if you include all OMAP CPUs which share the same
implementation then its around 600 clk structures that need to be
changed.

But the point I was trying to convey is that OMAP doesn't work with
_either_ a pure operations struct _or_ a bunch of per-clock function
pointers - it currently uses a mixture of the two.

Maybe this is because there was no proper classing of clocks (to
separate clock masking from clock muxing from PLLs, etc.)  The result
of this is that with a pure operations struct, you're likely to end
up with as many operations structures as there are clocks on OMAP.

The answer "OMAP shouldn't use this then" is not one I want to hear;
as I've already pointed out, OMAP is one of the platforms which should
use it.

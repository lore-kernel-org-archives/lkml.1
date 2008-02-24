Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbYBXLTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbYBXLTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 06:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYBXLTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 06:19:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35534 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbYBXLTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 06:19:12 -0500
Date: Sun, 24 Feb 2008 11:18:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>,
       Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 4/6] regulator: regulator core.
Message-ID: <20080224111813.GA15652@flint.arm.linux.org.uk>
References: <1203527351.4071.92.camel@localhost.localdomain> <20080223000538.e1f086e1.akpm@linux-foundation.org> <20080223095217.GA28356@flint.arm.linux.org.uk> <20080224102348.GA11156@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224102348.GA11156@sirena.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 10:23:49AM +0000, Mark Brown wrote:
> On Sat, Feb 23, 2008 at 09:52:17AM +0000, Russell King - ARM Linux wrote:
> > On Sat, Feb 23, 2008 at 12:05:38AM -0800, Andrew Morton wrote:
> 
> > > > +#undef current
> 
> > > err, no ;)  Please rename your stuff.
> 
> > Renaming is not an option - "current" is an electronic term for which
> > there is no alternative.  The real problem is this __ATTR macro crap:
> 
> Indeed, and this is already being worked around by
> drivers/power/power_supply_sysfs.c:
> 
> #define POWER_SUPPLY_ATTR(_name)                                        \
> {                                                                       \
>         .attr = { .name = #_name, .mode = 0444, .owner = THIS_MODULE }, \

My argument is - why bother with stuff like this, why not just pass
"_name" as the string itself, rather than using the preprocessor to
turn symbols into strings thereby suffering these nasty interactions.

It's not like "_name" is used for anything other than generating a
string.

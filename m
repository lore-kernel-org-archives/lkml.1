Return-Path: <linux-kernel-owner+w=401wt.eu-S1761818AbYBFKuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761818AbYBFKuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 05:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbYBFKuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 05:50:25 -0500
Received: from liberdade.minaslivre.org ([72.232.18.203]:41586 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637AbYBFKuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 05:50:24 -0500
Date: Wed, 6 Feb 2008 08:50:18 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
To: linux-kernel@vger.kernel.org
Cc: dwmw2@infradead.org
Subject: Re: [PATCH] power_supply: Remove capacity_level from list of sysfs
	attributes
Message-ID: <20080206105018.GB4232@vespa.holoscopio.com>
References: <20080205161327.GA8628@vespa.holoscopio.com> <20080206005312.237d7336.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206005312.237d7336.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 12:53:12AM -0800, Andrew Morton wrote:
> On Tue, 5 Feb 2008 14:13:36 -0200 Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org> wrote:
> 
> > ---
> >  drivers/power/power_supply_sysfs.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> > index d482484..13399d1 100644
> > --- a/drivers/power/power_supply_sysfs.c
> > +++ b/drivers/power/power_supply_sysfs.c
> > @@ -106,7 +106,6 @@ static struct device_attribute power_supply_attrs[] = {
> >  	POWER_SUPPLY_ATTR(energy_now),
> >  	POWER_SUPPLY_ATTR(energy_avg),
> >  	POWER_SUPPLY_ATTR(capacity),
> > -	POWER_SUPPLY_ATTR(capacity_level),
> >  	POWER_SUPPLY_ATTR(temp),
> >  	POWER_SUPPLY_ATTR(temp_ambient),
> >  	POWER_SUPPLY_ATTR(time_to_empty_now),
> 
> What is the reason for making this change?

Sorry. The following commit is the reason for this patch.

It removes CAPACITY_LEVEL from every other code, leaving the array with
sysfs attributes with one more entry than the number of enums in
power_supply.h. This leads to some attributes containing the value of
the attribute right after it. For example, temp_ambient would have the
value of time_to_empty_now. In my case, I had time_to_full_avg have the
value which should be in model_name, when the former was usually empty.

commit 8efe444038a205e79b38b7ad03878824901849a8
Author: Andres Salomon <dilinger@queued.net>
Date:   Wed Dec 12 14:12:56 2007 -0500

    power: remove POWER_SUPPLY_PROP_CAPACITY_LEVEL

    The CAPACITY_LEVEL stuff defines various levels of charge; however, what
    is the difference between them?  What differentiates between HIGH and NORMAL
    LOW and CRITICAL, etc?

    As it appears that these are fairly arbitrary, we end up making such policy
    decisions in the kernel (or in hardware).  This is the sort of decision that
    should be made in userspace, not in the kernel.

    If the hardware does not support _CAPACITY and it cannot be easily calculate
    then perhaps the driver should register a custom CAPACITY_LEVEL attribute;
    however, userspace should not become accustomed to looking for such a thing,
    and we should certainly not encourage drivers to provide CAPACITY_LEVEL
    stubs.

    The following removes support for POWER_SUPPLY_PROP_CAPACITY_LEVEL.  The
    OLPC battery driver is the only driver making use of this, so it's
    removed from there as well.

    Signed-off-by: Andres Salomon <dilinger@debian.org>
    Signed-off-by: David Woodhouse <dwmw2@infradead.org>

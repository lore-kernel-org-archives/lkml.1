Return-Path: <linux-kernel-owner+w=401wt.eu-S935190AbYBGAtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935190AbYBGAtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934671AbYBGAiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:38:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39303 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933246AbYBGAiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:38:12 -0500
Date: Wed, 6 Feb 2008 16:36:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: cbouatmailru@gmail.com
Cc: cascardo@minaslivre.org, linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       dilinger@debian.org
Subject: Re: [PATCH] power_supply: Remove capacity_level from list of sysfs
 attributes
Message-Id: <20080206163656.02cfd170.akpm@linux-foundation.org>
In-Reply-To: <20080207000206.GA19739@zarina>
References: <20080205161327.GA8628@vespa.holoscopio.com>
	<20080206005312.237d7336.akpm@linux-foundation.org>
	<20080206105018.GB4232@vespa.holoscopio.com>
	<20080206135604.5473552c.akpm@linux-foundation.org>
	<20080207000206.GA19739@zarina>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 03:02:06 +0300
Anton Vorontsov <cbouatmailru@gmail.com> wrote:

> On Wed, Feb 06, 2008 at 01:56:04PM -0800, Andrew Morton wrote:
> > On Wed, 6 Feb 2008 08:50:18 -0200
> > Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org> wrote:
> > 
> > > On Wed, Feb 06, 2008 at 12:53:12AM -0800, Andrew Morton wrote:
> > > > On Tue, 5 Feb 2008 14:13:36 -0200 Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org> wrote:
> > > > 
> > > > > ---
> > > > >  drivers/power/power_supply_sysfs.c |    1 -
> > > > >  1 files changed, 0 insertions(+), 1 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> > > > > index d482484..13399d1 100644
> > > > > --- a/drivers/power/power_supply_sysfs.c
> > > > > +++ b/drivers/power/power_supply_sysfs.c
> > > > > @@ -106,7 +106,6 @@ static struct device_attribute power_supply_attrs[] = {
> > > > >  	POWER_SUPPLY_ATTR(energy_now),
> > > > >  	POWER_SUPPLY_ATTR(energy_avg),
> > > > >  	POWER_SUPPLY_ATTR(capacity),
> > > > > -	POWER_SUPPLY_ATTR(capacity_level),
> > > > >  	POWER_SUPPLY_ATTR(temp),
> > > > >  	POWER_SUPPLY_ATTR(temp_ambient),
> > > > >  	POWER_SUPPLY_ATTR(time_to_empty_now),
> > > > 
> > > > What is the reason for making this change?
> > > 
> > > Sorry. The following commit is the reason for this patch.
> > > 
> > > It removes CAPACITY_LEVEL from every other code, leaving the array with
> > > sysfs attributes with one more entry than the number of enums in
> > > power_supply.h. This leads to some attributes containing the value of
> > > the attribute right after it. For example, temp_ambient would have the
> > > value of time_to_empty_now. In my case, I had time_to_full_avg have the
> > > value which should be in model_name, when the former was usually empty.
> > > 
> > 
> > OK, thanks, I think I have enough material there to put together the final
> > patch.
> > 
> > Next time, please do cc the author of the change which you're fixing.  And
> > please do reply-to-all when working with kernel people, thanks.
> > 
> > I tagged this fix as needed-in-2.6.24.x as well.
> 
> Nope, I don't think 2.6.24.x needs this fix. Commit 8efe444038a205e79b,
> wasn't been in 2.6.24. Only 2.6.25-rc0 affected.
> 
> If applied to 2.6.24.x, it will break things.
> 

ah, OK, thanks.  git timestamps considered harmful.

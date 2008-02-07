Return-Path: <linux-kernel-owner+w=401wt.eu-S1762034AbYBGAmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762034AbYBGAmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933920AbYBGAUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:20:55 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:9113 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933916AbYBGAUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:20:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ndiukI0s9wVhV5NSoQvfBYoTgRj0Ga0iKOosnft0GF8QQLmEcQbagNYaHUG8y3UxeazMmZlYi5nBtRiL22t9lqYzjvigGb3VYpjNwVdnUF49kmh9W+WpkMOdKm9xgDIve4ZEF88Br5C/diuto2McY+Lxv75iEenDxEOecnOQAtg=
Date: Thu, 7 Feb 2008 03:02:06 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Andres Salomon <dilinger@debian.org>
Subject: Re: [PATCH] power_supply: Remove capacity_level from list of sysfs
	attributes
Message-ID: <20080207000206.GA19739@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080205161327.GA8628@vespa.holoscopio.com> <20080206005312.237d7336.akpm@linux-foundation.org> <20080206105018.GB4232@vespa.holoscopio.com> <20080206135604.5473552c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080206135604.5473552c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 01:56:04PM -0800, Andrew Morton wrote:
> On Wed, 6 Feb 2008 08:50:18 -0200
> Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org> wrote:
> 
> > On Wed, Feb 06, 2008 at 12:53:12AM -0800, Andrew Morton wrote:
> > > On Tue, 5 Feb 2008 14:13:36 -0200 Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org> wrote:
> > > 
> > > > ---
> > > >  drivers/power/power_supply_sysfs.c |    1 -
> > > >  1 files changed, 0 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> > > > index d482484..13399d1 100644
> > > > --- a/drivers/power/power_supply_sysfs.c
> > > > +++ b/drivers/power/power_supply_sysfs.c
> > > > @@ -106,7 +106,6 @@ static struct device_attribute power_supply_attrs[] = {
> > > >  	POWER_SUPPLY_ATTR(energy_now),
> > > >  	POWER_SUPPLY_ATTR(energy_avg),
> > > >  	POWER_SUPPLY_ATTR(capacity),
> > > > -	POWER_SUPPLY_ATTR(capacity_level),
> > > >  	POWER_SUPPLY_ATTR(temp),
> > > >  	POWER_SUPPLY_ATTR(temp_ambient),
> > > >  	POWER_SUPPLY_ATTR(time_to_empty_now),
> > > 
> > > What is the reason for making this change?
> > 
> > Sorry. The following commit is the reason for this patch.
> > 
> > It removes CAPACITY_LEVEL from every other code, leaving the array with
> > sysfs attributes with one more entry than the number of enums in
> > power_supply.h. This leads to some attributes containing the value of
> > the attribute right after it. For example, temp_ambient would have the
> > value of time_to_empty_now. In my case, I had time_to_full_avg have the
> > value which should be in model_name, when the former was usually empty.
> > 
> 
> OK, thanks, I think I have enough material there to put together the final
> patch.
> 
> Next time, please do cc the author of the change which you're fixing.  And
> please do reply-to-all when working with kernel people, thanks.
> 
> I tagged this fix as needed-in-2.6.24.x as well.

Nope, I don't think 2.6.24.x needs this fix. Commit 8efe444038a205e79b,
wasn't been in 2.6.24. Only 2.6.25-rc0 affected.

If applied to 2.6.24.x, it will break things.


Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2

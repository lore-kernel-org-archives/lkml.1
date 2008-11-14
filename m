Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYKNBSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYKNBSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYKNBS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:18:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625AbYKNBSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:18:25 -0500
Date: Thu, 13 Nov 2008 17:18:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: jarkko.nikula@nokia.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch 2.6.28-rc4] gpiolib: extend gpio label column width in
 debugfs file
Message-Id: <20081113171808.f617aa02.akpm@linux-foundation.org>
In-Reply-To: <200811131713.38340.david-b@pacbell.net>
References: <1226472973-16271-1-git-send-email-jarkko.nikula@nokia.com>
	<20081113170211.23bf0343.akpm@linux-foundation.org>
	<200811131713.38340.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 17:13:38 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Thursday 13 November 2008, Andrew Morton wrote:
> > On Wed, 12 Nov 2008 08:56:13 +0200
> > Jarkko Nikula <jarkko.nikula@nokia.com> wrote:
> > 
> > > There are already various drivers having bigger label than 12 bytes. Most
> > > of them fit well under 20 bytes but make column width exact so that
> > > oversized labels don't mess up output alignment.
> > 
> > Please provide before-and-after example output for this sort of change
> > so that we can better understand its effect.
> > 
> > > Signed-off-by: Jarkko Nikula <jarkko.nikula@nokia.com>
> 
> I meant to send:
> 
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> ... thanks Jarkko.
> 

OK.

> > > ---
> > >  drivers/gpio/gpiolib.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > > index faa1cc6..82020ab 100644
> > > --- a/drivers/gpio/gpiolib.c
> > > +++ b/drivers/gpio/gpiolib.c
> > > @@ -1134,7 +1134,7 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
> > >  			continue;
> > >  
> > >  		is_out = test_bit(FLAG_IS_OUT, &gdesc->flags);
> > > -		seq_printf(s, " gpio-%-3d (%-12s) %s %s",
> > > +		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s",
> > >  			gpio, gdesc->label,
> > >  			is_out ? "out" : "in ",
> > >  			chip->get
> > 
> > This is a non-backward-compatible change to a userspace interface.  It
> > looks like a pretty safe one, but this is always a fairly big deal.
> 
> Not really; this is for debugfs, and formats for debug data
> are not ABI-suitable.  Developers need the flexibility to
> change that stuff ...

Well that's what we like to say, but it's delusional.  If we add stuff
then later change it, other people's stuff will break.  Just as with sysfs,
procfs, syscalls, etc.

The only difference is that with debugfs we have this weaselly excuse to
get people off our backs.

> for example, they can *already* override
> the default format to show pullups/pulldowns, drive strength,
> polarity inversion, debouncing, and other hardware-specific goodies.
>  
> 
> > If we're going to make this change then we should backport it to
> > 2.6.27.x, 2.6.26.x and to 2.6.25.x to minimise the chance that someone
> > will write a parser which works on one kernel version and fails on
> > another.
> > 
> > David?  Thoughts?
> 
> This is explicitly not supported for ABI-ish purposes.
> 
> If they aren't even using those parenthesis to delimit things, I'd
> really need to question what happened to their grey cells!

True.

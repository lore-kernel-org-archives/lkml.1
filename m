Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbYJQCtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbYJQCtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 22:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYJQCtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 22:49:08 -0400
Received: from kroah.org ([198.145.64.141]:58992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751976AbYJQCtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 22:49:07 -0400
Date: Thu, 16 Oct 2008 19:45:03 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, avorontsov@ru.mvista.com,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [patch] gpiolib: fix oops in gpio_get_value_cansleep()
Message-ID: <20081017024503.GA30951@kroah.com>
References: <200810160845.22281.david-b@pacbell.net> <20081016161718.e05864da.akpm@linux-foundation.org> <200810161744.34005.david-b@pacbell.net> <20081016175449.4ba7ac02.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016175449.4ba7ac02.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 05:54:49PM -0700, Andrew Morton wrote:
> On Thu, 16 Oct 2008 17:44:33 -0700 David Brownell <david-b@pacbell.net> wrote:
> 
> > On Thursday 16 October 2008, Andrew Morton wrote:
> > > > From: David Brownell <dbrownell@users.sourceforge.net>
> > > > 
> > > > We can get the following oops from gpio_get_value_cansleep()
> > > > when a GPIO controller doesn't provide a get() callback:
> > > 
> > > We can, but do we? ;)
> > 
> > I think it's unlikely without the sysfs interface.
> > 
> > 
> > > iow: is this needed in any -stable release?
> > 
> > The bug has been there since 2.6.25 but nobody else seems
> > to have reported it.  Is the general policy to fix all
> > oopses that *could* appear?  I'd send it for 2.6.27-stable,
> > since that's got the sysfs hooks.  And older kernels if
> > bug likelihood isn't a major concern.
> 
> OK.  2.6.27 definitely (major distros are basing on that).
> 
> As for earlier kernels: I'd say so.  An oops is farily serious. 
> Although an oops in a sysfs handler tends to be fairly tame, as the
> code usually doesn't hold locks or many allocated resources.
> 
> Anyway - making decisions like this is why we pay stable@kernel.org the
> big bucks :)

"Pay"?  We get paid for this in something becides a full inbox?

I'm not holding my breath :)

Send us the git commit id when it's in Linus's tree and we'll see what
is needed to backport this or not.

thanks,

greg k-h

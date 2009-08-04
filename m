Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbZHDNqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbZHDNqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 09:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbZHDNqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 09:46:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51402 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbZHDNqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 09:46:17 -0400
Date: Tue, 4 Aug 2009 15:46:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, "dtor@mail.ru" <dtor@mail.ru>
Subject: Re: [PATCH V2 4/4] i8042: support async suspend and shutdown
Message-ID: <20090804134609.GK18974@elf.ucw.cz>
References: <1248404532.2670.112.camel@rzhang-dt> <20090724071411.GB10760@elf.ucw.cz> <1249291590.2670.263.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249291590.2670.263.camel@rzhang-dt>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > >  	panic_blink = i8042_panic_blink;
> > >  
> > >  	return 0;
> > >  
> > > + err_dev_async_unregister:
> > > +	dev_async_unregister(&i8042_platform_device->dev);
> > >   err_free_device:
> > >  	platform_device_put(i8042_platform_device);
> > >   err_unregister_driver:
> > 
> > I still do not like the interface: manually unregistering seems to be
> > ugly & error prone.
> > 
> hmm, yes, we can check device->dev_async and unregister it in driver
> core, at device_unregister time.
> 
> then I think we should rename the interfaces to:
> device_enable_async_action(dev, type),
> and device_disable_async_action(dev)
> so that they are more like driver core helper functions.
> what do you think?

Yes, that would be nicer.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

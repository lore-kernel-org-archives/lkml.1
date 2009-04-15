Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbZDODIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbZDODIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbZDODII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:08:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:57258 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbZDODIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:08:07 -0400
Date: Tue, 14 Apr 2009 20:09:52 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090414200952.1714f1c5@infradead.org>
In-Reply-To: <49E54B12.8040303@garzik.org>
References: <49E4FAC6.1030400@garzik.org>
	<20090414183807.3baf72ed@infradead.org>
	<49E546C4.1060001@garzik.org>
	<20090414194414.22c63728@infradead.org>
	<49E54B12.8040303@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 22:48:50 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Arjan van de Ven wrote:
> > On Tue, 14 Apr 2009 22:30:28 -0400
> > Jeff Garzik <jeff@garzik.org> wrote:
> > 
> >> Arjan van de Ven wrote:
> >>> This change just made it go faster enough for you to be out of
> >>> luck; fundamentally your userland needs to wait if the device it
> >>> wants is not there. 
> >> All these drivers are in-kernel, and the root device is passed via 
> >> command line.  There is no userland at that point, that needs to
> >> wait.
> > 
> > ok fair; but that does not change that the kernel does not know if a
> > device is coming.
> > Yes that sucks; sadly USB is just this way, you don't know when no
> > new devices will come from a certain bus.
> 
> Perhaps -- but I can say that kernels <= 2.6.27 booted with 100% 
> reliability.
> 
> Now, Kernels >= 2.6.28 always fail.
> d
> The ONLY variable is the kernel.

yes.
and you can get the old behavior back by just sticking an
msleep(100 * <number of USB ports you have minus one>); 
back in near the end of the boot.

that really is not the right answer.

by your argument if anything else gets faster and your system is then
booting too fast again that has to get reverted as well.

If there was some reasonable way to wait on USB scanning being done
we'd do that. Not a nanosecond doubt about that.

But since there isn't, this "race who's faster" is an unsolvable
problem other than by you saying "wait for root to be there please".

        rootwait        [KNL] Wait (indefinitely) for root device to show up.
                        Useful for devices that are detected asynchronously
                        (e.g. USB and MMC devices).

that option has been there for a really long time, and has technically be required
for your case. You got lucky so far by pure timing... until recently.
It's not nice to not boot suddenly, I sympathize with that. But there's nothing 
we can realistically do other than using the option that is there for exactly your case.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751911AbXBJWXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbXBJWXI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 17:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbXBJWXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 17:23:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35087 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbXBJWXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 17:23:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: NAK new drivers without proper power management?
Date: Sat, 10 Feb 2007 23:20:38 +0100
User-Agent: KMail/1.9.5
Cc: Arjan van de Ven <arjan@infradead.org>, nigel@nigel.suspend2.net,
       LKML <linux-kernel@vger.kernel.org>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171059433.8675.195.camel@laptopd505.fenrus.org> <20070210193851.GA3956@ucw.cz>
In-Reply-To: <20070210193851.GA3956@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702102320.39531.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, 10 February 2007 20:38, Pavel Machek wrote:
> Hi!
> 
> > > I don't think this is already done (feel free to correct me if I'm
> > > wrong)..
> > > 
> > > Can we start to NAK new drivers that don't have proper power management
> > > implemented? There really is no excuse for writing a new driver and not
> > > putting .suspend and .resume methods in anymore, is there?
> > 
> > to a large degree, a device driver that doesn't suspend is better than
> > no device driver at all, right?
> > now.. if you want to make the core warn about it, that's very fair
> 
> Well, driver that is broken on SMP is arguably better than no driver
> at all, yet we'd probably avoid merging that. It would be nice to
> start including suspend in 'must work' list...

What about this:

"If the device requires that, implement .suspend and .resume or at least
define .suspend that will always return -ENOSYS (then people will know they
have to unload the driver before the suspend).  Similarly, if you aren't sure
whether or not the device requires .suspend and .resume, define .suspend that
will always return -ENOSYS."

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King

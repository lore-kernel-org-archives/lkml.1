Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbYG3FZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbYG3FZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 01:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYG3FZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 01:25:18 -0400
Received: from smtp.knology.net ([24.214.63.101]:48331 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbYG3FZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 01:25:16 -0400
Subject: Re: [PATCH] typhoon: use request_firmware
From: David Dillow <dave@thedillows.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, becker@scyld.com,
       davidpmclean@yahoo.com, Jeff Garzik <jeff@garzik.org>,
       netdev <netdev@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1217347786.2885.11.camel@jaswinder.satnam>
References: <1217170232.3537.6.camel@jaswinder.satnam>
	 <1217209400.22789.47.camel@obelisk.thedillows.org>
	 <1217215009.2970.7.camel@jaswinder.satnam>
	 <1217248585.22789.58.camel@obelisk.thedillows.org>
	 <1217253260.17632.6.camel@jaswinder.satnam>
	 <1217295498.28682.16.camel@obelisk.thedillows.org>
	 <1217347786.2885.11.camel@jaswinder.satnam>
Content-Type: text/plain; charset=utf-8
Date: Wed, 30 Jul 2008 01:25:11 -0400
Message-Id: <1217395511.31350.6.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 21:39 +0530, Jaswinder Singh wrote:
> On Mon, 2008-07-28 at 21:38 -0400, David Dillow wrote:
> > This should move to either typhoon_init() or typhoon_init_one(). Putting
> > it in typhoon_init() means we waste memory when the module is loaded if
> > there is no typhoon NIC; putting it in typhoon_init_one() means it needs
> > protection from threaded probing, should that ever be put back in. Given
> > that most modern distros don't do probing by blinding loading modules,
> > typhoon_init() seems a safe bet.
> > 
> 
> Sorry Dave, I need tp->pdev so ﻿typhoon_init_one() seems better.
> I hope you do not mind this.

That's fine, and makes sense. However, you need to check if you've
already loaded it (typhoon_fw != NULL), so you don't leak memory if
there is more than one NIC. Part of me feels like there should be a
mutex around loading the firmware, to avoid surprises if PCI probing
gets multi-threaded again, but a comment to that effect may suffice for
now.

Also, if not adding a mutex, then this can be folded into
typhoon_init_one(), rather than living in a separate function. 

All in all, this is getting better, my reservations about the goal
aside.

Dave


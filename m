Return-Path: <linux-kernel-owner+w=401wt.eu-S932719AbXJTBqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbXJTBqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 21:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbXJTBqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 21:46:24 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:54652 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbXJTBqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:46:23 -0400
Date: Fri, 19 Oct 2007 18:46:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-git Kconfig regression
Message-Id: <20071019184607.06e1eef9.randy.dunlap@oracle.com>
In-Reply-To: <20071020012245.9B3FB23A5F7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20071020012245.9B3FB23A5F7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 18:22:45 -0700 David Brownell wrote:

> 	(Originally posted to kbuild-devel per MAINTAINERS, but
> 	that post was rejected since that is -- undocumented,
> 	sigh -- a members-only list.)

That mailing list is no longer used.  Today's git pull for kbuild
included this change:

 KCONFIG
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
-L:	kbuild-devel@lists.sourceforge.net
+L:	linux-kbuild@vger.kernel.org
 S:	Maintained


> Hi,
> 
> I noticed a regression, visible in the drivers/usb/gadget Kconfig;
> it seems to be quite recent.
> 
> That Kconfig hasn't changed (other than adding new drivers), and
> it's worked that way for several years now ... so the issue seems
> to be changes in menuconfig/kconfig/etc semantics.
> 
> The issue is that when USB_GADGET=m, it's no longer possible to
> configure peripheral controller drivers as modules ... the controller
> drivers can now only be configured for static linkage.
> 
> It should be making a choice of one of the controller drivers which
> could work on the target system, and allow that driver to be linked
> either as a module (ok iff USB_GADGET=m) or statically.
> 
> What's the deal here?

Hm, it does look very odd.  It looks like it has something to
do with <choice> working differently for some reason.

In xconfig, I set all of the View Options and when I click on one
of the periph. controllers, it says

	depends on =y && PCI

but if I back up to -git7, it says

	depends on <choice> && PCI

I'll keep looking.

---
~Randy

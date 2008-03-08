Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbYCHUkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbYCHUkn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 15:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbYCHUkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 15:40:36 -0500
Received: from aun.it.uu.se ([130.238.12.36]:54656 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbYCHUkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 15:40:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18386.63798.151688.687781@harpo.it.uu.se>
Date: Sat, 8 Mar 2008 21:38:14 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Greg KH <gregkh@suse.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 sysdev API problem
In-Reply-To: <20080308184717.GA7476@suse.de>
References: <18386.46903.998159.519599@harpo.it.uu.se>
	<20080308184717.GA7476@suse.de>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH writes:
 > On Sat, Mar 08, 2008 at 04:56:39PM +0100, Mikael Pettersson wrote:
 > > In kernels up to and including 2.6.24, it was possible to
 > > register-then-unregister a sysdev_class/sys_device pair
 > > multiple times. Starting with the 2.6.24-git1 kernel, doing
 > > so causes a warning
 > > 
 > > kobject (f88e96c8): tried to init an initialized object, something is seriously wrong
 > 
 > This is a warning only, I have a patch queued up to fix this.  I've
 > included it below.
 > 
 > > the second time the class/device pair is registered, followed
 > > soon thereafter by random BUG()s and a kernel panic.
 > 
 > That's odd.  I don't think that is related, but it might be.  Can you
 > try the patch and let me know if it still happens?

The patch silenced the warning, but I still got a BUG() in
cache_alloc_refill() shortly after loading the test module.

(The machine needs some activity before the BUG() happens,
a few sync;dmesg;ps commands suffice for me.)

If I change the test module to do the sysdev_register stuff
once in module_init and the unregister stuff once in module_exit,
as opposed to once per "session" using the device, then things
work fine and I can't crash the kernel even if I repeatedly
insmod and rmmod the module. This indicates that some other part
of the sysdev object's state, apart from the state_initialized
flag, must also be cleaned up in the unregister() path.

I'll continue investigating this tomorrow.

/Mikael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYA0GnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYA0GnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbYA0GnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:43:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792AbYA0GnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:43:12 -0500
Date: Sat, 26 Jan 2008 22:42:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@www.l.google.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
In-Reply-To: <200801261550.58337.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.00.0801262239550.3222@www.l.google.com>
References: <20080125071127.GA4860@kroah.com> <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org> <20080125194219.GA4596@suse.de> <200801261550.58337.rusty@rustcorp.com.au>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Jan 2008, Rusty Russell wrote:
> 
> module.c:1832 (in load_module)
> 
> 	if (find_module(mod->name)) {
> 		err = -EEXIST;
> 		goto free_mod;
> 	}
> 
> That's pretty early, and before this backtrace.
> 
> Even for simultaneous loads, there's a mutex which protects from here to the 
> list insertion.

My problem isn't trying to load the same module twice.

My problem is that the *driver* already exists (because it's compiled in), 
and has already initialized itself, and has already registered.

Then, initrd tries to load an old module for that driver.

So no simultaneous loading, no two modules, simple two *drivers* with the 
same module names - but one was compiled in, and the other will fail 
because it doesn't have the required linkages (ie it will failt the 
modversions checks).

But even before it fails the modversion checks, it apparently does various 
ugly things that clash with the built-in driver.

At least that seems to be the case.

		Linus

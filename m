Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbYEEFG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbYEEFG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 01:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYEEFGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 01:06:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819AbYEEFGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 01:06:19 -0400
Date: Sun, 4 May 2008 22:05:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: changeset: Make forced module loading optional
In-Reply-To: <200805051455.02723.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.10.0805042159230.32269@woody.linux-foundation.org>
References: <200805051455.02723.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 May 2008, Rusty Russell wrote:
> 
>    I'm trying to figure out how you did this.  So fedora builds unversioned 
> modules, and version (and vermagic) matched your kernel?  And you somehow 
> mixed them up?

I don't use modules much, so many of my kernels tend to have modules off 
entirely. However, the Intel wireless drivers used to not work when 
built-in (fixed now, but I still had a legacy config), so my laptop had 
modules enabled, and MODVERSIONS set.

And I don't build initrd's etc crap, very much on purpose. I want to 
replace the kernel, nothing else, so my /etc/grub.conf file just replaces 
the distro kernel with my own, and keeps everything else untouched.

>    I don't think relying on modversions is the complete answer here.  Perhaps 
> we should make modules_install blow away old modules?

Wouldn't help one whit, and is against my rules anyway. See above. I want 
my own kernel, no other changes. That means that I run the distro initrd, 
which has its modules for bringing stuff up with distro kernels.

And quite frankly, when I finally figured out what was going on, I was 
like *WHAT THE HELL*. That kernel/module.c code was absolute and utter 
crap in accepting modules that neither matched the kernel version 
signature (because it had CONFIG_MODVERSIONS) *nor* the actual versioned 
symbols (because the distro modules had been built without 
CONFIG_MODVERSIONS).

So no, I'm not at all interested in blowing away old modules. I'm 
interested in having a module loader that isn't complete and utter crap 
and bypasses all the sanity checks that it has.

Which is what that changeset basically does.

People can still set CONFIG_MODULE_LOAD_FORCE, but quite frankly, I 
suspect that anybody who does that is just insane and/or works with 
proprietary and broken modules. So it's off by default, and hopefully no 
distro will ever set it.

			Linus

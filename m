Return-Path: <linux-kernel-owner+w=401wt.eu-S1762964AbYCFLaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762964AbYCFLaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYCFLan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:30:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:56002 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbYCFLam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:30:42 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc3: 34TB vmalloc total -- overflow in /proc/meminfo?
Date: Thu, 6 Mar 2008 12:30:38 +0100
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080305090610.GA30024@atrey.karlin.mff.cuni.cz> <200803052331.42193.ak@suse.de> <20080306111408.GM13391@elte.hu>
In-Reply-To: <20080306111408.GM13391@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803061230.38171.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> but the first fundamental limit we'll hit on 64-bit is the 32-bit offset

31bit to be pedantic.

> limit of binaries - this affects kernel modules, the kernel image, etc. 

If that ever happens just -fPIC mode would need to be supported
and a proper PLT for the references between modules and kernel. It would complicate 
the module loader slightly, but not too much.

> We wont hit that anytime soon, but we'll eventually hit it. (user-space 
> will be the first i guess)

I recently submitted a patch to fix the 2GB limit for user space
binaries (missing O_LARGEFILE). I think it made it into .25.

Newer gcc/binutils support the large code model so you could actually
try to generate binaries that big :-) e.g. some of the rtl-to-C compilers
seem to generate huge code so it might be actually useful.

Also of course you can always split the executable into ~2GB shared libraries.

-Andi


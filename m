Return-Path: <linux-kernel-owner+w=401wt.eu-S1030374AbXBZRrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030374AbXBZRrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030375AbXBZRrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:47:25 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54977 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030374AbXBZRrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:47:23 -0500
Date: Mon, 26 Feb 2007 09:37:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephane Eranian <eranian@hpl.hp.com>
cc: Jiri Slaby <jirislaby@gmail.com>, Uwe Bugla <uwe.bugla@gmx.de>,
       akpm@linux-foundation.org, bunk@stusta.de, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, venkatesh.pallipadi@intel.com
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot
 be mounted without hanging up the whole system
In-Reply-To: <20070226172855.GB19403@frankl.hpl.hp.com>
Message-ID: <Pine.LNX.4.64.0702260935010.12485@woody.linux-foundation.org>
References: <20070224175424.176030@gmx.net> <45E2B88B.1090706@gmail.com>
 <45E2F8C5.3080905@gmail.com> <Pine.LNX.4.64.0702260741040.12485@woody.linux-foundation.org>
 <20070226172855.GB19403@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Feb 2007, Stephane Eranian wrote:
> 
> The same code was used for i386 but I think for both architectures, the patch
> is missing default_idle(). I believe deault idle should look as follows:

Side note - I'll revert it regardless.

We can re-merge it later after

 - it has been tested better

 - people have added code to make all the expensive stuff go away if there 
   are no idle notifiers registered (ie "enter_idle" should NOT set the 
   idle-notify bit unconditionally in the idle loop, it should set if only 
   if there are people who care.

As it is, that patch was not only apparently buggy, but even if you fix 
the actual bug, it's still broken from a performance angle.

		Linus

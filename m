Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbYDWF1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbYDWF1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 01:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYDWF1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 01:27:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:54432 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYDWF1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 01:27:39 -0400
Subject: Re: x86: 4kstacks default
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080419142329.GA5339@elte.hu>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	 <20080418142934.38ce6bf4.akpm@linux-foundation.org>
	 <20080419142329.GA5339@elte.hu>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 15:27:01 +1000
Message-Id: <1208928421.9060.22.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-04-19 at 16:23 +0200, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > >  config 4KSTACKS
> > >  	bool "Use 4Kb for kernel stacks instead of 8Kb"
> > > -	depends on DEBUG_KERNEL
> > >  	depends on X86_32
> > > +	default y
> > 
> > This patch will cause kernels to crash.
> 
> what mainline kernels crash and how will they crash? Fedora and other 
> distros have had 4K stacks enabled for years:
> 
>   $ grep 4K /boot/config-2.6.24-9.fc9
>   CONFIG_4KSTACKS=y
> 
> and we've conducted tens of thousands of bootup tests with all sorts of 
> drivers and kernel options enabled and have yet to see a single crash 
> due to 4K stacks. So basically the kernel default just follows the 
> common distro default now. (distros and users can still disable it)

Do we routinely test nasty scenarii such as a GFP_KERNEL allocation deep
in a call stack trying to swap something out to NFS ?

Ben.



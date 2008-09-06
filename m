Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbYIFUDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbYIFUDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 16:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYIFUDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 16:03:04 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63242 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752269AbYIFUDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 16:03:03 -0400
Date: Sat, 6 Sep 2008 21:02:22 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, yhlu.kernel@gmail.com
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for setup_IO_APIC_irqs
In-Reply-To: <20080906184914.GG21872@elte.hu>
Message-ID: <Pine.LNX.4.55.0809062052360.13851@cliff.in.clinika.pl>
References: <20080904183748.950151853@gmail.com>> <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com>
 <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo>
 <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo>
 <20080905183835.GA19215@elte.hu> <20080906101533.GA7273@lenovo>
 <Pine.LNX.4.55.0809061938250.13851@cliff.in.clinika.pl> <20080906184914.GG21872@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Sep 2008, Ingo Molnar wrote:

> >  Honestly, this one should probably use sprintf() or suchlike to avoid the
> > mess of printk() calls building a line of output from pieces.  It's quite
> > easy to calculate here what the maximum size of the buffer required could
> > be and automatic arrays can have variable size, so no need for the hassle
> > of heap management.  Calls to printk() without a trailing newline should
> > be avoided where possible as it messes up logging priority if a message
> > pops up from an interrupt inbetween.
> 
> hm, is it worth the trouble? This is during very early init.

 But is it really a trouble?  With an auto array the additional code is
minuscule -- mostly printk() calls replaced with sprintf() plus a variable
or two to maintain a pointer to the buffer which will go into registers
anyway.  Plus a pr_info("%s", buffer) or suchlike at the end.  I know 
laziness is a virtue, but you have to draw a line somewhere. ;)

 The benefit, apart from what I wrote above, is less chance of propagating
bad style to newcomers with each piece of such old code removed.

  Maciej

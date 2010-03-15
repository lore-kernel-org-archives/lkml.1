Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab0COEsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 00:48:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:33019 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab0COEsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 00:48:36 -0400
Subject: Re: 2.6.34-rc1: Badness at fs/proc/generic.c:316
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Christian Kujau <lists@nerdbynature.de>, linuxppc-dev@ozlabs.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <m2tysjw27p.fsf@whitebox.home>
References: <alpine.DEB.2.01.1003131544340.5493@bogon.housecafe.de>
	 <20100314065526.GA5353@x200>
	 <alpine.DEB.2.01.1003140336280.5493@bogon.housecafe.de>
	 <20100314112428.GA4142@x200>
	 <alpine.DEB.2.01.1003140431040.5493@bogon.housecafe.de>
	 <m2tysjw27p.fsf@whitebox.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Mar 2010 14:23:46 +1100
Message-ID: <1268623426.2209.109.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-14 at 12:51 +0100, Andreas Schwab wrote:
> Christian Kujau <lists@nerdbynature.de> writes:
> 
> > On Sun, 14 Mar 2010 at 13:24, Alexey Dobriyan wrote:
> >> Post "find /proc/device-tree" output.
> >
> > I did upload[0] a tarball of /proc/device-tree, please see below the 
> > "find" output.
> >
> > Indeed, there's a /cpus/PowerPC,G4@0/l2-cache and 
> > /cpus/PowerPC,G4@0/l2-cache#1 in the device-tree. However, from looking at 
> > the logfiles, the
> >
> >    device-tree: Duplicate name in /cpus/PowerPC,G4@0, renamed to "l2-cache#1"
> 
> That's a red herring, the real problem is this:
> 
> name 'pulses/rev'
> 
> Of course, this name cannot be found in /proc/device-tree, because it
> wasn't created.

You mean apple stuck a bloody "/" in a name property ? ARGH !

We should just add code to detect that and replace it with a "_" or
something...

Cheers,
Ben.



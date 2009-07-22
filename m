Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997AbZGVFSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbZGVFSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 01:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZGVFSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 01:18:04 -0400
Received: from waste.org ([66.93.16.53]:57427 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbZGVFSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 01:18:03 -0400
Subject: Re: [RFC] move __devinit or __init printk constant format strings
 to __devinitconst or __initdata?
From: Matt Mackall <mpm@selenic.com>
To: Joe Perches <joe@perches.com>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-embedded@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       David Woodhouse <dwmw2@infradead.org>, Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <1248238202.31365.576.camel@Joe-Laptop.home>
References: <1248211253.31365.337.camel@Joe-Laptop.home>
	 <1248212925.10466.143.camel@calx>
	 <1248213403.31365.343.camel@Joe-Laptop.home>
	 <1248217044.10466.202.camel@calx>
	 <1248217502.31365.381.camel@Joe-Laptop.home>
	 <4A665442.1010006@caviumnetworks.com>  <1248226085.10466.251.camel@calx>
	 <1248238202.31365.576.camel@Joe-Laptop.home>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 00:17:30 -0500
Message-Id: <1248239850.10466.277.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 21:50 -0700, Joe Perches wrote:
> On Tue, 2009-07-21 at 20:28 -0500, Matt Mackall wrote:
> > On Tue, 2009-07-21 at 16:50 -0700, David Daney wrote:
> > > It would be tricky, the string data from the entire compilation unit is 
> > > intermingled.  You would have to separate out only those strings 
> > > referenced from __init sections into their own section and fix up all 
> > > symbols and relocations that were affected.
> > Exactly. Annoying but not impossible.
> 
> But faster and likely easier to do once in source.

How long have you been hanging out here, Joe? You really thing it's
going to be EASY to push this change to literally thousands of drivers?
Your idea may work but it isn't pretty and also isn't an obvious big win
and is therefore going to hit a lot of friction from lots of different
people. It's already getting friction from me and I actually care about
this sort of thing.

That effort would be better spent working on something transparent,
automatic, and painless. Something people won't put up a fight about.

> > > Probably easier would be to use the plug-in feature that will be part of 
> > > GCC-4.5 (or will that be called GCC-5.0??), and create a special Linux 
> > > kernel GCC plug-in that just emits the __init literal strings to the 
> > > proper section to begin with.
> 
> Which is what the proposed marking would
> more or less do today.
> 
> > > We don't want the kernel to get left 
> > > behind in the GCC plug-in race.
> 
> Any guess when gcc 4.5/5.0 might become available?
> It's in stage 1 now.  Mid 2010 or so?
> 
> 4.4.0 was April 21, 2009
> 4.3.0 was March 5, 2008
> 4.2.0 was May 13, 2007
> 
> Could you please send me what you think is a
> reasonable .config for an embedded box.

Lots of devices have only MTD, JFFS, ethernet, and one other driver like
wifi.

-- 
http://selenic.com : development and support for Mercurial and Linux



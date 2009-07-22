Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZGVB3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZGVB3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 21:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZGVB3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 21:29:53 -0400
Received: from waste.org ([66.93.16.53]:40951 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757AbZGVB3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 21:29:52 -0400
Subject: Re: [RFC] move __devinit or __init printk constant format strings
 to __devinitconst or __initdata?
From: Matt Mackall <mpm@selenic.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Joe Perches <joe@perches.com>, linux-embedded@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       David Woodhouse <dwmw2@infradead.org>, Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <4A665442.1010006@caviumnetworks.com>
References: <1248211253.31365.337.camel@Joe-Laptop.home>
	 <1248212925.10466.143.camel@calx>
	 <1248213403.31365.343.camel@Joe-Laptop.home>
	 <1248217044.10466.202.camel@calx>
	 <1248217502.31365.381.camel@Joe-Laptop.home>
	 <4A665442.1010006@caviumnetworks.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 20:28:05 -0500
Message-Id: <1248226085.10466.251.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 16:50 -0700, David Daney wrote:
> Joe Perches wrote:
> > On Tue, 2009-07-21 at 17:57 -0500, Matt Mackall wrote:
> >> On Tue, 2009-07-21 at 14:56 -0700, Joe Perches wrote:
> >>> On Tue, 2009-07-21 at 16:48 -0500, Matt Mackall wrote:
> >>>> On Tue, 2009-07-21 at 14:20 -0700, Joe Perches wrote:
> >>>>> Is moving constant string formats to __devinitconst or __initdata
> >>>>> useful for embedded environments?
> >>>> Interesting notion, but not worth the trouble in my mind. I think it's
> >>>> more worthwhile to look into automatic such stuff in the build somehow.
> >>> I think it's not possible today to get gcc to mark
> >>> the format strings without source modification.
> >> Yep, that's why I specifically said 'build'. It can probably be done in
> >> a post-processing step with some ELF wizardry. 
> > 
> > Know any elven wizards?
> > 
> 
> It would be tricky, the string data from the entire compilation unit is 
> intermingled.  You would have to separate out only those strings 
> referenced from __init sections into their own section and fix up all 
> symbols and relocations that were affected.

Exactly. Annoying but not impossible.

> Probably easier would be to use the plug-in feature that will be part of 
> GCC-4.5 (or will that be called GCC-5.0??), and create a special Linux 
> kernel GCC plug-in that just emits the __init literal strings to the 
> proper section to begin with.  This wouldn't be unprecedented, the 
> Mozilla people already use their own extensions to GCC, and will 
> probably migrate to GCC plug-ins.  We don't want the kernel to get left 
> behind in the GCC plug-in race.

There are no doubt a number of things we could be doing with such
extensions.

-- 
http://selenic.com : development and support for Mercurial and Linux



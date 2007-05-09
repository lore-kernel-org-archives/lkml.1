Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbXEIP3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbXEIP3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbXEIP3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 11:29:38 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49595 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbXEIP3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 11:29:37 -0400
Date: Wed, 9 May 2007 20:59:13 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Pavel Machek <pavel@ucw.cz>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, rjw@sisk.pl,
       James.Bottomley@SteelEye.com, aneesh.kumar@gmail.com, drzeus@drzeus.cx,
       dwmw2@infradead.org, greg@kroah.com, mingo@elte.hu, neilb@suse.de,
       oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, vatsa@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 128/197] freezer: add try_to_freeze calls to all kernel threads
Message-ID: <20070509152913.GA16090@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200705090934.l499YTvX019783@shell0.pdx.osdl.net> <4641A5F1.5080901@s5r6.in-berlin.de> <20070509104949.GA8164@elf.ucw.cz> <4641B92D.1030909@s5r6.in-berlin.de> <20070509121641.GA27109@in.ibm.com> <4641CAAF.8060103@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4641CAAF.8060103@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 03:20:47PM +0200, Stefan Richter wrote:
> Gautham R Shenoy wrote:
> > freezer_exempt() as of now does what its name says. I.e, exempt the
> > thread from all kinds of freeze chills.
> > 
> > But with more subsystems using the process freezer, the exemption needs
> > to be event specific. There may be threads which should not be frozen 
> > for say kprobes, should be frozen for cpu-hotplug. This selective
> > freezing is not yet available. But it will be soon...
> 
> Thanks for the (necessary!) clarification.
> Let me point out that the usual process would be to replace
> 
> 	freezer_exempt(current);
> 	for (;;) {
> 		...;
> by
> 	freezer_exempt_for_io(current);
> 	for (;;) {
> 		try_to_freeze();
> 		...;
> 
> when or after freezer_exempt_for_io was implemented.
>

Well, a couple of RFC's have already been sent with this regard.
Most of these recent freezer changes resulted due to the discussions
that took place over  these RFC's.

This was the first attempt
http://lkml.org/lkml/2007/2/14/106

and a more recent one
http://lkml.org/lkml/2007/4/2/33

> But as it was submitted now, we are temporarily left with
> 
> 	freezer_exempt(current);
> 	for (;;) {
> 		try_to_freeze();  /* useless irritating no-op */
> 		...;
> 
> without any benefit.  (And this explanatory comment ^^^ wasn't even
> added; we only have the git log as explanation.)
> 
> As subsystem maintainer I have to trust now that "soon" actually means
> "soon" and not "RSN"; otherwise my responsibility would be to send a NAK.

Soon actually does mean soon :-) 

http://lkml.org/lkml/2007/4/27/616 was sent out recently. 
I am working on the Rafael's suggestions. 
The only thing holding these patches back is the fact that 
quite an amount of patches on the freezer/kthread front has gone in 
recently, which need more review and testing. 

Will keep you posted on the freezer developments from now on.

> -- 
> Stefan Richter
> -=====-=-=== -=-= -=--=
> http://arcgraph.de/sr/

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
